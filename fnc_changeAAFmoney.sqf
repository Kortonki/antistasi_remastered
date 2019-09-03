#include "macros.hpp"
AS_SERVER_ONLY("AS_fnc_changeAAFmoney.sqf");
if (!isPlayer AS_commander) exitWith {};

waitUntil {sleep 0.2; isNil "AS_resourcesIsChanging"};
AS_resourcesIsChanging = true;

params [["_variation", 0]];

//TODO here something to penalise AAF for going broke
private _resourcesAAF = (AS_P("resourcesAAF") + _variation);

//If no money, lose CSAT support and then city support as much as FIA would

if (_resourcesAAF < 0) then {
  private _debt = -(floor(_resourcesAAF/50));
  if ((AS_P("CSATsupport")) >= (2*_debt)) then {
    [0,(-2)*_debt] call AS_fnc_changeForeignSupport;
  } else {
    {
      [(-1*_debt), 0, _x] call AS_fnc_changeCitySupport;
    } foreach ([] call AS_location_fnc_cities);
  };
};

AS_Pset("resourcesAAF", _resourcesAAF);

AS_resourcesIsChanging = nil;
