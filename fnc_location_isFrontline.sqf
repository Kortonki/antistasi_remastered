#include "macros.hpp"
params ["_location"];

private _position = _location call AS_location_fnc_position;

private _locations = [["airfield", "base", "outpost", "outpostAA", "powerplant", "resource", "factory", "city"], "FIA"] call AS_location_fnc_TS;
_locations append ([] call AS_location_fnc_knownLocations);

private _isfrontier = false;
{
	private _otherPosition = _x call AS_location_fnc_position;
	if (_position distance2D _otherPosition < AS_P("spawnDistance")) exitWith {
		_isFrontier = true;
	};
} forEach _locations;

_isfrontier
