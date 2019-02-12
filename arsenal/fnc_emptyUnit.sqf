params ["_unit"];

// see http://stackoverflow.com/a/43189968/7808917

{
_unit removeWeaponGlobal _x
} foreach (weapons _unit);

{
  _unit removeMagazineGlobal _x
} foreach (magazines _unit);
removeAllItems _unit;
removeAllAssignedItems _unit;
removeVest _unit;
removeBackpackGlobal _unit;
removeHeadgear _unit;
removeGoggles _unit;
