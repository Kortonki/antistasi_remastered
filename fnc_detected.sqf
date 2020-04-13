params ["_unit"];

private _detected = false;
{
  if (!(side _x in [("FIA" call AS_fnc_getFactionSide), civilian]) and {(_x distance _unit < 1) or ((_x knowsAbout (vehicle _unit) > 1.4) and {_x distance2D _unit < 500})}) exitWith {
    _detected = true;
  };
} forEach allUnits;
_detected
