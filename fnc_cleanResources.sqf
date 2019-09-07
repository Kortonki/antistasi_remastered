// Cleans up unneeded resources once they are far from any BLUFOR.
#include "macros.hpp"
params ["_groups", "_vehicles", "_markers"];

{
    deleteMarker _x;
} forEach _markers;

{
    private _group = _x;
    {
        [_x] spawn {
            params ["_unit"];
            private _rand = random 5;
            waitUntil {sleep (5 + _rand); not ([AS_P("spawnDistance"), _unit, "BLUFORSpawn", "boolean"] call AS_fnc_unitsAtDistance)};

            if (count units group _unit == 1) then {
                // clean group after last unit
                deleteVehicle _unit;
                deleteGroup (group _unit);
            } else {
                deleteVehicle _unit;
            };
        };
    } forEach units _group;
} forEach _groups;

{
    //[_x] spawn AS_fnc_activateVehicleCleanup;
    //Addition why wait if cleanResources is triggered only after away for spawn distance?
    //TODO consider what happes to towed vehicles, are they deleted when location despawns?
    if (!(_vehicle isKindOf "AllVehicles") and !(_vehicle isKindof "ReammoBox_F")) then {
      [_x] remoteExecCall ["deletevehicle", _x];
    } else {
      [_x] spawn AS_fnc_activateVehicleCleanup;
    };
} forEach _vehicles;
