#include "../macros.hpp"

params ["_cargo", ["_notify", false]];

waitUntil {sleep 0.1; not(AS_S("lockTransfer"))};
AS_Sset("lockTransfer", true);
/*
([caja] call AS_fnc_getBoxArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b"];
_cargo_w = [_cargo_w, _cargo select 0] call AS_fnc_mergeCargoLists;
_cargo_m = [_cargo_m, _cargo select 1] call AS_fnc_mergeCargoLists;
_cargo_i = [_cargo_i, _cargo select 2] call AS_fnc_mergeCargoLists;
_cargo_b = [_cargo_b, _cargo select 3] call AS_fnc_mergeCargoLists;

[caja, _cargo_w, _cargo_m, _cargo_i, _cargo_b, true, true] call AS_fnc_populateBox;
*/

private _cargo_w = _cargo select 0;
private _cargo_m = _cargo select 1;
private _cargo_i = _cargo select 2;
private _cargo_b = _cargo select 3;

[caja, _cargo_w, _cargo_m, _cargo_i, _cargo_b, true] call AS_fnc_populateBox;

//Experiment for a more efficient mode for adding
/*
private _weapons = (_cargo select 0) select 0;
private _weaponsCount = (_cargo select 0) select 1;
private _weaponsTot = 0;

{
  caja addweaponCargoGlobal [_x, (_weaponsCount select _forEachIndex)];
  _weaponsTot = _weaponsTot + (_weaponsCount select _foreachIndex);
} foreach _weapons;

private _magazines = (_cargo select 1) select 0;
private _magazinesCount = (_cargo select 1) select 1;
private _magazinesTot = 0;
{
  caja addMagazineCargoGlobal [_x, (_magazinesCount select _forEachIndex)];
  _magazinesTot = _magazinesTot + (_magazinesCount select _foreachIndex);
} foreach _magazines;

private _items = (_cargo select 2) select 0;
private _itemsCount = (_cargo select 2) select 1;
private _itemsTot = 0;
{
  caja addItemCargoGlobal [_x, (_itemsCount select _forEachIndex)];
  _itemsTot = _itemsTot + (_itemsCount select _foreachIndex);
} foreach _items;

private _backpacks = (_cargo select 2) select 0;
private _backPacksCount = (_cargo select 2) select 1;
private _backpacksTot = 0;
{
  caja addBackpackCargoGlobal [_x, (_backPacksCount select _forEachIndex)];
  _backpacksTot = _backpacksTot + (_backpacksCount select _foreachIndex);
} foreach _backpacks;

if _notify then {
  private _text = format ["Arsenal additions<br>Weapons: %1<br>Magazines: %2<br>Items: %3<br>Backpacks: %4", _weaponsTot, _magazinesTot,_itemsTot, _backpacksTot];
  [objNull, "income", _text] remoteExec ["AS_fnc_localCommunication", [0,-2] select isDedicated];
  };
*/

AS_Sset("lockTransfer", false);
