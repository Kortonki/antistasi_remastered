#include "../../macros.hpp"

private _blownMine = {
	params ["_mine"];
	waitUntil {sleep AS_spawnLoopTime; isNull _mine or !(_location call AS_location_fnc_spawned)};
};

private _fnc_spawn = {
	params ["_location"];

	private _side = _location call AS_location_fnc_side;
	private _minesData = ([_location, "mines"] call AS_location_fnc_get);

	private _mines = [];
	{
		_x params ["_type", "_pos", "_dir"];
		private _mine = createMine [_type, _pos, [], 0];
		_mine setDir _dir;
		_mines pushBack _mine;
		_mine setVariable ["loc", _location]; //TODO consider if this must be synced

		_mine addEventHandler ["Killed", {
			params ["_mine"];
			private _location = _mine getVariable ["loc", ""];

			private _mines = ([_location, "mines"] call AS_spawn_fnc_get);
			private _minesData = ([_location, "mines"] call AS_location_fnc_get);

			private _index = _mines find _mine;

			//Delete the mine from both spawn and location

			_mines deleteAt _index;
			_minesData deleteAt _index;

			[_location, "mines", _mines] call AS_spawn_fnc_set;
			[_location, "mines", _minesData] call AS_location_fnc_set;

			[_location] call AS_location_fnc_updateMarker;

			}];

		(_side call AS_fnc_getFactionSide) revealMine _mine;
	} forEach _minesData;

	[_location, "mines", _mines] call AS_spawn_fnc_set;
};

private _fnc_clean = {
	params ["_location"];
	waitUntil {sleep AS_spawnLoopTime; !(_location call AS_location_fnc_spawned)};

	private _minesData = ([_location, "mines"] call AS_location_fnc_get);
	private _mines = [_location, "mines"] call AS_spawn_fnc_get;

	if ({!isNull _x} count _mines == 0) then {
		// if no mines left, delete location
		_location call AS_location_fnc_remove;
	} else {
		// else, remove the missing mines. leave this as failsafe to remove in addition to the eventhandler above
		for "_i" from 0 to (count _minesData - 1) do {
			if (isNull (_mines select _i)) then {
				_minesData deleteAt _i;
			};
		};
		([_location, "mines", _minesData] call AS_location_fnc_set);
	};

	{
		[_x] remoteExec ["deleteVehicle", _x];
	} forEach _mines;
};

AS_spawn_createMinefield_states = ["spawn", "clean"];
AS_spawn_createMinefield_state_functions = [
	_fnc_spawn,
	_fnc_clean
];
