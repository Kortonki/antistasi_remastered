// Cleans up unneeded resources once they are far from any BLUFOR.
#include "macros.hpp"
params ["_groups", "_vehicles", "_markers"];

{
    deleteMarker _x;
} forEach _markers;

{
    private _group = _x;


    private _units = (units _group) select {alive _x};
    //Civilian group get deleted immediately -> no gameplay involvement
    if (side _group == civilian) then {
      {
        [_x] remoteExec ["AS_fnc_safeDelete", _x];
      } foreach (_units select {vehicle _x == _x}); //Exclude civilian vehicles, which might be far away from location
    };
    {
        [_x] spawn {
            params ["_unit"];
            private _rand = random 5;
            private _group = group _unit;
            //TODO: figure a way to check for all friendlies nearby, as not spawning FIA would despawn anyway when player or HC is far
            //If this is for location shouldn't it despawn with it? possibly creating ever increasing amount of units at spawn/despawn
            waitUntil {sleep (5 + _rand); not ([AS_P("spawnDistance"), _unit, "BLUFORSpawn", "boolean"] call AS_fnc_unitsAtDistance)};

            //If already dead and in despawner, exit:

            if (_unit getVariable ["inDespawner", false]) exitWith {};

            if ({alive _x} count units _group == 1) then {
                // clean group after last unit
                _unit call AS_fnc_safeDelete;
                deleteGroup _group;
            } else {
              _unit call AS_fnc_safeDelete;
          };
        };
    } forEach _units;
} forEach _groups;

{
    //[_x] spawn AS_fnc_activateVehicleCleanup;
    //Addition why wait if cleanResources is triggered only after away for spawn distance?
    //TODO consider what happes to towed vehicles, are they deleted when location despawns?
    //ReammoBox_F changed to supplycrate class: location objects such as barrels on pallet had also ReammoBox_F parent class
    if (!(_x isKindOf "AllVehicles") and {!(_x isKindof "B_supplyCrate_F")}) then {
      [_x] remoteExecCall ["deletevehicle", _x];
    } else {
      [_x] remoteExec  ["AS_fnc_activateVehicleCleanup", _x];
    };
} forEach _vehicles;
