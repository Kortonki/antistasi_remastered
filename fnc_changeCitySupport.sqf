#include "macros.hpp"
AS_SERVER_ONLY("AS_fnc_changeCitySupport.sqf");
params ["_opfor","_blufor",["_pos", [0,0,0]], ["_notify", false]];

waitUntil {sleep 0.5; isNil "AS_cityIsSupportChanging"};



private _city = "";
if (typeName _pos == typeName "") then {
	_city = _pos;
} else {
	_city = [call AS_location_fnc_cities, _pos] call BIS_fnc_nearestPosition;
};

//moved here from above as failsafe to not lock the whole mission for a nil position.
AS_cityIsSupportChanging = true;

private _FIAsupport = [_city, "FIAsupport"] call AS_location_fnc_get;
private _AAFsupport = [_city, "AAFsupport"] call AS_location_fnc_get;

if (_AAFsupport + _FIAsupport > 100) then {
	_AAFsupport = round (_AAFsupport / 2);
	_FIAsupport = round (_FIAsupport / 2);
};

if ((_blufor > 0) && ((_FIAsupport > 90) || (_FIAsupport + _AAFsupport > 90))) then {
	_blufor = 0;
	_opfor = _opfor - _blufor; //this changed from fixed 5 to amount of support: if no free support to gain, deduct same from opposing support
}
else {
	if ((_opfor > 0) && ((_AAFsupport > 90) || (_FIAsupport + _AAFsupport > 90))) then {
		_opfor = 0;
		_blufor = _blufor - _opfor;
	};
};

//here if AAF less than 1% and getting less add FIA support instead and vice versa

if ((_blufor < 0) and {_FIAsupport <= 1}) then {
	_opfor = _opfor - _blufor;
};

if ((_opfor < 0) and {_AAFsupport <= 1}) then {
	_blufor = _blufor - _opfor;
};


if (_AAFsupport + _FIAsupport + _opfor > 100) then {
	_opfor = 100 - (_AAFsupport + _FIAsupport);
};
_AAFsupport = _AAFsupport + _opfor;

if (_AAFsupport + _FIAsupport + _blufor > 100) then {
	_blufor = 100 - (_AAFsupport + _FIAsupport);
};
_FIAsupport = _FIAsupport + _blufor;

if (_AAFsupport > 99) then {_AAFsupport = 99};
if (_FIAsupport > 99) then {_FIAsupport = 99};
if (_AAFsupport < 1) then {_AAFsupport = 1};
if (_FIAsupport < 1) then {_FIAsupport = 1};

//Probably unnecessary: why give FIA edge in this situation?
//if (_FIAsupport + _AAFsupport < 5) then {_AAFsupport = 1; _FIAsupport = 5};



[_city, "FIAsupport", _FIAsupport] call AS_location_fnc_set;
[_city, "AAFsupport", _AAFsupport] call AS_location_fnc_set;

AS_cityIsSupportChanging = nil;

if _notify then {
	private _sign = "+";
	if (_blufor < 0) then {_sign = "";};
	private _text = "";
	if (_FIAsupport > _AAFsupport) then {
		_text = format ["<t color='#0000bb'>%1</t><t color='#ffffff'> FIA Support<br/>%2%3<br/>%4 -> %5</t>", _city, _sign,_blufor,_FIAsupport - _blufor, _FIAsupport];
	} else {
		_text = format ["<t color='#00bb00'>%1</t><t color='#ffffff'> FIA Support<br/>%2%3<br/>%4 -> %5</t>", _city, _sign,_blufor,_FIAsupport - _blufor, _FIAsupport];
	};
	[petros, "income", _text, 5] remoteExec ["AS_fnc_localCommunication", AS_CLIENTS];
};

true
