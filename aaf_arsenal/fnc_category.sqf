// given a vehicle type (`typeOf _veh`), returns its category (or "" if it belongs to none)
params ["_type"];
private _category = "";
{
	if (_type in (_x call AS_AAFarsenal_fnc_valid)) exitWith {_category = _x;};
} forEach call AS_AAFarsenal_fnc_all;

//Exception for support vehicles and vans (convoy vehicles)
//support vehicles aren't their own class to keep eg. intel simple. It's not useful to know their specific counts
//TODO: figure a place where to initialise support vehicle array (start and load game)
if (_category isEqualTo "" and {_type in [["AAF", "truck_fuel"] call AS_fnc_getEntity, ["AAF", "truck_repair"] call AS_fnc_getEntity, ["AAF", "truck_ammo"] call AS_fnc_getEntity] or _type in (["AAF", "vans"] call AS_fnc_getEntity)}) then {
	_category = "trucks";
};

_category
