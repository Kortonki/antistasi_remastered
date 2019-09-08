// Cleans up unneeded resources once they are far from any BLUFOR.
#include "macros.hpp"
params ["_groups", "_vehicles", "_markers"];

{
    deleteMarker _x;
} forEach _markers;

{
    private _group = _x;
    private _units = units _group;
    {
        [_x] spawn {
            params ["_unit"];
            private _rand = random 5;
            waitUntil {sleep (5 + _rand); not ([AS_P("spawnDistance"), _unit, "BLUFORSpawn", "boolean"] call AS_fnc_unitsAtDistance)};

            if ({alive _x} count units group _unit == 1) then {
                // clean group after last unit
                if (!(isNull objectParent _unit)) then {
                  objectParent _unit deletevehicleCrew _unit; //This to make sure the vehicle unit is mounted on is not deleted
                } else {
                [_unit] remoteExec ["deleteVehicle", _unit];
              };
                deleteGroup (group _unit);
            } else {
              if (!(isNull objectParent _unit)) then {
                objectParent _unit deletevehicleCrew _unit; //This to make sure the vehicle unit is mounted on is not deleted
              } else {
              [_unit] remoteExec ["deleteVehicle", _unit];
            };
          };
        };
    } forEach _units;
} forEach _groups;

{
    //[_x] spawn AS_fnc_activateVehicleCleanup;
    //Addition why wait if cleanResources is triggered only after away for spawn distance?
    //TODO consider what happes to towed vehicles, are they deleted when location despawns?
    if (!(_x isKindOf "AllVehicles") and !(_x isKindof "ReammoBox_F")) then {
      [_x] remoteExecCall ["deletevehicle", _x];
    } else {
      [_x] spawn AS_fnc_activateVehicleCleanup;
    };
} forEach _vehicles;
