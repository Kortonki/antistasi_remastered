#include "../macros.hpp"
AS_SERVER_ONLY("AS_spawn_fnc_update");

// get units that spawn locations
//TODO: Spawning units should have BLUFORSPAWN as true? Changed to true, as garrison units are flagged false, others true;
private _spawningBLUFORunits = [];
private _spawningOPFORunits = [];
{
    if (_x getVariable ["BLUFORSpawn",false]) then {
        _spawningBLUFORunits pushBack _x;
        if (isPlayer _x) then {
            if (!isNull (getConnectedUAV _x)) then {
                _spawningBLUFORunits pushBack (getConnectedUAV _x);
            };
        };
    } else {
        if (_x getVariable ["OPFORSpawn",false]) then {
            _spawningOPFORunits pushBack _x;
        };
    };
} forEach allUnits;

// check whether a location is spawned or not
{ // forEach location
    private _position = _x call AS_location_fnc_position;
    private _isSpawned = _x call AS_location_fnc_spawned;
    private _deSpawning = _x call AS_location_fnc_despawning;

    if (_x call AS_location_fnc_side in ["AAF", "CSAT"]) then {
        private _spawnCondition = (_x call AS_location_fnc_forced_spawned) or ({(_x distance2D _position < AS_P("spawnDistance"))} count _spawningBLUFORunits > 0);
        //Added a condition here to check last spawn has finished before starting a new one. Rare but can happen because of scheduling
        if (!_isSpawned and {!(_x call AS_spawn_fnc_exists) and {_spawnCondition}}) then {
            _x call AS_location_fnc_spawn;

            [_x, "location"] call AS_spawn_fnc_add;
            [[_x], "AS_spawn_fnc_execute"] call AS_scheduler_fnc_execute;

            private _type = _x call AS_location_fnc_type;
            if (_type == "city") then {
                ["civ_" + _x, "location"] call AS_spawn_fnc_add;
                ["civ_" + _x, "location", _x] call AS_spawn_fnc_set;
                [["civ_" + _x], "AS_spawn_fnc_execute"] call AS_scheduler_fnc_execute;
            };
        };
        if (!(_deSpawning) and {_isSpawned and {!_spawnCondition}}) then {
            [_x, _position, _spawningBLUFORunits] spawn {
              params ["_spawn", "_position", "_spawningBLUFORunits"];
              [_spawn, "despawning", true] call AS_location_fnc_set; //This to avoid multiple spawns of this function
              sleep 70; //Delay to reduce unneccessary despawn

              if (!((_spawn call AS_location_fnc_forced_spawned) or ({(_x distance2D _position < AS_P("spawnDistance"))} count _spawningBLUFORunits > 0))) then {
                _spawn call AS_location_fnc_despawn;
                };
              [_spawn, "despawning", false] call AS_location_fnc_set;
              };
        };
    };
    if (_x call AS_location_fnc_side == "FIA") then {
        // not clear what this is doing. owner is about who controls it, not something else.
        private _playerIsClose = (_x call AS_location_fnc_forced_spawned) or
                                 ({not (_x call AS_fnc_controlsAI) and {_x distance2D _position < AS_P("spawnDistance")}} count _spawningBLUFORunits > 0);
        // enemies are close.
        private _spawnCondition = _playerIsClose or {{_x distance2D _position < AS_P("spawnDistance")} count _spawningOPFORunits > 0};
        //Added a condition here to check last spawn has finished before starting a new one. Rare but can happen because of scheduling
        if (!_isSpawned and {!(_x call AS_spawn_fnc_exists) and {_spawnCondition}}) then {
            _x call AS_location_fnc_spawn;

            //All FIA locations go to Server because arsenal is local only to server
            [_x, "location"] call AS_spawn_fnc_add;
            [_x] remoteExec ["AS_spawn_fnc_execute", 2];
            
            private _type = _x call AS_location_fnc_type;
            if (_type == "city") then {
                ["civ_" + _x, "location"] call AS_spawn_fnc_add;
                ["civ_" + _x, "location", _x] call AS_spawn_fnc_set;
                [["civ_" + _x], "AS_spawn_fnc_execute"] call AS_scheduler_fnc_execute;
            };
        };
        if (!(_deSpawning) and {_isSpawned and {!_spawnCondition}}) then {
          [_x, _position, _spawningBLUFORunits, _spawningOPFORunits] spawn {
            params ["_spawn", "_position", "_spawningBLUFORunits", "_spawningOPFORunits"];
            [_spawn, "despawning", true] call AS_location_fnc_set; //This to avoid multiple spawns of this function
            sleep 70; //Delay to reduce unneccessary despawn

            private _playerIsClose = (_spawn call AS_location_fnc_forced_spawned) or
                                     ({not (_x call AS_fnc_controlsAI) and {_x distance2D _position < AS_P("spawnDistance")}} count _spawningBLUFORunits > 0);
            // enemies are close.
            private _spawnCondition = _playerIsClose or {{_x distance2D _position < AS_P("spawnDistance")} count _spawningOPFORunits > 0};

            if (!_spawnCondition) then {
              _spawn call AS_location_fnc_despawn;
              };
            [_spawn, "despawning", false] call AS_location_fnc_set;
            };

        };
    };
} forEach (call AS_location_fnc_all);
