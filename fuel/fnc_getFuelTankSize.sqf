params ["_vehicle"];

if (isNull _vehicle) exitWith {diag_log format["[AS] Error: AS_fnc_getVehicleFuel: No vehicle specified"];101};

if (not(isNil {_vehicle getVariable "fuelTankSize"})) exitWith {(_vehicle getVariable "fuelTankSize")};
//If there's a reasonable value in the vehicle config, use that. Otherwise use values below. Improve and test
private _type = typeOf _vehicle;

private _fuelConsumptionRate = [configFile >> "CfgVehicles" >> _type, "fuelConsumptionRate"] call BIS_fnc_returnConfigEntry;
private _fuelTankSize = [configFile >> "CfgVehicles" >> _type, "fuelCapacity"] call BIS_fnc_returnConfigEntry;
if (not(_fuelConsumptionRate == 0.01) and {not(isNil "_fuelTankSize")}) exitWith {_fuelTankSize};

//TODO if no reasonable value, base the fuel tank size on vehicle size and mass

//Fuel tanks sizes for vehicle classes in liters
//Middle number after vehicle is the default mass for the class - more than that bigger fuel tank and vice versa.
//Last number tells how much the mass affects fuel tank size
//TODO: take small and big of the class: take their mass and fuel capacity -> solve the equation to get a linear function

_fuelTankSize = 100;

_fuelTankSize = _vehicle call {
  params ["_vehicle"];
  //exception for quadbikes
  if (_vehicle isKindOf "Quadbike_01_base_F") exitWith {20};
  //exception for vans
  if (_vehicle isKindOf "Van_02_base_F" or _vehicle isKindOf "Van_01_base_F") exitWith {
    100 + (round((getmass _vehicle)-1500)*0.001)*40};
  if (_type in BE_class_APC) exitWith {
    500 + (round((getmass _vehicle)-13000)*0.001)*40};
  if (_vehicle isKindof "APC_Wheeled_01_base_F") exitWith {
    500 + (round((getmass _vehicle)-13000)*0.001)*40};
    //MRAP use truck fuel capacities
  if (_type in BE_class_MRAP) exitWith {
    100 + (round((getmass _vehicle)-1000)*0.001)*40};
  if (_vehicle isKindof "Truck_F") exitWith {
    300 + (round((getmass _vehicle)-5000)*0.001)*40};
  if (_vehicle isKindof "Car") exitWith {
    60 + (round((getmass _vehicle)-1000)*0.001)*40};
  if (_vehicle isKindof "Tank" or _type in BE_class_MBT) exitWith {
    1500 + (round((getmass _vehicle)-60000)*0.001)*40};
  if (_vehicle isKindof "Helicopter" or _type in BE_class_Heli) exitWith {
    200 + (round((getmass _vehicle)-1400)*0.001)*200};
  if (_vehicle isKindof "Plane") exitWith {
    3660 + (round((getmass _vehicle)-15000)*0.001)*250};
  if (_vehicle isKindof "Boat") exitWith {
    60 + (round((getmass _vehicle)-1000)*0.001)*40};
  diag_log format["[AS] Error: AS_fnc_getFuelTankSize: Invalid vehicle type %1: fallback fuel tank size used", _vehicle];
};

if (_fuelTankSize < 0) then {
  diag_log format["[AS] Error: AS_fnc_getFuelTankSize: Vehicle type %1, fuel tank size < 0: fallback fuel tank size used", _vehicle];
  _fuelTankSize = 100;
};

_fuelTankSize
