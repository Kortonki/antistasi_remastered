//Check if unit is being moved to cancel AI medical behaviour and release it for movement

params ["_unit"];

if (
  !(isnull (attachedTo _unit)) or //Is being carried or dragged (ACE)
  (vehicle _unit != _unit) //Is a passenger
  ) exitWith {true};
false
