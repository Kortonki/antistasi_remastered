#include "macros.hpp"
AS_SERVER_ONLY("fnc_abandonFIAlocation.sqf");
private _type = _this call AS_location_fnc_type;

if (_type == "camp") then {
    campNames pushBack ([_this, "name"] call AS_location_fnc_get);
};

// transfer garrison to HC if spawned, otherwise dismiss

if (_this call AS_spawn_fnc_exists) then {
  [_this] call AS_fnc_garrisonRelease;
} else {

  private _garrison = [_this, "garrison"] call AS_location_fnc_get;
  {
    [_x, _this] call AS_fnc_dismissFIAgarrison;
  } foreach _garrison;

  [_this, false] call AS_location_fnc_knownLocations;
  _this call AS_location_fnc_remove;

  /*private _hq_garrison = "FIA_HQ" call AS_location_fnc_garrison;
  _hq_garrison append (_this call AS_location_fnc_garrison);
  ["FIA_HQ","garrison",_hq_garrison] call AS_location_fnc_set;*/

};

[0, 200] remoteExec ["AS_fnc_changeFIAmoney", 2];



hint "Location abandoned";
