#include "macros.hpp"
params ["_position"];

private _threat = 0;

// roadblocks
_threat = _threat + 2 * (
	{(_x call AS_location_fnc_position) distance _position < AS_P("spawnDistance")} count ([["roadblock", "watchpost"], "FIA"] call AS_location_fnc_TS));

// bases
{
	private _otherPosition = _x call AS_location_fnc_position;
	private _size = _x call AS_location_fnc_size;
	private _garrison = _x call AS_location_fnc_garrison;
	if (_otherPosition distance _position < AS_P("spawnDistance")) then {
		_threat = _threat + (2*({(_x == "AT Specialist")} count _garrison)) + (floor((count _garrison)/8)); //Ammo bearer here changed to AT spesialist (wtf)
		private _estaticas = AS_P("vehicles") select {_x distance _otherPosition < _size};
		if (count _estaticas > 0) then {
			_threat = _threat + ({typeOf _x in AS_allMortarStatics} count _estaticas) + (2*({typeOf _x in AS_allATstatics} count _estaticas));
		};
	};
} forEach ([["base", "airfield", "outpost", "watchpost", "roadblock"], "FIA"] call AS_location_fnc_TS);

_threat
