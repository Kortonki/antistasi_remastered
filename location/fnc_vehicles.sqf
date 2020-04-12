params ["_category", "_locationType"];

private _amount = 0;

//0: location types
//1: location vehicle types
//2: location vehicle amounts

{
  if (_locationType in (_x select 0)) then {
    private _index = (_x select 1) find _category;
    if (_index > -1) then {
      _amount = _amount + ((_x select 2) select _index);
    };
  };
} foreach AS_maxAmounts;

_amount
