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
            private _group = group _unit;
            waitUntil {sleep (5 + _rand); not([_unit, AS_P("spawnDistance")] call AS_fnc_friendlyNearby)};

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
    if (!(_x isKindOf "AllVehicles") and {!(_x isKindof "ReammoBox_F")}) then {
      [_x] remoteExecCall ["deletevehicle", _x];
    } else {
      //Sleep to avoid despawn while players are spawning
      [_x] spawn AS_fnc_activateMissionVehicleCleanup;
    };
} forEach _vehicles;
