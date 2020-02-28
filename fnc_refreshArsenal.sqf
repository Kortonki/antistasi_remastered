#include "macros.hpp"
AS_SERVER_ONLY("fnc_refreshArsenal.sqf");
// _clean: whether to clean unavailable mod-weapons from `unlocked*`.
params [["_clean", false]];

if _clean then {
    unlockedWeapons = unlockedWeapons arrayIntersect unlockedWeapons;
    unlockedWeapons = unlockedWeapons arrayIntersect AS_allWeapons;
    publicVariable "unlockedWeapons";

    unlockedMagazines = unlockedMagazines arrayIntersect unlockedMagazines;
    unlockedMagazines = unlockedMagazines arrayIntersect AS_allMagazines;
    publicVariable "unlockedMagazines";

    //Remove blanks
    private _magazineCargo = ([caja, true] call AS_fnc_getBoxArsenal) select 1;
    {
      private _ammo = getText (configFile >> "CfgMagazines" >> _x >> "ammo");
      if (_ammo find "blank" != -1) then {
        (_magazineCargo select 1) set [_forEachIndex, 0]; // no delete to keep foreachindex valid
      };
    } foreach (_magazineCargo select 0);

    unlockedItems = unlockedItems arrayIntersect unlockedItems;
    unlockedItems pushBackUnique "Binocular";
    publicVariable "unlockedItems";

    unlockedBackpacks = unlockedBackpacks arrayIntersect unlockedBackpacks;
    publicVariable "unlockedBackpacks";

AS_Sset("lockArsenal", false); //This to relieve the lock if it's let on

[caja, getWeaponCargo caja, _magazineCargo, getItemCargo caja, getBackpackCargo caja, true, true] call AS_fnc_populateBox;

};

//Above put in to clean function to avoid out sync arsenal shenanigans. AddweaponcargoGlobal etc. are already jip compatible so no need to do above in jip

//FAILSAFE to enable arsenal again
//Make repair action elsewhere. This is run on every client init so commented out
//

[caja, "remove"] remoteExecCall ["AS_fnc_addAction", [0,-2] select isDedicated];

[caja, "arsenal"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];
[caja, "transferFrom"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];
[caja, "emptyplayer"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];
[caja, "moveObject"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];

diag_log "[AS] Server: Arsenal resynchronised";
