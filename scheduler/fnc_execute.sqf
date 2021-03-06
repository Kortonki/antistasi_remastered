// selects a worker and remotely executes a given function on it.
#include "../macros.hpp"
AS_SERVER_ONLY("fnc_execute");
params ["_arguments", "_functionName"];

diag_log format ["[AS] Server: scheduler_fnc_execute(%1): Arguments: %2", _functionName, _arguments];
private _worker_id = call AS_scheduler_fnc_getWorker;

_arguments remoteExec [_functionName, _worker_id, false]; //TODO: sendAAPatrol bug: position gets sent as an array to to the function?
