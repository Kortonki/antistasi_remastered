if (count (["defend_location","defend_camp","defend_city"] call AS_mission_fnc_active_missions) != 0) exitWith {
	hint "You cannot rest while FIA is under attack";
};
if (count ("defend_hq" call AS_mission_fnc_active_missions) != 0) exitWith {
	hint "You cannot rest while FIA HQ is under attack";
};

if ([getMarkerPos "FIA_HQ", 500] call AS_fnc_enemiesNearby) exitWith {hint "You cannot rest with enemies near our units"};

private _all_around = false;
private _posHQ = getMarkerPos "FIA_HQ";
{
	if (_x distance _posHQ > 200) exitWith {_all_around = true};
} forEach (allPlayers - (entities "HeadlessClient_F"));

if _all_around exitWith {hint "All players must be around the HQ to rest"};

[] remoteExec ["AS_fnc_skipTime", 2];
