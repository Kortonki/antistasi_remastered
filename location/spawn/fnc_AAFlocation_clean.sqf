
params ["_location"];
waitUntil {sleep AS_spawnLoopTime; not(_location call AS_location_fnc_spawned)};

private _soldados = [_location, "soldiers"] call AS_spawn_fnc_get;

if (_location call AS_location_fnc_side == "FIA") then {
  {
    // store unit arsenal if location is FIA and unit is dead (store dead AAF units)
    if (!(alive _x)) then {
        ([_x, true] call AS_fnc_getUnitArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", "_remains"];
        [caja, _cargo_w, _cargo_m, _cargo_i, _cargo_b, true] call AS_fnc_populateBox;
        [cajaVeh, _remains] call AS_fnc_addMagazineRemains;
    };
  } forEach _soldados;
};

([_location, "resources"] call AS_spawn_fnc_get) params ["_task", "_groups", "_vehicles", "_markers"];

//Send each soldier away from closest BLUFORspawn to avoid soldier multiplying when location despawns and spawns while
//soldiers do not (individually checked for spawn condition). OTOH removing them immediately might make them
//despawn far away from location but close to a player or FIA soldiers (UPSMON can send them away and otherwise)

[_location, _groups] spawn AS_fnc_sendAwayFromBlufor;

[_groups, _vehicles, _markers] call AS_fnc_cleanResources;
[_location, "delete", true] call AS_spawn_fnc_set;
