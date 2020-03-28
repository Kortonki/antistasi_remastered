#include "macros.hpp"

params [["_message", ".....&¤#&%¤...."], ["_delay", 5], ["_type", ""]]; //Delay in minutes. Type is checked so similar type of messages arent multiplied.

if (_type != "" and {_type in AS_active_messages}) exitWith {};
AS_active_messages pushback _type;

private _delayFinal = (_delay / 2) + (_delay * (random 1)); //Delay is somewhere between 0.5 and 1.5 of the intended delay

sleep (_delayFinal * 60);

//Same message at the same time for all clients
[petros, "globalChat", _message] remoteExec ["AS_fnc_localCommunication", AS_CLIENTS];

AS_active_messages - [_type];
