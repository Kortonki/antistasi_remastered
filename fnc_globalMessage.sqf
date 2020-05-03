#include "macros.hpp"

params [["_message", ".....&¤#&%¤...."], ["_delay", 5], ["_type", ""], ["_store", true]]; //Delay in minutes. Type is checked so similar type of messages arent multiplied.

if (_type != "" and {_type in AS_active_messages}) exitWith {};
AS_active_messages pushback _type;

private _delayFinal = (_delay / 2) + (_delay * (random 1)); //Delay is somewhere between 0.5 and 1.5 of the intended delay

//Store it with intended display time if mission is terminated before display
if _store then {
 private _date = [date select 0, date select 1, date select 2, date select 3, (date select 4) + round(_delayFinal)];

 //Back to number and to date fix the form
 //Different names to not have problems with array handling (referring, copying)
//TODO investigate what happens if additional minutes push date into new year, is datetonumber > 1 and how to accomodote it with year

 private _year = _date select 0;
 private _daten = dateTonumber _date;
 private _dateFinal = numberToDate [_year, _daten];

 [_dateFinal, _message] remoteExec ["AS_stats_fnc_storeMessage", 2];
};

sleep (_delayFinal * 60);

//Same message at the same time for all clients
[petros, "globalChat", _message] remoteExec ["AS_fnc_localCommunication", AS_CLIENTS];


AS_active_messages = AS_active_messages - [_type];
