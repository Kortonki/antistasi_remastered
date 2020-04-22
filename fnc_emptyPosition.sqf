private ["_angle", "_angle0", "_angle1", "_array", "_canBeOnShore", "_centerPosition", "_distance", "_dx", "_dy", "_emptyPosition", "_index", "_maxDistFromCenter", "_maxGradient", "_minDistFromCenter", "_minDistToObjects", "_objectMaxSize", "_position", "_positionNumber", "_positionsNumber", "_positionsNumbers", "_subarray", "_waterMode"];

_array = [];
_emptyPosition = [];

params ["_objectMaxSize", "_centerPosition", "_minDistFromCenter", "_maxDistFromCenter", "_minDistToObjects", "_maxGradient", "_waterMode", "_canBeOnShore"];

if (_minDistToObjects < _objectMaxSize / 2) then {_minDistToObjects = _objectMaxSize / 2};

_distance = _minDistFromCenter + _objectMaxSize / 2;

while {_distance <= (_maxDistFromCenter + _objectMaxSize / 2)} do {
  _positionsNumber = floor (180 / (asin (_objectMaxSize / (2 * _distance))));

  if (_positionsNumber > 1) then {
  	_angle0 = floor (random 360);

  	_angle1 = 2 * (asin (_objectMaxSize / (2 * _distance)));

  	_array set [count _array, [_distance, _angle0, _angle1, _positionsNumber, []]];
  };

  _distance = _distance + _objectMaxSize;
};

while {(count _array) > 0} do {
  _positionNumber = -1;

  _index = floor (random (count _array));

  _subarray = _array select _index;

  _distance = _subarray select 0;
  _angle0 = _subarray select 1;
  _angle1 = _subarray select 2;
  _positionsNumber = _subarray select 3;
  _positionsNumbers = _subarray select 4;

  while {true} do {
  	_positionNumber = floor (random _positionsNumber);

  	if (!(_positionNumber in _positionsNumbers)) exitWith {};
  };

  _angle = _angle0 + _positionNumber * _angle1;

  _dx = _distance * (sin _angle);
  _dy = _distance * (cos _angle);

  _position = [(_centerPosition select 0) + _dx, (_centerPosition select 1) + _dy, 0];

  if (
  	((count (_position isFlatEmpty [_minDistToObjects, 0, _maxGradient, _objectMaxSize, _waterMode, _canBeOnShore, objNull])) > 0)
  and
  	{(count (nearestObjects [_position, ["Air", "LandVehicle"], _minDistToObjects])) == 0}
  )
  exitWith {_emptyPosition = _position};

  _positionsNumbers set [count _positionsNumbers, _positionNumber];

  if ((count _positionsNumbers) < _positionsNumber) then {(_array select _index) set [4, _positionsNumbers]} else {_array = [_array, _index] call BIS_fnc_removeIndex};
};

_emptyPosition
