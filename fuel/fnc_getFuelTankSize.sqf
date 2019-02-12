params ["_vehicle"];

if (isNull _vehicle) exitWith {diag_log format["[AS] Error: AS_fnc_getVehicleFuel.sqf: No vehicle specified"];101};

if (not(isNil {_vehicle getVariable "fuelTankSize"})) exitWith {(_vehicle getVariable "fuelTankSize")};
//If there's a reasonable value in the vehicle config, use that. Otherwise use values below. Improve and test


private _type = typeOf _vehicle;

private _fuelConsumptionRate = [configFile >> "CfgVehicles" >> _type, "fuelConsumptionRate"] call BIS_fnc_returnConfigEntry;
private _fuelTankSize = [configFile >> "CfgVehicles" >> _type, "fuelCapacity"] call BIS_fnc_returnConfigEntry;
if (not(_fuelConsumptionRate == 0.01) and {not(isNil "_fuelTankSize")}) exitWith {_fuelTankSize};

//TODO if no reasonable value, base the fuel tank size on vehicle size and mass

//Fuel tanks sizes for vehicle classes in liters
private _fallback = 100;

private _quadbike = 20;
private _car = 60;
private _van = 100;
private _truck = 300;
private _apc = 500;
private _tank = 1500;
private _heli = 300;
private _plane = 300;
private _boat = 30;

//exception for quadbikes
if (_vehicle isKindOf "Quadbike_01_base_F") exitWith {_vehicle setVariable ["fuelTankSize",_quadbike, true]; _quadbike};

//exception for vans
if (_vehicle isKindOf "Van_02_base_F" or _vehicle isKindOf "Van_01_base_F") exitWith {_vehicle setVariable ["fuelTankSize",_van, true]; _van};

//MRAP use truck fuel capacities
if (_type in BE_class_MRAP) exitWith {_vehicle setVariable ["fuelTankSize",_van, true]; _van};

if (_vehicle isKindof "Truck_F") exitWith {_vehicle setVariable ["fuelTankSize",_truck, true]; _truck};
if (_vehicle isKindof "Car") exitWith {_vehicle setVariable ["fuelTankSize",_car, true]; _car};
if (_type in BE_class_APC) exitWith {_vehicle setVariable ["fuelTankSize",_apc, true]; _apc};
if (_vehicle isKindof "APC_Wheeled_01_base_F") exitWith {_vehicle setVariable ["fuelTankSize",_apc, true]; _apc};
if (_vehicle isKindof "Tank" or _type in BE_class_MBT) exitWith {_vehicle setVariable ["fuelTankSize",_tank, true]; _tank};
if (_vehicle isKindof "Helicopter" or _type in BE_class_Heli) exitWith {_vehicle setVariable ["fuelTankSize",_heli, true]; _heli};
if (_vehicle isKindof "Plane") exitWith {_vehicle setVariable ["fuelTankSize",_plane, true]; _plane};
if (_vehicle isKindof "Boat") exitWith {_vehicle setVariable ["fuelTankSize",_boat, true]; _boat};

diag_log format["[AS] Error: AS_fnc_getFuelTankSize.sqf: invalid vehicle type %1, fallback fuel tank size used", _vehicle];

_fallback
