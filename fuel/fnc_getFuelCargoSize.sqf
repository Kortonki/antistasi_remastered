params ["_vehicle"];

if (not(isNil {_vehicle getVariable "fuelCargoSize"})) exitWith {(_vehicle getVariable "fuelCargoSize")};


private _type = typeOf _vehicle;

private _fuelCargoSize = call {
	if (hasACE) exitWith {([(configFile >> "CfgVehicles" >> _type), "ace_refuel_fuelCargo", 0] call BIS_fnc_returnConfigEntry)};
	([(configFile >> "CfgVehicles" >> _type), "transportfuel", 0] call BIS_fnc_returnConfigEntry)
};

if (isnil "_fuelCargoSize") exitWith {0}; //Failsafe to not return nil. This function is used to check if vehicle is capable of loading fuel when using ACE

_fuelCargoSize = _fuelCargoSize min 10000;
_vehicle setVariable ["fuelCargoSize", _fuelCargoSize, true];

_fuelCargoSize
