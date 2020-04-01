params ["_locationType"];

private _classes = [];

//0: location types
//1: location vehicle types
//2: location vehicle amounts

{
  if (_locationType in (_x select 0)) then {
    _classes append (_x select 1);
  };
} foreach AS_maxAmounts;

//return uniques
(_classes arrayIntersect _classes)
