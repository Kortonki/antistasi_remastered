if (count hcSelected player > 1) exitWith {
	hint "You can only select one group to fast travel";
};

private _enemiesNearby = false;
private _minDistance = false;
private _isHCfastTravel = false;
private _group = group player;
if (count hcSelected player == 1) then {
	_group = hcSelected player select 0;
	_isHCfastTravel = true;
};
private _leader = leader _group;

{
	if (getpos _leader distance2D (getmarkerPos _x) <= 100) exitWith {
		_minDistance = true;
	};
} foreach ([["camp", "fia_hq"], "FIA"] call AS_location_fnc_TS);

if (!(_minDistance)) exitWith {hint "You can only fast travel from near HQ and camps"};

if ((_leader != player) and (!_isHCfastTravel)) exitWith {hint "Only a group leader can use fast travel"};

//I see no reason to limit this way
//if (({isPlayer _x} count units _group > 1) and (!_isHCfastTravel)) exitWith {hint "You cannot fast travel with other players in your group"};

if (player call AS_fnc_controlsAI) exitWith {hint "You cannot fast travel while you are controlling AI"};

if (vehicle player != player and {!(_isHCfastTravel)}) exitWith {hint "You can only fast travel without vehicles"};

/*private _unpreparedVehicles = false;
{
	if ((vehicle _x != _x) and ((isNull (driver vehicle _x)) or (!canMove vehicle _x) or (vehicle _x isKindOf "StaticWeapon"))) then {
		_unpreparedVehicles = true;
	};
} forEach units _group;

if (_unpreparedVehicles) exitWith {
	Hint "You cannot fast travel if you don't have a driver in all your vehicles or your vehicles cannot move";
};*/

{
		if ([_x, nil] call AS_fnc_enemiesNearby) exitWith {_enemiesNearby = true};
} foreach units _group;

if (_enemiesNearby) exitWith {Hint "You cannot use fast travel with enemies near the group fast traveling"};

////// First check done. Let us pick a position on the map

posicionTel = [];

if (_isHCfastTravel) then {hcShowBar false};
hint "Click on the zone you want to travel to";
openMap true;
onMapSingleClick "posicionTel = _pos;";

waitUntil {sleep 1; (count posicionTel > 0) or (not visiblemap)};
onMapSingleClick "";

private _positionTo = +posicionTel;
posicionTel = nil;

if (count _positionTo == 0) exitWith {};

private _location = _positionTo call AS_location_fnc_nearest;
private _positionTo = _location call AS_location_fnc_position;

private _validLocations = ([["camp", "fia_hq"], "FIA"] call AS_location_fnc_TS);
if !(_location in _validLocations) exitWith {
	hint "You can only fast travel to FIA camps and HQ";
	openMap [false,false];
};

_enemiesNearby = [_positionTo, AS_enemyDist] call AS_fnc_enemiesNearby;

if (_enemiesNearby) exitWith {
	Hint "You cannot use fast travel to a location with enemies nearby";
	openMap [false,false];
};

private _positionTo = [_positionTo, 10, random 360] call BIS_Fnc_relPos;

private _distance = round ((position _leader) distance2D _positionTo);

if (!_isHCfastTravel) then {
	disableUserInput true;
	cutText ["Fast traveling, please wait","BLACK",2];
	sleep 5; // wait some time
} else {
	hcShowBar false;
	hcShowBar true;
	hint format ["Moving group %1 to destination.", groupID _group];
	sleep 5; // wait some time
};

//Force spawn the location for a while to start the process.
private _forcedSpawn = false;
if !(_location call AS_location_fnc_spawned) then {
	_forcedSpawn = true;
	[_location,true] call AS_location_fnc_spawn;
	sleep 5; // wait for spawn of location
};

// put all units in the location
{
	private _unit = _x;
	vehicle _unit allowDamage false;
	private _position = _positionTo findEmptyPosition [1,50,typeOf _unit];
	_unit setPosATL _position;
	sleep 0.5; // findEmptyPosition needs time or it returns a non-empty position :(
	if !(_unit call AS_medical_fnc_isUnconscious) then {
			if (isPlayer leader _unit) then {_unit setVariable ["rearming",false]};
			_unit doWatch objNull;
			_unit doFollow leader _unit;
};

} forEach ((units _group) select {vehicle _x == _x and {_x distance2D _leader < 100}}); //Move only units who are  on foot near the leader

if (!_isHCfastTravel) then {
	disableUserInput false;
	cutText ["You arrived to destination","BLACK IN",3]
} else {
	hint format ["Group %1 arrived to destination",groupID _group]
};

//This toggles the forced spawn parameter. Normal spawn systems have taken over.
if (_forcedSpawn) then {
	[_location,true] call AS_location_fnc_despawn;
};
{vehicle _x allowDamage true} forEach units _group;

openMap false;
