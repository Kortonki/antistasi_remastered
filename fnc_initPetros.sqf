#include "macros.hpp"
AS_SERVER_ONLY("fnc_initPetros.sqf");

if (!isNil "petros") then {
  //Petros' weapons are lost when he's killed
    deleteVehicle petros;
    deleteGroup grupoPetros;
};

grupoPetros = createGroup ("FIA" call AS_fnc_getFactionSide);
petros = ["Squad Leader", getMarkerPos "FIA_HQ", grupoPetros] call AS_fnc_spawnFIAunit;
[petros, "FIA"] call AS_fnc_setSide;

[petros,"mission"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];

grupoPetros setGroupId ["Petros","GroupColor4"];
petros setName "Petros";
petros disableAI "MOVE";

removeHeadgear petros;
removeGoggles petros;
petros setSkill 1;

// rearmPetros depends on the arsenal weapons, which are defined afterwards
[] spawn {
    waitUntil {sleep 0.5; not isNil "Arsenal_initialized"};
    call AS_fnc_rearmPetros;
};

[petros] call AS_medical_fnc_initUnit;
/*petros addEventHandler ["HandleDamage",
        {
        private ["_part","_dam","_injurer"];
        _part = _this select 1;
        _dam = _this select 2;
        _injurer = _this select 3;

        if (isPlayer _injurer) then
            {
            //[_injurer,60] remoteExec ["AS_fnc_penalizePlayer",_injurer];
            //_dam = 0;
            };
        if ((isNull _injurer) or (_injurer == petros)) then {_dam = 0};
        if (_part == "") then
            {
            if (_dam > 0.90) then
                {
                if (!(petros call AS_medical_fnc_isUnconscious)) then
                    {
                    _dam = 0.9;
                    [petros, true] call AS_medical_fnc_setUnconscious;
                    };
                };
            };
        _dam
        }];*/

petros addMPEventHandler ["mpkilled", {
    removeAllActions petros;
    private _killer = _this select 1;
        diag_log format ["[AS] INFO: Petros died. Killer: %1", _killer];
        [] remoteExec ["AS_fnc_petrosDeath", 2];

}];

publicVariable "grupoPetros";
publicVariable "petros";
