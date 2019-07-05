//Return vehicle ammo

params ["_vehicle"];

if (isNull _vehicle) exitWith {diag_log format["[AS] Error: AS_fnc_getVehicleFuel.sqf: No vehicle specified"]; 0};
 
private _actualAmmo = 0;
private _caliber = 0;
 
private _mags = magazinesAllTurrets _vehicle; 
 
{  
	private _magazineType = _x select 0; 
	diag_log _magazineType;
	private _ammoCount = _x select 2; 
 
	private _ammoType = [configFile >> "CfgMagazines" >> _magazineType, "ammo"] call BIS_fnc_returnConfigEntry;
 
	if (hasACE) then
	{
		_caliber = [configFile >> "CfgAmmo" >> _ammoType, "ACE_caliber"] call BIS_fnc_returnConfigEntry; 
		if (isNil "_caliber") then { _caliber = [configFile >> "CfgAmmo" >> _ammoType, "ace_rearm_caliber"] call BIS_fnc_returnConfigEntry; }; 
	}
	else
	{
		_caliber = [configFile >> "CfgAmmo" >> _ammoType, "cost"] call BIS_fnc_returnConfigEntry; 
	};

	_actualAmmo = _actualAmmo + (_caliber * _ammoCount);
	diag_log _actualAmmo;

} forEach _mags; 
 
_actualAmmo