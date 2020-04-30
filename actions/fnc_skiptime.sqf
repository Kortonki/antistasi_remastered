#include "../macros.hpp"

if (count (["defend_location","defend_camp","defend_city"] call AS_mission_fnc_active_missions) != 0) exitWith {
	hint "You cannot rest while FIA is under attack";
};
if (count ("defend_hq" call AS_mission_fnc_active_missions) != 0) exitWith {
	hint "You cannot rest while FIA HQ is under attack";
};

if ([getMarkerPos "FIA_HQ", nil] call AS_fnc_enemiesNearby) exitWith {hint "You cannot rest with enemies near our units"};

private _all_around = false;
private _posHQ = getMarkerPos "FIA_HQ";
{
	if (_x distance2D _posHQ > 200) exitWith {_all_around = true};
} forEach (allPlayers - (entities "HeadlessClient_F"));

if _all_around exitWith {hint "All players must be around the HQ to rest"};

//Fail all current convoy missions
{
	private _mission = _x;

	private _location = _mission call AS_mission_fnc_location;
	private _position = _location call AS_location_fnc_position;

	//FAIL the mission naturally to avoid problems. Teleport mainvehicle to target

	[_mission, _position] spawn {
		params ["_mission", "_position"];
		waitUntil {sleep 0.5; ([_mission, "state_index"] call AS_spawn_fnc_get) == 2};
		private _mainVehicle = [_mission, "mainVehicle"] call AS_spawn_fnc_get;
		_mainVehicle setVehiclePosition [_position, [], 0, "NONE"];
		_mainVehicle forcespeed 0;
	};

} foreach ((call AS_mission_fnc_active_missions) select {"convoy" in _x});

fuego inflame true;
{
	_x playAction "SitDown";
} foreach allPlayers;

[] remoteExec ["AS_fnc_skipTime", 2];
