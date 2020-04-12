//Looks for all entries in AS_maxAmounts to calculate total allowed vehicles for the category

private _max = 0;

{
  //These are all subarrays
  _locationTypes = _x select 0;
  _categories = _x select 1;
  _amounts = _x select 2;

  //If this type in maxAmounts has the category, then add corresponding amount for each location of that type owned by AAF
  private _index = _categories find _this;

  if (_index > -1) then {
    _max = _max + (_amounts select _index)*count([_locationTypes, "AAF"] call AS_location_fnc_TS);
  };
} foreach AS_maxAmounts;

_max
