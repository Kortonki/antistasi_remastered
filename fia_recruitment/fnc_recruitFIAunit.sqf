#include "../macros.hpp"
params ["_player", "_type"];
AS_SERVER_ONLY("fnc_recruitFIAunit");

if (AS_P("hr") < 1) exitWith {
    [_player, "hint", "You do not have enough HR for this request"] remoteExec ["AS_fnc_localCommunication", _player];
};

private _cost = _type call AS_fnc_getCost;
private _moneyAvailable = AS_P("resourcesFIA");
if isMultiPlayer then {
    _moneyAvailable = [_player, "money"] call AS_players_fnc_get;
};

if (_cost > _moneyAvailable) exitWith {
    [_player, "hint", "You do not have enough money for this kind of unit"] remoteExec ["AS_fnc_localCommunication", _player];
};

private _equipment = [_type] call AS_fnc_getBestEquipment;

_equipment params ["_vest", "_helmet", "_googles", "_backpack", "_primaryWeapon", "_primaryMags", "_secondaryWeapon", "_secondaryMags", "_scope", "_uniformItems", "_backpackItems", "_primaryWeaponItems", "_binoculars"];

if (_type == "Sniper" and (_primaryWeapon == "" or ([_primaryMags] call AS_fnc_getTotalCargo) < 6 or _scope == "")) exitWith {
    [_player, "hint", "No snipers, scopes or ammo to equip a sniper."] remoteExec ["AS_fnc_localCommunication", _player];
};
if (_type == "Grenadier" and _primaryWeapon == "") exitWith {
    // todo: check existence of enough grenades.
    [_player, "hint", "No grenade launchers or ammo to equip a grenadier."] remoteExec ["AS_fnc_localCommunication", _player];
};
if (_type in ["AA Specialist", "AT Specialist"] and _secondaryWeapon == "") exitWith {
    // todo: check existence of enough rockets
    // todo: check existence of AA/AT launchers
    [_player, "hint", "No launchers."] remoteExec ["AS_fnc_localCommunication", _player];
};

if (_type == "Rifleman" and _primaryWeapon == "") then {
    [_player, "hint", "No rifles or ammo to equip a rifleman"] remoteExec ["AS_fnc_localCommunication", _player];
};

if not isMultiPlayer then {
    [-1, -_cost] call AS_fnc_changeFIAmoney;
} else {
    [-1, 0] call AS_fnc_changeFIAmoney;
    [_player, "money", -_cost] call AS_players_fnc_change;
    [_player, "hint", "Soldier Recruited.\n\nRemember: if you use the group menu to switch groups you will lose control of your recruited AI"] remoteExec ["AS_fnc_localCommunication", _player];
};
[petros, "directSay", "SentGenReinforcementsArrived"] remoteExec ["AS_fnc_localCommunication", _player];

// the unit becomes owned by the client because the group is owned by the client
//However, "AI units created after mission start via scripting will be local to the computer that issued the command"
[_type, position _player, group _player, true, [true, nil, _equipment]] remoteExec ["AS_fnc_spawnFIAUnit", _player];



// THese will be run on client via SpawnFIAunit
//[_unit, true, nil, _equipment] remoteExecCall ["AS_fnc_initUnitFIA", _player];
//[_unit, "AUTOCOMBAT"] remoteExec ["disableAI", _player];
