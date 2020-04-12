
#include "../../macros.hpp"
/*params ["_type", "_position"];
private _roads = _position nearRoads 50;
if (_type == "roadblock" and count _roads == 0) exitWith {
    hint "Roadblocks have to be positioned close to roads";
};
if (count ("establish_fia_location" call AS_mission_fnc_active_missions) != 0) exitWith {
    hint "We are already building a location";
};

[_type, _position] call AS_fnc_addFIAlocation;*/

params ["_type"];

if (AS_P("resourcesFIA") < 200) exitWith {hint "Not enough money, 200€ needed"};

private _cap = BE_current_FIA_Camp_Cap;
switch (_type) do {
  case "roadblock" : {_cap = BE_current_FIA_RB_Cap};
  case "watchpost" : {_cap = BE_current_FIA_WP_Cap};
  default {};
};

if (count ([_type, "FIA"] call AS_location_fnc_TS) >= _cap) exitWith {hint "FIA cannot maintain more locations of this type"};

//Checks passed spawn the crate

[0, -200] remoteExec ["AS_fnc_changeFIAmoney", 2];


private _crate = objNull;

switch (_type) do {
  case "roadblock" : {
    private _crateType = "IG_supplyCrate_F";
    private _pos = (getMarkerPos "FIA_HQ") findEmptyPosition [1,50,_crateType];
    	if (!(isnull vehiclePad)) then  {_pos = getpos vehiclePad};
    _crate = _crateType createVehicle _pos;
    [_crate, "build_roadblock"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated, true];
    _crate setVariable ["requiredVehs", ["Truck_F"], true];
  };
  case "watchpost" : {
    private _crateType = "Box_NATO_Equip_F";
    private _pos = (getMarkerPos "FIA_HQ") findEmptyPosition [1,50,_crateType];
    	if (!(isnull vehiclePad)) then  {_pos = getpos vehiclePad};
    _crate = _crateType createVehicle _pos;
    [_crate, "build_watchpost"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated, true];
    _crate setVariable ["requiredVehs", ["Car"], true];
  };
  case "camp" : {
    private _crateType = "Box_NATO_Equip_F";
    private _pos = (getMarkerPos "FIA_HQ") findEmptyPosition [1,50,_crateType];
    	if (!(isnull vehiclePad)) then  {_pos = getpos vehiclePad};
    _crate = _crateType createVehicle _pos;
    [_crate, "build_camp"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated, true];
    _crate setVariable ["requiredVehs", ["Car"], true];
  };
  default {};
};

[_crate, "loadCargo"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated, true];
_crate setVariable ["asCargo", false, true];
_crate setVariable ["type", _type, true];//This type will be detected as location box and refunded upon save
[_crate] call AS_fnc_emptyCrate;
