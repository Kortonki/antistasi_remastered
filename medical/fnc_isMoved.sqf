//Check if unit is being moved to cancel AI medical behaviour and release it for movement

params ["_unit"];

private _oldpos = _unit getVariable ["treatmentPos", getpos _unit];
private _newpos = getpos _unit;
_unit setVariable ["treatmentPos", getpos _unit];

private _hasMoved = if (_newpos distance2d _oldpos > 0.5) then {true} else {false};

if (
  !(isnull (attachedTo _unit)) or //Is being carried or dragged (ACE)
  (vehicle _unit != _unit) or
  (_hasMoved) //Is a passenger
  ) exitWith {true};
false
