#include "macros.hpp"
AS_SERVER_ONLY("AS_fnc_changeAAFmoney.sqf");
if (!isPlayer AS_commander) exitWith {};

waitUntil {sleep 5; isNil "AS_resourcesIsChanging"};
AS_resourcesIsChanging = true;

params [["_variation", 0]];

//TODO here something to penalise AAF for going broke
private _resourcesAAF = (AS_P("resourcesAAF") + _variation) max 0;

AS_Pset("resourcesAAF", _resourcesAAF);

AS_resourcesIsChanging = nil;
