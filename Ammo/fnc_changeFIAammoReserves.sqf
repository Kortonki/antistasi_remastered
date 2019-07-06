#include "../macros.hpp"
AS_SERVER_ONLY("AS_fnc_changeFIAammoReserves.sqf");

params ["_actualAmmo"];

if (_actualAmmo == 0) exitWith {};

if (not (isNil "AS_LOCK_changeFIAammoReserves")) then {
	waitUntil {sleep 1; isNil "AS_LOCK_changeFIAammoReserves"};
};
AS_LOCK_changeFIAammoReserves = true;

private _oldReserve = AS_P("ammoFIA");
private _newReserve = _oldReserve + _actualAmmo;

AS_Pset("ammoFIA", _newReserve);

AS_LOCK_changeFIAammoReserves = nil;

//Notification

private _texto = "";
private _ammoSym = "";
if (_actualAmmo > 0) then {_ammoSym = "+"};

//show decimals if change less than 1 liter

if (_actualAmmo > -1 and _actualAmmo < 1) then {
   _actualAmmo = _actualAmmo toFixed 1;
}
else {
  _actualAmmo = round(_actualAmmo);
};

_texto = format ["<t size='0.5' color='#C1C0BB'>Ammo reserves:<br/> %2%1 l",_actualAmmo,_ammoSym];

if (_texto != "") then {
	[petros,"income",_texto] remoteExec ["AS_fnc_localCommunication", AS_commander]
};
