#include "macros.hpp"
AS_CLIENT_ONLY("AS_fnc_localCommunication");

params ["_unit", "_tipo", "_texto", ["_showTime", 1]];

private _validTypes = [
	"sideChat", "hint", "hintCS", "globalChat", "directSay",
	"income", "countdown", "BE", "status", "save"
];
if not (_tipo in _validTypes) exitWith {
	diag_log format["[AS] Error: AS_fnc_localCommunication.sqf: invalid type %1", _tipo];
};

if (_tipo == "directSay") then {
	_unit directSay _texto;
};
if (_tipo == "sideChat") then {
	_unit sideChat format ["%1", _texto];
};
if (_tipo == "hint") then {
	waitUntil {sleep 0.2; isNil "hintRep"};
	hintRep = true;
	hint format ["%1",_texto];
	sleep _showTime;
	hintRep = nil;
};
if (_tipo == "hintCS") then {
	hintC format ["%1",_texto]
};
if (_tipo == "globalChat") then {
	_unit globalChat format ["%1", _texto];
};
if (_tipo == "income") then {
	waitUntil {sleep 0.2; incomeRep < 3};
	playSound "3DEN_notificationDefault";
	[_texto, [safeZoneX + (0.8 * safeZoneW), (0.2 * safeZoneW)], 0.5 - (incomeRep*0.15), _showtime, 0, 0, incomeRep] spawn bis_fnc_dynamicText;
	incomeRep = incomeRep + 1;
	sleep _showTime;
	incomeRep = incomeRep - 1;
};
if (_tipo == "countdown") then {
	_texto = format ["Time Remaining: %1 secs",_texto];
	hint format ["%1",_texto];
};
if (_tipo == "BE") then {
	sleep 0.5;
	"AXP Details" hintC (_texto);
	hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload", {
		_this spawn {
			_this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
			hintSilent "";
		};
	}];
};
if (_tipo == "status") then {
	sleep 0.5;
	"FIA Details" hintC (_texto);
	hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload", {
		_this spawn {
			_this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
			hintSilent "";
		};
	}];
};
if (_tipo == "save") then {
	sleep 0.5;
	"Saving Progress" hintC (_texto);
	hintC_arr_EH = findDisplay 72 displayAddEventHandler ["unload", {
		_this spawn {
			_this select 0 displayRemoveEventHandler ["unload", hintC_arr_EH];
			hintSilent "";
		};
	}];
};
