#include "macros.hpp"
AS_CLIENT_ONLY("fnc_showFoundIntel");

private _chance = 8;

params ["_location_or_unit"];
if (_location_or_unit isEqualType "") then {
	if ((_location_or_unit call AS_location_fnc_type) in ["base","airfield", "radio"]) then {
		_chance = 30;
	} else {
		_chance = 15;
	};
} else {
	// _this is a unit
	_chance = ((typeOf _location_or_unit) call AS_fnc_getCost) / 2;
};

private _texto = format ["<t size='0.6' color='#C1C0BB'>Intel Found.<br/> <t size='0.5' color='#C1C0BB'><br/>"];

if (random 100 < _chance) then {
	_texto = format ["%1 %2 Troop Skill Level: %3<br/>",_texto, (["AAF", "name"] call AS_fnc_getEntity), AS_P("skillAAF")];
};
if (random 100 < _chance) then {
	private _minutes = (numberToDate [2035, (AS_P("nextAttack") - (datetoNumber date))]) select 4;
	_texto = format ["%1 %2 Next possible counterattack: %3 minutes<br/>",_texto, (["AAF", "name"] call AS_fnc_getEntity), _minutes];
};
if (random 100 < _chance) then {
	private _AAFresAdj = call AS_fnc_getAAFresourcesAdj;
	if (_AAFresAdj <= 2000) then {
		if (_AAFresADj <= 1000) then {
			_texto = format ["%1 %2 Funds: Poor (low ammo and fuel)<br/>",_texto, (["AAF", "name"] call AS_fnc_getEntity)];
		} else {
			_texto = format ["%1 %2 Funds: Inadequate (low fuel)<br/>",_texto, (["AAF", "name"] call AS_fnc_getEntity)];
		};
	} else {
		_texto = format ["%1 %2 Funds: %3 €<br/>",_texto, (["AAF", "name"] call AS_fnc_getEntity), AS_P("resourcesAAF")];
	};
};

if (random 100 < _chance) then {
	private _csatSupport = AS_P("CSATsupport");
		_texto = format ["%1 %2 Support: %3<br/>",_texto, (["CSAT", "name"] call AS_fnc_getEntity), _csatSupport];
};

{
	if (random 100 < _chance) then {
		private _count = (_x call AS_AAFarsenal_fnc_count);
		if (_count < 1) then {
			_count = "None";
		};
		_texto = format ["%1 %2 %3: %4<br/>",_texto, (["AAF", "name"] call AS_fnc_getEntity), _x call AS_AAFarsenal_fnc_name, _count];
	};
} forEach call AS_AAFarsenal_fnc_all;

{
	if (random 100 < _chance) then {
		_texto = format ["%1 %2 knows about %3 near %4<br/>",_texto, (["AAF", "name"] call AS_fnc_getEntity), _x call AS_location_fnc_type, ["city" call AS_location_fnc_T, _x call AS_location_fnc_position] call BIS_fnc_nearestPosition];
	};

} foreach ([] call AS_location_fnc_knownLocations);

if (_texto == "<t size='0.6' color='#C1C0BB'>Intel Found.<br/> <t size='0.5' color='#C1C0BB'><br/>") then {
	_texto = format ["<t size='0.6' color='#C1C0BB'>Intel Not Found.<br/> <t size='0.5' color='#C1C0BB'><br/>"];
};

[_texto, [safeZoneX, (0.2 * safeZoneW)], [0.25, 0.5], 30, 0, 0, 4] spawn bis_fnc_dynamicText;
