#include "macros.hpp"
AS_SERVER_ONLY("AS_fnc_changeAAFmoney.sqf");
if (!isPlayer AS_commander) exitWith {};

waitUntil {sleep 0.2; isNil "AS_resourcesIsChanging"};
AS_resourcesIsChanging = true;

params [["_variation", 0]];

//TODO here something to penalise AAF for going broke
private _resourcesAAF = (AS_P("resourcesAAF") + _variation);


private _msg = "";
private _type = "";
//If no money, lose CSAT support and then city support as much as FIA would

if (_resourcesAAF < 0) then {
  private _debt = -(floor(_resourcesAAF/50));
  if ((AS_P("CSATsupport")) >= (2*_debt)) then {
    [0,(-2)*_debt] call AS_fnc_changeForeignSupport;

   _msg = format ["We've heard from international press that low funds and resources has forced %1 to loan money from foreign powers. %2 is not pleased.", ["AAF", "shortname"] call AS_fnc_getEntity, ["CSAT", "shortname"] call AS_fnc_getEntity];
   _type = "AAFdebt_CSATSup";


  } else {
    {
      [(-1*_debt), 0, _x] call AS_fnc_changeCitySupport;
    } foreach ([] call AS_location_fnc_cities);

    _msg = format ["We've heard from the people that low funds and resources has forced %1 to rob and forcefully claim property from local population. That has lowered %1 support everywhere in the area.", ["AAF", "shortname"] call AS_fnc_getEntity];
    _type = "AAFdebt_citySup";
  };
  _resourcesAAF = 0;
};

[_msg, 5, _type] remoteExec ["AS_fnc_globalMessage", 2];

AS_Pset("resourcesAAF", _resourcesAAF);

AS_resourcesIsChanging = nil;
