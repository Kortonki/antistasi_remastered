params ["_crate", "_NATOSupp"];
private ["_intNATOSupp", "_weapons","_magazines","_items","_backpacks","_addWeapon"];

_intNATOSupp = floor (_NATOSupp/10);
_intNATOSupp = _intNATOSupp max 1;

_weapons = [[],[]];
_magazines = [[],[]];
_items = [[],[]];
_backpacks = [[],[]];

_addWeapon = {
	params ["_weapon", "_amount", "_mags"];
	if (_amount < 1) exitWith {};
	private _mag = selectRandom (getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines"));

	(_weapons select 0) pushBack _weapon;
	(_weapons select 1) pushBack _amount;
	(_magazines select 0) pushBack _mag;
	(_magazines select 1) pushBack _mags;
};

// Handguns and submachine guns
[selectRandom (NATOweapons arrayIntersect ((AS_weapons select 4) + (AS_weapons select 14))), 4*_intNATOSupp, 10*4*_intNATOSupp] call _addWeapon;
// Rifles
[selectRandom (NATOweapons arrayIntersect (AS_weapons select 0)), 3*_intNATOSupp, 10*3*_intNATOSupp] call _addWeapon;
// Machine guns
[selectRandom (NATOweapons arrayIntersect (AS_weapons select 6)), _intNATOSupp, 3*_intNATOSupp] call _addWeapon;

// GLs
[selectRandom (NATOweapons arrayIntersect (AS_weapons select 3)), _intNATOSupp, 10*_intNATOSupp] call _addWeapon;
// HE Grenades
(_magazines select 0) pushBack ((NATOMagazines arrayIntersect AS_allGrenades) select 0);
(_magazines select 1) pushBack 6*_intNATOSupp;
// Any grenades
(_magazines select 0) pushBack (selectRandom (NATOMagazines arrayIntersect AS_allGrenades));
(_magazines select 1) pushBack 6*_intNATOSupp;

// Snipers
[selectRandom (NATOweapons arrayIntersect (AS_weapons select 15)), _intNATOSupp, 10*_intNATOSupp] call _addWeapon;
private _bestScope = [NATOItems arrayIntersect AS_allOptics, "sniperScope"] call AS_fnc_getBestItem;
(_items select 0) pushBack _bestScope;
(_items select 1) pushBack _intNATOSupp;

[selectRandom NATOLaunchers, _intNATOSupp, 3*_intNATOSupp] call _addWeapon;
[selectRandom NATOLaunchers, _intNATOSupp, 3*_intNATOSupp] call _addWeapon;

for "_i" from 1 to 5 do {
	(_magazines select 0) pushBack (selectRandom NATOThrowGrenades);
	(_magazines select 1) pushBack 5*_intNATOSupp;
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

	(_backpacks select 0) pushback (selectRandom (NatoBackpacks));
	(_backpacks select 1) pushback _intNATOSupp;
};

//TODO check if RHS has equivalents?
if (hasACE and !hasRHS) then {
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
};

if hasTFAR then {
    _backpacks pushBack [(["NATO", "tfar_lr_radio"] call AS_fnc_getEntity), 2*_intNATOSupp];
};

//Medical equipment

if hasACE then {

		private _medicalItems = AS_aceBasicMedical;

		if (ace_medical_level == 2) then {_medicalItems append AS_aceAdvMedical};

		if (hasACEsplint) then {_medicalItems pushBack "adv_aceSplint_splint"};

		{
			if (random 10 < _intNATOSupp) then {

					//Table of medical equipment amounts (Natosupp / 10 * _coeff)

					private _coeff = call {
						if (_x isEqualTo "FirstAidKit") exitWith {10};
						if (_x isEqualTo "MediKit") exitWith {1};
						if (_x isEqualTo "ACE_fieldDressing") exitWith {20};
						if (_x isEqualTo "ACE_quikclot") exitWith {10};
						if (_x isEqualTo "ACE_tourniquet") exitWith {10};
						if (_x isEqualTo "ACE_morphine") exitWith {6};
						if (_x isEqualTo "ACE_epinephrine") exitWith {3};
						if (_x isEqualTo "ACE_adenosine") exitWith {3};
						if (_x isEqualTo "ACE_personalAidKit") exitWith {1};
						if (_x isEqualTo "ACE_surgicalKit") exitWith {1};
						if (_x isEqualTo "adv_aceSplint_splint") exitWith {4};
						if ((_x find "saline") > -1) exitWith {2};
						if ((_x find "blood") > -1) exitWith {1};
						if ((_x find "Bandage") > -1) exitWith {10};

						1
					};

					(_items select 0) pushBack _x;
					(_items select 1) pushBack _intNATOSupp*_coeff;
				};

		} foreach (_medicalItems - unlockedItems);

} else {

	(_items select 0) pushBack "FirstAidKit";
	(_items select 1) pushBack _intNatoSupp*10;

	(_items select 0) pushBack "MediKit";
	(_items select 1) pushBack _intNatoSupp;

};

[_crate, _weapons, _magazines, _items, _backpacks, true, true] call AS_fnc_populateBox;
