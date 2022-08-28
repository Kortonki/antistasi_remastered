
private _fnc_initialize = {
	params ["_mission"];

	private _mapPosition = [_mission, "position"] call AS_mission_fnc_get;
	private _minesPositions = [_mission, "positions"] call AS_mission_fnc_get;

	private _tskTitle = "Minefield Deploy";
	private _tskDesc = format ["An Engineer Team has been deployed at your High command. Once they reach the position, they will start to deploy %1 mines in the area. Cover them in the meantime.",count _minesPositions];

	// marker for the task.
	private _mrk = createMarker [_mission, _mapPosition];
	_mrk setMarkerShape "ELLIPSE";
	_mrk setMarkerSize [100,100];
	_mrk setMarkerColor "ColorRed";
	_mrk setMarkerAlpha 0;

	[_mission, [_tskDesc, _tskTitle, _mrk], _mapPosition, "map"] call AS_mission_spawn_fnc_saveTask;
	[_mission, "resources", [taskNull, [], [], [_mrk]]] call AS_spawn_fnc_set;
};

private _fnc_spawn = {
	params ["_mission"];
	private _vehType = [_mission, "vehicle"] call AS_mission_fnc_get;

	private _task = ([_mission, "CREATED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;

	private _tam = 10;
	private _roads = [];
	while {count _roads == 0} do {
		_roads = getMarkerPos "FIA_HQ" nearRoads _tam;
		_tam = _tam + 10;
	};

	private _pos = position (_roads select 0) findEmptyPosition [1,30,_vehType];

	private _truck = _vehType createVehicle _pos;
	[_truck, "FIA"] call AS_fnc_initVehicle;



	private _group = createGroup ("FIA" call AS_fnc_getFactionSide);
	AS_commander hcSetGroup [_group];
	_group setVariable ["isHCgroup", true, true];
	_group setGroupId [format ["MineF_%1", round (diag_tickTime)]];

	_group addVehicle _truck;
	["Explosives Specialist", getMarkerPos "FIA_HQ", _group] call AS_fnc_spawnFIAUnit;
	["Explosives Specialist", getMarkerPos "FIA_HQ", _group] call AS_fnc_spawnFIAUnit;
	{[_x] remoteExec ["AS_fnc_initUnitFIA", _x]; [_x] orderGetIn true} forEach units _group;
	leader _group setBehaviour "SAFE";
	_truck allowCrewInImmobile true;

	private _markers = ([_mission, "resources"] call AS_spawn_fnc_get) select 3;
	[_mission, "resources", [_task, [_group], [_truck], _markers]] call AS_spawn_fnc_set;

};

private _fnc_wait_to_arrive = {
	params ["_mission"];
	private _mapPosition = [_mission, "position"] call AS_mission_fnc_get;
	private _group = (([_mission, "resources"] call AS_spawn_fnc_get) select 1) select 0;
	private _truck = (([_mission, "resources"] call AS_spawn_fnc_get) select 2) select 0;
	private _mrk = (([_mission, "resources"] call AS_spawn_fnc_get) select 3) select 0;

	private _arrivedSafely = false;
	waitUntil {sleep 1;
		_arrivedSafely = (_truck distance2D _mapPosition < 100) and ({alive _x} count units _group > 0);
		(!alive _truck) or _arrivedSafely
	};

	// once it arrives, we lose control of it.
	if (isPlayer leader _group) then {
		[] remoteExec ["AS_fnc_completeDropAIcontrol", leader _group];
		hint "";
	};
	AS_commander hcRemoveGroup _group;

	if _arrivedSafely then {
		[petros, "sidechat", "Engineers are now deploying the mines."] remoteExec ["AS_fnc_localCommunication", [0, -2] select isDedicated];
		// [leader _group, _mrk, "SAFE","SPAWNED", "NOVEH2",  "SHOWMARKER"] spawn UPSMON; //COMMMENTED OUT: UPSMON could interfere with HC
	} else {
		([_mission, "FAILED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
		[_mission, "status", "completed"] call AS_mission_fnc_set; //this changed to contain mission name only

	};

	[_mission, "arrivedSafely", _arrivedSafely] call AS_spawn_fnc_set;
};

private _fnc_wait_to_deploy = {
	params ["_mission"];
	private _mapPosition = [_mission, "position"] call AS_mission_fnc_get;
	private _mines_cargo = [_mission, "mines_cargo"] call AS_mission_fnc_get;
	private _minesPositions = [_mission, "positions"] call AS_mission_fnc_get;
	private _group = (([_mission, "resources"] call AS_spawn_fnc_get) select 1) select 0;
	private _truck = (([_mission, "resources"] call AS_spawn_fnc_get) select 2) select 0;
	private _arrivedSafely = [_mission, "arrivedSafely"] call AS_spawn_fnc_get;

	if _arrivedSafely then {
		// simulates putting mines.
		//sleep (20*(count _minesPositions));


		if ((alive _truck) and ({alive _x} count units _group > 0)) then {
			// create minefield
			private _minesData = [];
			private _current_mine_index = 0;
			private _current_mine_amount = 0;
			private _units = units _group;

			//Make engineers disembark
			{[_x] orderGetin false; [_x] allowGetin false} foreach _units;

			{

				if (!(alive _truck and {({alive _x} count _units) > 0})) exitWith {
					[petros, "sidechat", "Engineers got either killed or interrupted, minefield partially complete"] remoteExec ["AS_fnc_localCommunication", AS_commander];

					//Recover unused mines to the truck

					if (alive _truck) then {

						for "_i" from _current_mine_index to ((count _mines_cargo select 0) - 1) do {
							_truck addMagazineCargoGlobal [(_mines_cargo select 0) select _i, ((_mines_cargo select 1 select _i) - _current_mine_amount)];
							_current_mine_amount = 0;
						};

					};
				};
				sleep (25/(({alive _x and {!(_x call AS_medical_fnc_isUnconscious)}} count _units) + 0.5));

				private _mineType = _mines_cargo select 0 select _current_mine_index;
				private _typeCount = _mines_cargo select 1 select _current_mine_index;

				_minesData pushBack [_mineType call AS_fnc_mineVehicle, _x, random 360];
				_current_mine_amount = _current_mine_amount + 1;

				if (_current_mine_amount == _typeCount) then {
					_current_mine_index = _current_mine_index + 1;
					_current_mine_amount = 0;
				};
			} forEach _minesPositions;
			[_mapPosition, "FIA", _minesData] call AS_fnc_addMinefield;


			([_mission, "SUCCEEDED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
			[_mission, "status", "completed"] call AS_mission_fnc_set; //this changed to contain mission name only
			["mis"] call fnc_BE_XP;

			{[_x] orderGetin true; [_x] allowGetin true} foreach _units;
		} else {
			([_mission, "FAILED"] call AS_mission_spawn_fnc_loadTask) call BIS_fnc_setTask;
			[_mission, "status", "completed"] call AS_mission_fnc_set; //this changed to contain mission name only

		};
	};
};

private _fnc_clean = {
	params ["_mission"];
	private _group = (([_mission, "resources"] call AS_spawn_fnc_get) select 1) select 0;
	private _truck = (([_mission, "resources"] call AS_spawn_fnc_get) select 2) select 0;

	_group setVariable ["isHCgroup", false, true];
	// _group setVariable ["UPSMON_Remove", true];
	[_group, getMarkerpos "FIA_HQ"] spawn AS_fnc_dismissFIAsquad; //Just dismiss usually, everythings recovered

	/*
	private _alive = 0;
	{
		if (alive _x) then {
			([_x, true] call AS_fnc_getUnitArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", "_magRemains"];
			[caja, _cargo_w, _cargo_m, _cargo_i, _cargo_b, true] call AS_fnc_populateBox;
			[cajaVeh, _magRemains] call AS_fnc_addMagazineRemains;
			_alive = _alive + 1;
		};
		[_x] remoteExec ["deleteVehicle", _x];
	} forEach units _group;

	if (alive _truck) then {
		// todo: make this depend on alive units

		private _fuel = _truck call AS_fuel_fnc_getVehicleFuel;

		if (_fuel >= (_truck call AS_fuel_fnc_returnTripFuel)) then {

		private _cost = [_mission, "cost"] call AS_mission_fnc_get;
		[_alive, _cost] remoteExec ["AS_fnc_changeFIAmoney",2];  // recover the costs

		//Approximate fuel for the return trip to base. Roughly 0,2 liter per 1km for a standard car, more for tanks etc.

		_fuel = _fuel - (_truck call AS_fuel_fnc_returnTripFuel);
		if (_truck call AS_fuel_fnc_getFuelCargoSize > 0) then {_fuel = _fuel + (_truck call AS_fuel_fnc_getFuelCargo);};
		[_fuel] remoteExec ["AS_fuel_fnc_changeFIAfuelReserves", 2];
		[_truck] remoteExec ["deleteVehicle", _truck];

		} else {
		[_alive, 0] remoteExec ["AS_fnc_changeFIAmoney",2];
		[_truck] spawn AS_fnc_activateVehicleCleanup;
		};
	} else {
		[_alive, 0] remoteExec ["AS_fnc_changeFIAmoney",2];
	};*/

	_mission call AS_mission_spawn_fnc_clean;
};

AS_mission_establishFIAminefield_states = ["initialize", "spawn", "wait_to_arrive", "wait_to_deploy", "clean"];
AS_mission_establishFIAminefield_state_functions = [
	_fnc_initialize,
	_fnc_spawn,
	_fnc_wait_to_arrive,
	_fnc_wait_to_deploy,
	_fnc_clean
];
