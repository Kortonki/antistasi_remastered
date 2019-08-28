params ["_position", "_distance"];

if (isNil "_distance") then {
	_distance = AS_enemyDist;
};

private _enemiesNearby = false;
{
	if (((_x call AS_fnc_getSide) in ["AAF", "CSAT"]) and
				{!(_x call AS_fnc_isDog) and
				{!(captive _x) and
				{!(_x call AS_medical_fnc_isUnconscious) and
        {_x distance _position < _distance}}}})

				exitWith {_enemiesNearby = true};
} forEach allUnits;

_enemiesNearby
