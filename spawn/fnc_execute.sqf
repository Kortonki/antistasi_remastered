// Function to execute a spawn. It
// starts from the state where the spawn was left.
params ["_spawn"];

//Årpbably unnecessary heavy check
/*if not (_spawn in (call AS_spawn_fnc_all)) exitWith {
    diag_log format ["[AS] Error: spawn_fnc_execute: spawn '%1' does not exist", _spawn];
};*/

private _type = [_spawn, "spawn_type"] call AS_spawn_fnc_get;

([_type, _spawn] call AS_spawn_fnc_states) params ["_states", "_functions"];

if (!(isServer)) then {
    sleep 5; // Just time to let dictionary sync up to avoid errors (same spawn almost simultaneosly on different machines etc.)
};

// take ownership of this spawn
[_spawn, "spawnOwner", clientOwner] call AS_spawn_fnc_set;

private _state_index = [_spawn, "state_index"] call AS_spawn_fnc_get;

if (_state_index >= count _functions and {_spawn call AS_spawn_fnc_exists}) then {_state_index = 0;}; //Failsafe if locality syncing fudgery

while {_state_index < count _functions} do {
    diag_log format ["[AS] %1: spawn '%2' started state '%3'", clientOwner, _spawn, _states select _state_index];
    _spawn call (_functions select _state_index);
    diag_log format ["[AS] %1: spawn '%2' finished state '%3'", clientOwner, _spawn, _states select _state_index];
    // the function above can change the `state_index` to a new one. We load it and use it
    _state_index = [_spawn, "state_index"] call AS_spawn_fnc_get;
    _state_index = _state_index + 1;
    [_spawn, "state_index", _state_index] call AS_spawn_fnc_set;
};

//Don't delete the spawn immediately. Missions etc. whice are possibly running on other threads could still need data from the spawn
//TODO: Better way to check for completion

waitUntil {sleep 10; ([_spawn, "delete"] call AS_spawn_fnc_get)};
sleep 20;
_spawn call AS_spawn_fnc_delete;
