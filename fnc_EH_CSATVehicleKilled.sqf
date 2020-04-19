params ["_veh", "_killer"];
if (([_veh] call AS_fnc_getSide) != "CSAT") exitWith {}; //If vehicle was stolen, there's nothing to do here
private _type = typeOf _veh;
private _effect = 0;

if ((isNull _killer) || (_killer == _veh)) then {
  if (!(isnil {_veh getVariable "vehLastDamageSource"})) then {
    _killer = _veh getVariable "vehLastDamageSource";
  };
};

if (_killer call AS_fnc_getSide in ["FIA", "NATO"]) then {
  if (_type in (["CSAT", "helis_transport"] call AS_fnc_getEntity)) then {_effect = 5};
  if (_type in (["CSAT", "helis_attack"] call AS_fnc_getEntity)) then {_effect = 10};
  if (_type in (["CSAT", "planes"] call AS_fnc_getEntity)) then {_effect = 10};
  if (_type in (["CSAT", "helis_armed"] call AS_fnc_getEntity)) then {_effect = 5};

  [0, -(_effect)] remoteExec ["AS_fnc_changeForeignSupport", 2];
  [-(_effect/2),(_effect/2), position _veh] remoteExec ["AS_fnc_changeCitySupport",2];
  if (_type in ((["CSAT", "helis_transport"] call AS_fnc_getEntity) + (["CSAT", "helis_attack"] call AS_fnc_getEntity) + (["CSAT", "helis_armed"] call AS_fnc_getEntity) + (["CSAT", "planes"] call AS_fnc_getEntity)) and {_killer call AS_fnc_getSide == "FIA"}) then {
    ["des_arm"] remoteExec ["fnc_BE_XP", 2];
    } else {
    ["des_veh"] remoteExec ["fnc_BE_XP", 2];
    };
};
