
#include "../../macros.hpp"

params ["_location"];
private _posicion = _location call AS_location_fnc_position;
private _size = _location call AS_location_fnc_size;

private _soldadosFIA = [_location, "FIAsoldiers"] call AS_spawn_fnc_get;

waitUntil {sleep AS_spawnLoopTime; not(_location call AS_location_fnc_spawned)};

private _buildings = nearestObjects [_posicion, AS_destroyable_buildings, _size*1.5];
[_buildings] remoteExec ["AS_fnc_updateDestroyedBuildings", 2];

private _vs = [];

private _cargo_w = [[], []];
private _cargo_m = [[], []];
private _cargo_i = [[], []];
private _cargo_b = [[], []];

//If moving FIA HQ, gear should not be returned upon despawn
//Investigate what's the idea behind below
//if (_location call AS_location_fnc_side == "FIA" and {(_location call AS_location_fnc_type) != "fia_hq"}) then {
if (_location call AS_location_fnc_side == "FIA") then {
  {

        //Recover units arsenal. Dead units will be collected via AS_fnc_collectDroppedEquipment

        if (alive _x) then {

        private _arsenal = [_x, true] call AS_fnc_getUnitArsenal;  // restricted to locked weapons
  			_cargo_w = [_cargo_w, _arsenal select 0] call AS_fnc_mergeCargoLists;
  			_cargo_m = [_cargo_m, _arsenal select 1] call AS_fnc_mergeCargoLists;
  			_cargo_i = [_cargo_i, _arsenal select 2] call AS_fnc_mergeCargoLists;
  			_cargo_b = [_cargo_b, _arsenal select 3] call AS_fnc_mergeCargoLists;
  			[cajaVeh, (_arsenal select 4)] call AS_fnc_addMagazineRemains;



          if (!(isNull objectParent _x)) then {
            objectParent _x deletevehicleCrew _x;
          } else { //This was added so vehicle soldier is in is not deleted
          [_x] remoteExec ["deleteVehicle", _x];
          };
      };
    } forEach _soldadosFIA;
};

[_location, caja] call AS_fnc_collectDroppedEquipment;

//add everything

[caja, _cargo_w, _cargo_m, _cargo_i, _cargo_b] remoteExec ["AS_fnc_populateBox", 2];

//TODO: transfer from Cajaveh to arsenal to repack full mags?

([_location, "resources"] call AS_spawn_fnc_get) params ["_task", "_groups", "_vehicles", "_markers"];
[_groups, _vehicles, _markers] call AS_fnc_cleanResources;
[_location, "delete", true] call AS_spawn_fnc_set;
