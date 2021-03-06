#include "../macros.hpp"
AS_SERVER_ONLY("AS_mission_fnc_add");
params ["_type", "_location"];
//private _Uid = round (diag_tickTime / 60); //Unique id to prevent overlapping mission names TODO: Consider something to check for existing mission name
private _name = format ["%1_%2", _type, _location];
[call AS_mission_fnc_dictionary, _name, call DICT_fnc_create] call DICT_fnc_setGlobal;
[_name, "status", "possible"] call AS_mission_fnc_set;
[_name, "type", _type] call AS_mission_fnc_set;
[_name, "skipping", false] call AS_mission_fnc_set; //This used atm in convoy missions, if skipping this is set to true
[_name, "location", _location] call AS_mission_fnc_set;
_name
