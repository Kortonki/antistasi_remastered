#include "../macros.hpp"
params ["_location","_box"]; //_box appears to be caja for all the calls
private _size = _location call AS_location_fnc_size;
private _position = _location call AS_location_fnc_position;
private _side = _location call AS_location_fnc_side;

if (_side == "FIA" or _location == "fia_hq") then {

//Weapons and stuff laying on the ground

{
    ([_x, true] call AS_fnc_getBoxArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", "_remains"];
    [_box, _cargo_w, _cargo_m, _cargo_i, _cargo_b, true] remoteExec ["AS_fnc_populateBox", 2];
    [cajaVeh, _remains] call AS_fnc_addMagazineRemains;
    [_x] RemoteExec ["deleteVehicle", _x];

} forEach nearestObjects [_position, ["WeaponHolderSimulated", "WeaponHolder"], _size];

//Dead soldiers. Activatecleanup overridden with this

{
    if not (alive _x) then {
        ([_x, true] call AS_fnc_getUnitArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", "_remains"];
        [_box, _cargo_w, _cargo_m, _cargo_i, _cargo_b, true] remoteExec ["AS_fnc_populateBox", 2];
        [cajaVeh, _remains] call AS_fnc_addMagazineRemains;
        _x call AS_fnc_emptyUnit;
        [_x] RemoteExec ["AS_fnc_safeDelete", _x]; //this changed to safe delete in case below picks up dead vehicle crew -> deleteVehicle would delete vehicle also
    };
} forEach (_position nearObjects ["Man", _size]);


//Loot boxes and vehicles
{
    private _veh = _x;

    if (_veh isKindOf "AllVehicles" and {_veh call AS_fnc_getside in ["AAF", "CSAT"] and {{alive _x} count (crew _veh) == 0 and {!(_veh in AS_P("vehicles"))}}}) then {
          [_veh] remoteExec ["AS_fnc_changePersistentVehicles", 2];
          [_veh, "FIA"] call AS_fnc_setSide;

          //IF vehicle is left there with cargo, it will looted in savegame at the latest
    };

    if (_veh isKindOf "B_supplyCrate_F" and {!(_veh in [caja, cajaVeh]) and {isnull(attachedTo _veh)}}) then { //Changed reammobox to supplycrate

      ([_veh, true] call AS_fnc_getBoxArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", "_remains"];
      [_box, _cargo_w, _cargo_m, _cargo_i, _cargo_b, true] remoteExec ["AS_fnc_populateBox", 2];
      [cajaVeh, _remains] call AS_fnc_addMagazineRemains;
      //[_veh] RemoteExec ["deleteVehicle", _x];
      //Do not delete, let it be done via normal ways. (Supply box was deleted while respawning FIA location)

    };


} foreach (vehicles select {(typeOf _x) != "WeaponHolderSimulated" and {_x distance2D _position <= _size}});

//AAF Locations

} else {

  //Remove and clean FIA persistents from AAF location. Return to aafarsenal or refund

  {
      private _veh = _x;
      private _type = typeOf _veh;

      if (_type isEqualTo "WeaponHolderSimulated") then {[_veh] remoteExec ["deleteVehicle", _veh];};

      if (_veh call AS_fnc_getSide in ["FIA", "NATO"]) then {
        [_veh, false] remoteExecCall ["AS_fnc_changePersistentVehicles", 2];
      //If possible, return to AAFarsenal

        private _vehicleCategory = _type call AS_AAFarsenal_fnc_category;

        if (_vehicleCategory != "") then {

          if (_vehicleCategory call AS_AAFarsenal_fnc_canAdd) then {
            [_vehicleCategory] remoteExecCall ["AS_AAFarsenal_fnc_addVehicle", 2];
          } else {
            private _count = 0.5+(0.1*(count (["seaport", "AAF"] call AS_location_fnc_TS)));
            [(_vehicleCategory call AS_AAFarsenal_fnc_cost)*_count] remoteExec ["AS_fnc_changeAAFmoney", 2];
          };

        };
        {
          detach _x;
        } foreach (attachedObjects _veh);
        sleep 4;
        [_veh] remoteExec ["deleteVehicle", _veh];

      };

  } forEach (vehicles select {_x distance2D _position <= _size});

  //Dead soldiers. Activatecleanup overridden with this

  {
      if not (alive _x) then {
          [_x] RemoteExec ["AS_fnc_safeDelete", _x];
      };
  } forEach (_position nearObjects ["Man", _size]);


};
