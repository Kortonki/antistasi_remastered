#include "macros.hpp"
AS_SERVER_ONLY("AS_fnc_changeFIAmoney.sqf");

if (not isNil "AS_LOCK_changeFIAmoney") then {
	waitUntil {sleep 1; isNil "AS_LOCK_changeFIAmoney"};
};
AS_LOCK_changeFIAmoney = true;

params [["_hr", 0], ["_resourcesFIA", 0], ["_showTimeOverride", 0]];

private _hrT = AS_P("hr");
private _resourcesFIAT = AS_P("resourcesFIA");

_hrT = _hrT + _hr;
_resourcesFIAT = round (_resourcesFIAT + _resourcesFIA);

if (_hrT > 0) then {
	_hrT = _hrT min (["HR"] call fnc_BE_permission);
};
//_hrT = _hrT max 0; //HR can go to negative upon player death (for balance, player death deducts HR but players must be spawned regardelss -> HR debt)
_resourcesFIAT = _resourcesFIAT max 0;

AS_Pset("hr", _hrT);
AS_Pset("resourcesFIA", _resourcesFIAT);
AS_LOCK_changeFIAmoney = nil;

private _texto = "";
private _hrSim = "";
if (_hr > 0) then {_hrSim = "+"};

private _resourcesFIASim = "";
private _showTime = 5;

if (_resourcesFIA > 0) then {_resourcesFIASim = "+"};
if ((_hr != 0) and (_resourcesFIA != 0)) then {
	_texto = format ["<t size='0.6' color='#C1C0BB'>%5 Resources.<br/> <t size='0.5' color='#C1C0BB'><br/>HR: %3%1<br/>Money: %4%2 €",_hr,_resourcesFIA,_hrSim,_resourcesFIASim, ["FIA", "shortname"] call AS_fnc_getEntity];
	_showTime = 10;
} else {
	if (_hr != 0) then {
		_texto = format ["<t size='0.6' color='#C1C0BB'>%4 Resources.<br/> <t size='0.5' color='#C1C0BB'><br/>HR: %3%1",_hr,_resourcesFIA,_hrSim, ["FIA", "shortname"] call AS_fnc_getEntity];
	} else {
		_texto = format ["<t size='0.6' color='#C1C0BB'>%5 Resources.<br/> <t size='0.5' color='#C1C0BB'><br/>Money: %4%2 €",_hr,_resourcesFIA,_hrSim,_resourcesFIASim, ["FIA", "shortname"] call AS_fnc_getEntity];
	};
};

if (_texto != "") then {
	//Why petros, FIX
	[nil,"income",_texto, [_showTimeOverride, _showTime] select {(_showTimeOverRide == 0)}] remoteExec ["AS_fnc_localCommunication", AS_CLIENTS];
};
