#include "macros.hpp"
AS_SERVER_ONLY("resourcesUpdate");

params [["_skipping", false]]; //this is for not spawning patrols while skipping time

//Xomment this out: is it really necessary? This function gets called as well
//if (isMultiplayer) then {waitUntil {sleep 10; isPlayer AS_commander}};

[_skipping] call AS_fnc_updateAll;
// update AAF economics.
[] call AS_fnc_spendAAFmoney;

// Assign new commander if needed.


if (!(_skipping)) then {
    [] call AS_mission_fnc_updateAvailable;

    [] call AS_movement_fnc_sendAAFroadPatrol;

    // Check if any communications were intercepted.
    [] call AS_fnc_revealFromAAFRadio;

    if isMultiplayer then {[] spawn AS_fnc_chooseCommander;};

};

// repair and re-arm all statics.
//TODO: optimise and improve this (check for nearby enemies etc.)
{
    private _veh = _x;
    if ((_veh isKindOf "StaticWeapon") and ({isPlayer _x} count crew _veh == 0) and (alive _veh)) then {
        _veh setDamage 0;
        [_veh,1] remoteExec ["setVehicleAmmoDef",_veh];
    };
} forEach (AS_P("vehicles"));

// update the counter by the time that has passed
//[-AS_resourcesLoopTime] call AS_fnc_changeSecondsforAAFattack;

// start AAF attacks under certain conditions.
//This is done eleWhere
/*if (AS_P("secondsForAAFAttack") < 1) then {
    private _noWaves = isNil {AS_S("waves_active")};
    if ((count ("aaf_attack" call AS_mission_fnc_active_missions) == 0) and _noWaves) then {
        private _script = [] spawn AS_movement_fnc_sendAAFattack;
        waitUntil {sleep 5; scriptDone _script};
    };
};*/
