#include "macros.hpp"
AS_SERVER_ONLY("AS_fnc_rearmPetros.sqf");
private _mag = currentMagazine petros;
petros removeMagazines _mag;
petros removeWeaponGlobal (primaryWeapon petros);
//[petros, selectRandom (AAFWeapons arrayIntersect (AS_weapons select 0)), 5, 0] call BIS_fnc_addWeapon;
private _equipment = "Squad Leader" call AS_fnc_getBestEquipment;
[petros, _equipment] call AS_fnc_equipUnit;

//petros selectweapon primaryWeapon petros;
