#include "../macros.hpp"
AS_SERVER_ONLY("AS_fnc_buyGear.sqf");
params ["_type", "_money", "_player"];
private ["_weapons", "_accessories", "_amount"];

if (_player == AS_commander and {AS_P("resourcesFIA") < _money}) exitWith {
	[AS_commander, "hint", "not enough FIA money :("] remoteExec ["AS_fnc_localCommunication", AS_commander];
};

if (_player != AS_commander and {([_player, "money"] call AS_players_fnc_get) < _money}) exitWith {
	[_player, "hint", "not enough personal money :("] remoteExec ["AS_fnc_localCommunication", _player];
};

private _buyableWeapons = AAFWeapons + NATOWeapons + CSATWeapons;
private _buyableItems = AAFItems + NATOItems + CSATItems;
private _buyableExplosives = (["AAF", "explosives"] call AS_fnc_getEntity) + (["NATO", "explosives"] call AS_fnc_getEntity) + (["CSAT", "explosives"] call AS_fnc_getEntity);
private _buyableAPMines =(["AAF", "ap_mines"] call AS_fnc_getEntity) + (["NATO", "ap_mines"] call AS_fnc_getEntity) + (["CSAT", "ap_mines"] call AS_fnc_getEntity);
private _buyableATMines =  (["AAF", "at_mines"] call AS_fnc_getEntity) + (["NATO", "at_mines"] call AS_fnc_getEntity) + (["CSAT", "at_mines"] call AS_fnc_getEntity);

switch (_type) do {
	case "ASRifles": {_weapons = _buyableWeapons arrayIntersect (AS_weapons select 0); _amount = 10;};  // assault + G. launchers
	case "Machineguns": {_weapons = _buyableWeapons arrayIntersect (AS_weapons select 6); _amount = 5;};
	case "Sniper Rifles": {_weapons = _buyableWeapons arrayIntersect (AS_weapons select 15); _amount = 2;};
	case "Launchers": {_weapons = _buyableWeapons arrayIntersect ((AS_weapons select 8) + (AS_weapons select 10) + (AS_weapons select 5)); _amount = 2;};
	case "Pistols": {_weapons = _buyableWeapons arrayIntersect (AS_weapons select 4); _amount = 20;};
	case "GLaunchers": {_weapons = _buyableWeapons arrayIntersect (AS_weapons select 3); _amount = 5;};

	case "assessories": {
        _accessories = _buyableItems arrayIntersect (AS_allOptics + AS_allBipods + AS_allMuzzles + AS_allMounts + AS_allUAVs) - unlockedItems;
        for "_i" from 1 to 4 do {
			expCrate addItemCargoGlobal [selectRandom _accessories, 1];
		};
	};

	case "explosives": {
			expCrate addMagazineCargoGlobal [(selectRandom _buyableExplosives) call AS_fnc_mineMag, 20];
	};

	case "mines": {
    expCrate addMagazineCargoGlobal [(selectRandom _buyableAPMines) call AS_fnc_mineMag, 20];
		expCrate addMagazineCargoGlobal [(selectRandom _buyableATMines) call AS_fnc_mineMag, 10];
	};
};

if (_type in ["ASRifles", "Machineguns", "Sniper Rifles", "Launchers", "Pistols", "GLaunchers"]) then {
	_weapons = _weapons - unlockedWeapons;
    for "_i" from 1 to _amount do {
        private _weapon = selectRandom _weapons;
        expCrate addItemCargoGlobal [_weapon, 1];
        private _magazines = AS_allWeaponsAttrs select (AS_allWeapons find _weapon) select 2;
        expCrate addMagazineCargoGlobal [selectRandom _magazines, 20];
    };
};

[0, -_money] remoteExec ["AS_fnc_changeFIAmoney",2];
