#include "../macros.hpp"

//private _propTruck = AS_S("activeItem");
private _propTruck = _this select 0;

if (_propTruck getVariable ["BCdisabled", false]) exitWith {
	{if (isPlayer _x) then {[petros,"hint","The device can only be activated once."] remoteExec ["AS_fnc_localCommunication",_x]}} forEach ([20, _propTruck, "BLUFORSpawn"] call AS_fnc_unitsAtDistance);
};

if not(_propTruck getVariable ["BCactive", false]) then {
	{if (isPlayer _x) then {[petros,"hint","Device activated."] remoteExec ["AS_fnc_localCommunication",_x]}} forEach ([20, _propTruck, "BLUFORSpawn"] call AS_fnc_unitsAtDistance);
	_propTruck setVariable ["BCactive", true, true];
	sleep 2700;
	_propTruck setVariable ["BCactive", false, true];
	{if (isPlayer _x) then {[petros,"hint","Device deactivated."] remoteExec ["AS_fnc_localCommunication",_x]}} forEach ([20, _propTruck, "BLUFORSpawn"] call AS_fnc_unitsAtDistance);
} else {
	_propTruck setVariable ["BCactive", false, true];
	_propTruck setVariable ["BCdisabled", true, true];
	{if (isPlayer _x) then {[petros,"hint","Device turned off."] remoteExec ["AS_fnc_localCommunication",_x]}} forEach ([20, _propTruck, "BLUFORSpawn"] call AS_fnc_unitsAtDistance);
	[[_propTruck,"remove"],"AS_fnc_addAction"] call BIS_fnc_MP;
};
