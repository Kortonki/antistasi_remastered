#include "macros.hpp"
AS_SERVER_ONLY("fnc_onPlayerDisconnect.sqf");

params ["_unit"];

// first, if player is controlling another unit, drop that control
_unit call AS_fnc_safeDropAIcontrol;

if (_unit == AS_commander) then {

	//TODO: Consider this: Is it really necessary to delete all FIA units? Assuming new commander takes over.

	/*private _recursos = 0;
	private _hr = 0;
	{
		// all FIA units
		if ((leader _x call AS_fnc_getSide == "FIA") and
		   {leader _x getVariable ["BLUFORspawn",false]} and
		   {!isPlayer leader _x}) then {
			{
				if (alive _x) then {
					_recursos = _recursos + ((_x call AS_fnc_getFIAUnitType) call AS_fnc_getCost);
					_hr = _hr + 1;
				};
				// check for vehicles
				if not(isNull (assignedVehicle _x)) then {
					private _veh = assignedVehicle _x;
					private _tipoVeh = typeOf _veh;
					if ((_veh isKindOf "StaticWeapon") and (not(_veh in AS_P("vehicles")))) then {
						_recursos = _recursos + ([_tipoVeh] call AS_fnc_getFIAvehiclePrice) + ([typeOf (vehicle leader _x)] call AS_fnc_getFIAvehiclePrice);
					} else {
						call {
							if (_tipoVeh in (["FIA", "vehicles"] call AS_fnc_getEntity)) exitWith {
								// this is the buying price because it
								// is assumed it is not the player's fault
								_recursos = _recursos + ([_tipoVeh] call AS_fnc_getFIAvehiclePrice);
							};
							private _category = _tipoVeh call AS_AAFarsenal_fnc_category;
							if (_category != "") exitWith {
								_recursos = _recursos  + (_category call AS_AAFarsenal_fnc_value);
							};
						};
						if (count attachedObjects _veh > 0) then {
							private _subVeh = (attachedObjects _veh) select 0;
							_recursos = _recursos + ([(typeOf _subVeh)] call AS_fnc_getFIAvehiclePrice);
							deleteVehicle _subVeh;
						};
					};
					if !(_veh in AS_P("vehicles")) then {deleteVehicle _veh};
				};
				// todo: the unit's arsenal is gone. Fixe it.



				deleteVehicle _x;
			} forEach (units _x);
		};
	} forEach allGroups;
*/
	["disconnected"] remoteExec ["AS_fnc_chooseCommander", 2];
	// in case the commander disconnects while moving the HQ, HQ is built in the location.
	//if (group petros == group _unit) then {call AS_fnc_HQbuild};

	//if ((_hr > 0) or (_recursos > 0)) then {[_hr,_recursos] spawn AS_fnc_changeFIAmoney};
};

// store the player arsenal in the box.
private _cargoArray = [_unit, true] call AS_fnc_getUnitArsenal;
[caja, _cargoArray select 0, _cargoArray select 1, _cargoArray select 2, _cargoArray select 3] call AS_fnc_populateBox;
[cajaVeh, (_cargoArray select 4)] call AS_fnc_addMagazineRemains;

private _group = group _unit;

if (count (units _group select {!(isPlayer _x)}) > 0 and {_unit == leader _group}) then {
	[(units _group) select {!(isPlayer _x)}] remoteExec ["AS_fnc_dismissFIAunits", _group];
};

if (alive _unit and {!(_unit call AS_medical_fnc_isUnconscious)}) then {

		[1, 50] remoteExec ["AS_fnc_changeFIAMoney", 2];
	};

private _pos = getPosATL _unit;
private _wholder = nearestObjects [_pos, ["weaponHolderSimulated", "weaponHolder"], 2];
{deleteVehicle _x;} forEach _wholder + [_unit];
