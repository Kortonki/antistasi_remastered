params ["_position", "_distance"];

if (isNil "_distance") then {
	_distance = AS_enemyDist;
};

private _friendlyNearby = false;
{
	if (((_x call AS_fnc_getSide) in ["FIA", "NATO"]) and
				{!(captive _x) and
				{!(_x call AS_medical_fnc_isUnconscious) and
        {_x distance2D _position < _distance}}})

				exitWith {_friendlyNearby = true};
} forEach allUnits;

_friendlyNearby
