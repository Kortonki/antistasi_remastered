#include "../macros.hpp"
AS_CLIENT_ONLY("fnc_location_mapInfo.sqf");

private _popFIA = 0;
private _popAAF = 0;
private _pop = 0;
{
	private _population = [_x, "population"] call AS_location_fnc_get;
	private _AAFsupport = [_x, "AAFsupport"] call AS_location_fnc_get;
	private _FIAsupport = [_x, "FIAsupport"] call AS_location_fnc_get;

	_popFIA = _popFIA + (_population * (_FIAsupport / 100));
	_popAAF = _popAAF + (_population * (_AAFsupport / 100));
	_pop = _pop + _population;
} forEach call AS_location_fnc_cities;
_popFIA = round _popFIA;
_popAAF = round _popAAF;
hint format ["Total pop: %1\n%5 Support: %2\n%6 Support: %3 \n\nDestroyed Cities: %4\n\nClick on the location",
	_pop, _popFIA, _popAAF, {_x in AS_P("destroyedLocations")} count (call AS_location_fnc_cities),["FIA", "shortname"] call AS_fnc_getEntity,["AAF", "shortname"] call AS_fnc_getEntity];

openMap true;

posicionTel = [];
onMapSingleClick "posicionTel = _pos;";

while {visibleMap} do {
	if (count posicionTel > 0) then {
		private _location = posicionTel call AS_location_fnc_nearest;
		private _position = _location call AS_location_fnc_position;
		private _type = _location call AS_location_fnc_type;
		private _side = _location call AS_location_fnc_side;
		private _texto = "Click on a location";
		if (_location == "FIA_HQ") then {
			_texto = format ["%2 HQ%1",[_location] call AS_fnc_getGarrisonAsText, ["FIA", "shortname"] call AS_fnc_getEntity];
		};
		if (_side == "FIA" and {_type in ["camp", "watchpost", "roadblock"]}) then {
			_texto = format ["%1\n%2",_type, [_location] call AS_fnc_getGarrisonAsText];
		};
		if (_type == "city") then {
			_texto = format ["%1\nPopulation: %2\n%6 Support: %3 %5\n%7 Support: %4 %5",
				_location call AS_fnc_location_name,
				[_location, "population"] call AS_location_fnc_get,
				[_location, "AAFsupport"] call AS_location_fnc_get,
				[_location, "FIAsupport"] call AS_location_fnc_get,
				"%",
				["AAF", "shortname"] call AS_fnc_getEntity,
				["FIA", "shortname"] call AS_fnc_getEntity
			];
			if ([_location] call AS_fnc_location_isPowered) then {_texto = format ["%1\nPowered",_texto]} else {_texto = format ["%1\nNot Powered",_texto]};
			if (_side == "AAF") then {if (_position call AS_fnc_hasRadioCoverage) then {_texto = format ["%1\nRadio Comms ON",_texto]} else {_texto = format ["%1\nRadio Comms OFF",_texto]}};
			if (_location in AS_P("destroyedLocations")) then {_texto = format ["%1\nDESTROYED",_texto]};
			if (_side == "FIA") then {_texto = format ["%1\n%2", _texto, [_location] call AS_fnc_getGarrisonAsText]};

			private _description = "Cities provide money and recruits proportional to its population.
				They contribute to the faction supported the most.";
			_texto = format ["%1\n\n%2",_texto, _description];
		};
		if (_type == "airfield") then {
			if (_side == "AAF") then {
				_texto = format ["%2 %1", _location call AS_fnc_location_name, ["AAF", "shortname"] call AS_fnc_getEntity];
				private _busy = _location call AS_location_fnc_busy;
				if (_position call AS_fnc_hasRadioCoverage) then {_texto = format ["%1\n\nRadio Comms ON",_texto]} else {_texto = format ["%1\n\nRadio Comms OFF",_texto]};
				if (!_busy) then {_texto = format ["%1\nStatus: Idle",_texto]} else {_texto = format ["%1\nStatus: Busy",_texto]};
			} else {
				_texto = format ["%3 %1\n%2", _location call AS_fnc_location_name, [_location] call AS_fnc_getGarrisonAsText, ["FIA", "shortname"] call AS_fnc_getEntity];
			};
		};
		if (_type == "base") then {
			if (_side == "AAF") then {
				_texto = format ["%1 Base", ["AAF", "shortname"] call AS_fnc_getEntity];
				private _busy = _location call AS_location_fnc_busy;
				if (_position call AS_fnc_hasRadioCoverage) then {_texto = format ["%1\n\nRadio Comms ON",_texto]} else {_texto = format ["%1\n\nRadio Comms OFF",_texto]};
				if (!_busy) then {_texto = format ["%1\nStatus: Idle",_texto]} else {_texto = format ["%1\nStatus: Busy",_texto]};
			} else {
				_texto = format ["FIA Base%1",[_location] call AS_fnc_getGarrisonAsText];
			};
		};
		if (_type == "powerplant") then {
			if (_side == "AAF") then {
				_texto = format ["%1 Powerplant", ["AAF", "shortname"] call AS_fnc_getEntity];
				if (_position call AS_fnc_hasRadioCoverage) then {_texto = format ["%1\n\nRadio Comms ON",_texto]} else {_texto = format ["%1\n\nRadio Comms OFF",_texto]};
			} else {
				_texto = format ["%2 Powerplant%1",[_location] call AS_fnc_getGarrisonAsText, ["FIA", "shortname"] call AS_fnc_getEntity];
			};
			if (_location in AS_P("destroyedLocations")) then {_texto = format ["%1\nDESTROYED",_texto]};
		};
		if (_type == "resource") then {
			_texto = _location call AS_fnc_location_name;
			if ([_location] call AS_fnc_location_isPowered) then {_texto = format ["%1\n\nPowered",_texto]} else {_texto = format ["%1\n\nNo Powered",_texto]};
			if (_side == "AAF") then {if (_position call AS_fnc_hasRadioCoverage) then {_texto = format ["%1\nRadio Comms ON",_texto]} else {_texto = format ["%1\nRadio Comms OFF",_texto]}};
			if (_location in AS_P("destroyedLocations")) then {_texto = format ["%1\nDESTROYED",_texto]};

			private _description = "Resource locations double the money income when unpowered, and 4x when powered.";
			_texto = format ["%1\n\n%2",_texto, _description];
		};
		if (_type == "factory") then {
			_texto = _location call AS_fnc_location_name;
			if ([_location] call AS_fnc_location_isPowered) then {_texto = format ["%1\n\nPowered",_texto]} else {_texto = format ["%1\n\nNo Powered",_texto]};
			if (_side == "AAF") then {if (_position call AS_fnc_hasRadioCoverage) then {_texto = format ["%1\nRadio Comms ON",_texto]} else {_texto = format ["%1\nRadio Comms OFF",_texto]}};
			if (_location in AS_P("destroyedLocations")) then {_texto = format ["%1\nDESTROYED",_texto]};

			private _description = "Each factory increases money income by 25% when powered.";
			_texto = format ["%1\n\n%2",_texto, _description];
		};
		if (_type in ["outpost", "outpostAA"]) then {
			if (_side == "AAF") then {
				_texto = format ["%1 Outpost", ["AAF", "shortname"] call AS_fnc_getEntity];
				if (_position call AS_fnc_hasRadioCoverage) then {
					_texto = format ["%1\n\nRadio Comms ON",_texto]
				} else {
					_texto = format ["%1\n\nRadio Comms OFF",_texto]
				};
			} else {
				_texto = format ["%2 Outpost%1",[_location] call AS_fnc_getGarrisonAsText, ["FIA", "shortname"] call AS_fnc_getEntity];
			};
		};
		if (_type == "seaport") then {
			if (_side == "AAF") then {
				_texto = format ["%1 Seaport", ["AAF", "shortname"] call AS_fnc_getEntity];
				if (_position call AS_fnc_hasRadioCoverage) then {_texto = format ["%1\n\nRadio Comms ON",_texto]} else {_texto = format ["%1\n\nRadio Comms OFF",_texto]};
			} else {
				_texto = format ["%2 Seaport%1",[_location] call AS_fnc_getGarrisonAsText, ["FIA", "shortname"] call AS_fnc_getEntity];
			};

			private _description = "Each seaport reduces the price of vehicles by 10%";
			_texto = format ["%1\n\n%2",_texto, _description];
		};
		hint format ["%1",_texto];
		};
	posicionTel = [];
	sleep 1;
};
onMapSingleClick "";
