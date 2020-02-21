#include "macros.hpp"
AS_SERVER_ONLY("fnc_initPetros.sqf");

if (!isNil "petros") then {

  //recover Petros' gear

  private _cargo_w = [[], []];
  private _cargo_m = [[], []];
  private _cargo_i = [[], []];
  private _cargo_b = [[], []];

  private _arsenal = [petros, true] call AS_fnc_getUnitArsenal;  // restricted to locked weapons
  _cargo_w = [_cargo_w, _arsenal select 0] call AS_fnc_mergeCargoLists;
  _cargo_m = [_cargo_m, _arsenal select 1] call AS_fnc_mergeCargoLists;
  _cargo_i = [_cargo_i, _arsenal select 2] call AS_fnc_mergeCargoLists;
  _cargo_b = [_cargo_b, _arsenal select 3] call AS_fnc_mergeCargoLists;
  [cajaVeh, (_arsenal select 4)]; call AS_fnc_addMagazineRemains;

  [caja, _cargo_w, _cargo_m, _cargo_i, _cargo_b] call AS_fnc_populateBox;

  deleteVehicle petros;
  deleteGroup grupoPetros;
};

grupoPetros = createGroup ("FIA" call AS_fnc_getFactionSide);
petros = ["Squad Leader", getMarkerPos "FIA_HQ", grupoPetros] call AS_fnc_spawnFIAunit;
[petros, "FIA"] call AS_fnc_setSide;
grupoPetros setCombatMode "GREEN";

publicVariable "grupoPetros";
publicVariable "petros";

[petros,"mission"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated, true];

grupoPetros setGroupId ["Petros","GroupColor4"];
petros setName "Petros";
petros disableAI "MOVE";

removeHeadgear petros;
removeGoggles petros;
petros setSkill 1;

// rearmPetros depends on the arsenal weapons, which are defined afterwards
[] spawn {
    waitUntil {sleep 0.5; not isNil "AS_Arsenal_initialized"};
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

petros addEventHandler ["killed", {
    [petros, "remove"] remoteExec ["AS_fnc_addAction", AS_CLIENTS];
    private _killer = _this select 1;
        diag_log format ["[AS] INFO: Petros died. Killer: %1", _killer];
        [] remoteExec ["AS_fnc_petrosDeath", 2];

}];
