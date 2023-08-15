params ["_crate", "_NATOSupp"];
private ["_intNATOSupp", "_weapons","_magazines","_items","_backpacks","_addWeapon"];

_intNATOSupp = round (_NATOSupp/10);
_intNATOSupp = _intNATOSupp max 1;

_weapons = [[],[]];
_magazines = [[],[]];
_items = [[],[]];
_backpacks = [[],[]];

_addWeapon = {
	params ["_weapon", "_amount", "_magsAmount"];
	if (_amount < 1) exitWith {};
	private _mags = (getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines")) select {_x call AS_fnc_excludeBlanks}; //exclude blanks TODO: other ways to detect blanks
	private _mag = selectRandom _mags;

	(_weapons select 0) pushBack _weapon;
	(_weapons select 1) pushBack _amount;
	(_magazines select 0) pushBack _mag;
	(_magazines select 1) pushBack _magsAmount;
};

// Handguns and submachine guns
[selectRandom (NATOweapons arrayIntersect ((AS_weapons select 4) + (AS_weapons select 14))), 4*_intNATOSupp, 18*4*_intNATOSupp] call _addWeapon;
// Rifles
[selectRandom (NATOweapons arrayIntersect (AS_weapons select 0)), 4*_intNATOSupp, 18*4*_intNATOSupp] call _addWeapon;
// Machine guns
[selectRandom (NATOweapons arrayIntersect (AS_weapons select 6)), _intNATOSupp, 6*_intNATOSupp] call _addWeapon;

// GLs
[selectRandom (NATOweapons arrayIntersect (AS_weapons select 3)), _intNATOSupp, 18*_intNATOSupp] call _addWeapon;
// HE Grenades
(_magazines select 0) pushBack ((NATOMagazines arrayIntersect AS_allGrenades) select 0);
(_magazines select 1) pushBack 6*_intNATOSupp;
// Any grenades
(_magazines select 0) pushBack (selectRandom (NATOMagazines arrayIntersect AS_allGrenades));
(_magazines select 1) pushBack 6*_intNATOSupp;

// Snipers
[selectRandom (NATOweapons arrayIntersect (AS_weapons select 15)), _intNATOSupp, 20*_intNATOSupp] call _addWeapon;
private _bestScope = [NATOItems arrayIntersect AS_allOptics, "sniperScope"] call AS_fnc_getBestItem;
(_items select 0) pushBack _bestScope;
(_items select 1) pushBack _intNATOSupp;

if (count (NATOLaunchers arrayIntersect (AS_weapons select 16)) > 0) then {
	[selectRandom (NATOLaunchers arrayIntersect (AS_weapons select 16)), _intNATOSupp, 2*_intNATOSupp] call _addWeapon;
} else {
	[selectRandom (NATOLaunchers arrayIntersect (AS_weapons select 10)), _intNATOSupp, 2*_intNATOSupp] call _addWeapon;
};
[selectRandom (NATOLaunchers arrayIntersect (AS_weapons select 8)), _intNATOSupp, 2*_intNATOSupp] call _addWeapon;
[selectRandom (NATOLaunchers arrayIntersect (AS_weapons select 10)), _intNATOSupp, 2*_intNATOSupp] call _addWeapon;

for "_i" from 1 to 5 do {
	(_magazines select 0) pushBack (selectRandom NATOThrowGrenades);
	(_magazines select 1) pushBack 4*_intNATOSupp;
};

for "_i" from 1 to 5 do {
    (_items select 0) pushBack (selectRandom NATOVests);
    (_items select 1) pushBack _intNATOSupp;
};

for "_i" from 1 to 5 do {
    (_items select 0) pushBack (selectRandom NATOHelmets);
    (_items select 1) pushBack _intNATOSupp;
};

for "_i" from 1 to 3 do {
	(_items select 0) pushBack (selectRandom (NATOItems arrayIntersect (AS_allBipods + AS_allMuzzles + AS_allMounts)));
	(_items select 1) pushBack _intNATOSupp;
};

	for "_i" from 1 to 5 do {

		(_backpacks select 0) pushback (selectRandom NatoBackpacks);
		(_backpacks select 1) pushback _intNATOSupp;
};

//Add static bags

if (_intNATOSupp > random 10) then {

	private _staticpack = selectRandom (NATOBackpacks select {_x isEqualType []});
	if (isNil "_staticpack") exitWith {};
	//This means its a static bag
	{
		//Is the uav terminal
		if (_x find "UavTerminal" != -1) then { //For some reaseon iskindof Item_Base_F returned false for terminal even though its a parent
			(_items select 0) pushback _x;
			(_items select 1) pushback 1;

			if (hasACE) then {
				(_items select 0) pushback "ACE_UAVBattery";
				(_items select 1) pushback 2;
			};

		} else {
			(_backpacks select 0) pushback _x;
			(_backpacks select 1) pushback 1;
		};
	} foreach _staticpack;

};

//Add some mines + explosives

{
	(_magazines select 0) pushBack (_x call AS_fnc_mineMag);
	(_magazines select 1) pushBack 10*_intNatoSupp;
} foreach (["NATO", "ap_mines"] call AS_fnc_getEntity);

{
	(_magazines select 0) pushBack (_x call AS_fnc_mineMag);
	(_magazines select 1) pushBack 4*_intNatoSupp;
} foreach ((["NATO", "at_mines"] call AS_fnc_getEntity) + (["NATO", "explosives"] call AS_fnc_getEntity));

//TODO check if RHS has equivalents?
//TODO should be something in template
if (hasACE) then {
	(_magazines select 0) pushBack "ACE_HuntIR_M203";
	(_magazines select 1) pushBack 3*_intNATOSupp;

	(_items select 0) pushBack "ACE_HuntIR_monitor";
	(_items select 1) pushBack _intNATOSupp;

	(_items select 0) pushBack "ACE_Vector";
	(_items select 1) pushBack _intNATOSupp;

	(_items select 0) pushBack "ACE_microDAGR";
	(_items select 1) pushBack _intNATOSupp;

	(_items select 0) pushBack "ACE_ATragMX";
	(_items select 1) pushBack _intNATOSupp;

	(_items select 0) pushBack "ACE_Kestrel4500";
	(_items select 1) pushBack _intNATOSupp;

	(_items select 0) pushBack "ACE_Clacker";
	(_items select 1) pushBack _intNATOSupp;

} else {

	(_items select 0) pushBack "ItemGPS";
	(_items select 1) pushBack _intNATOSupp;

	(_items select 0) pushBack selectRandom (NATOBinoculars);
	(_items select 1) pushBack _intNATOSupp;
};

//NVGs

(_items select 0) pushBack selectRandom (NATOItems arrayIntersect AS_allNVGs);
(_items select 1) pushBack _intNATOSupp;

if hasTFAR then {
    _backpacks pushBack [(["NATO", "tfar_lr_radio"] call AS_fnc_getEntity), 2*_intNATOSupp];
};

//Medical equipment

private _medicalItems = ([_intNATOSupp, true] call AS_medical_fnc_crateMeds);

(_items select 0) append (_medicalItems select 0);
(_items select 1) append (_medicalItems select 1);

[_crate, _weapons, _magazines, _items, _backpacks, true, true] call AS_fnc_populateBox;

[_crate, "vehicle_cargo_check"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated];
