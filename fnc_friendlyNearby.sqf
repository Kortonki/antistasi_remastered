params ["_unit", "_distance"];

if (isNil "_distance") then {
	_distance = AS_enemyDist;
};

private _position = _unit;

if (typename _unit != "ARRAY") then {
	_position = position _unit;
};


private _friendlyNearby = false;
{
	if (((_x call AS_fnc_getSide) == "FIA")and
				{!(_x call AS_medical_fnc_isUnconscious) and
        {_x distance2D _position < _distance}})

				exitWith {_friendlyNearby = true};
} forEach (allUnits);

_friendlyNearby
