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
private _totalSupport = _FIAsupport + _AAFsupport;



//here if AAF less than 1% and getting less add FIA support instead and vice versa
//Here a modifier added so killing is not good at increasing support

if ((_blufor < 0) and {_FIAsupport <= 1}) then {
	_opfor = _opfor - (_blufor/2);
};

if ((_opfor < 0) and {_AAFsupport <= 1}) then {
	_blufor = _blufor - (_opfor/2);
};

if (_blufor >= _opfor) then {
	if (_totalSupport + _blufor + _opfor > 100) then {
		_opfor = _opfor - round(_totalSupport + _blufor +_opfor - 100)/2; //things to improve fia support are only 50% effective lowering opposite support and vice versa
		_blufor = round(100 - _totalSupport);
	};
} else {
	if (_totalSupport + _opfor + _blufor > 100) then {
		_blufor = _blufor - round(_totalSupport + _opfor +_blufor - 100)/2;
		_opfor = round(100 - _totalSupport);
	};
};

_AAFsupport = _AAFsupport + _opfor;
_FIAsupport = _FIAsupport + _blufor;
_totalSupport = _FIAsupport + _AAFsupport;

if (_totalSupport > 100) then {
	_AAFsupport = floor(_AAFsupport - (_totalSupport - 100)/2);
	_FIAsupport = floor(_FIAsupport - (_totalSupport - 100)/2);
	_totalSupport = _AAFsupport + _FIAsupport;
};


if (_AAFsupport > 99) then {_AAFsupport = 99};
if (_FIAsupport > 99) then {_FIAsupport = 99};
if (_AAFsupport < 1) then {_AAFsupport = 1};
if (_FIAsupport < 1) then {_FIAsupport = 1};

//Probably unnecessary: why give FIA edge in this situation?
//if (_FIAsupport + _AAFsupport < 5) then {_AAFsupport = 1; _FIAsupport = 5};



[_city, "FIAsupport", _FIAsupport] call AS_location_fnc_set;
[_city, "AAFsupport", _AAFsupport] call AS_location_fnc_set;

AS_cityIsSupportChanging = nil;

if (_notify and {_blufor != 0}) then {
	private _sign = "+";
	if (_blufor < 0) then {_sign = "";};
	private _text = "";
	if (_FIAsupport > _AAFsupport) then {
		_text = format ["<t color='#0000bb'>%1</t><t color='#ffffff'> %6 Support<br/>%2%3<br/>%4 -> %5</t>", _city, _sign,_blufor,_FIAsupport - _blufor, _FIAsupport, ["FIA", "shortname"] call AS_fnc_getEntity];
	} else {
		_text = format ["<t color='#00bb00'>%1</t><t color='#ffffff'> %6 Support<br/>%2%3<br/>%4 -> %5</t>", _city, _sign,_blufor,_FIAsupport - _blufor, _FIAsupport, ["FIA", "shortname"] call AS_fnc_getEntity];
	};
	[petros, "income", _text, 5] remoteExec ["AS_fnc_localCommunication", AS_CLIENTS];
};

true
