#include "../macros.hpp"
AS_SERVER_ONLY("AS_fnc_changeFIAfuelReserves.sqf");

params ["_actualFuel"];

if (_actualFuel == 0) exitWith {};

if (not (isNil "AS_LOCK_changeFIAfuelReserves")) then {
	waitUntil {sleep 1; isNil "AS_LOCK_changeFIAfuelReserves"};
};
AS_LOCK_changeFIAfuelReserves = true;

private _oldReserve = AS_P("fuelFIA");
private _newReserve = _oldReserve + _actualFuel;

AS_Pset("fuelFIA", _newReserve);

AS_LOCK_changeFIAfuelReserves = nil;

//Notification

private _texto = "";
private _fuelSim = "";
if (_actualFuel > 0) then {_fuelSim = "+"};

//show decimals if change less than 1 liter

if (_actualFuel > -1 and _actualFuel < 1) then {
   _actualFuel = _actualFuel toFixed 1;
}
else {
  _actualFuel = round(_actualFuel);
};

_texto = format ["<t size='0.5' color='#C1C0BB'>Fuel reserves:<br/> %2%1 l",_actualFuel,_fuelSim];

if (_texto != "") then {
	[petros,"income",_texto] remoteExec ["AS_fnc_localCommunication", AS_commander]
};
