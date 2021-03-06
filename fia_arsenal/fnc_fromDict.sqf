#include "../macros.hpp"
AS_SERVER_ONLY("AS_FIAarsenal_fnc_fromDict");
params ["_dict"];
private _cargo_w = [_dict, "weapons"] call DICT_fnc_get;
private _cargo_m = [_dict, "magazines"] call DICT_fnc_get;
private _cargo_i = [_dict, "items"] call DICT_fnc_get;
private _cargo_b = [_dict, "backpacks"] call DICT_fnc_get;

unlockedWeapons = [_dict, "unlockedWeapons"] call DICT_fnc_get;
unlockedMagazines = [_dict, "unlockedMagazines"] call DICT_fnc_get;
unlockedItems = [_dict, "unlockedItems"] call DICT_fnc_get;
unlockedBackpacks = [_dict, "unlockedBackpacks"] call DICT_fnc_get;
publicVariable "unlockedWeapons";
publicVariable "unlockedMagazines";
publicVariable "unlockedItems";
publicVariable "unlockedBackpacks";

[_cargo_w, _cargo_m, _cargo_i, _cargo_b] call AS_fnc_setArsenal;

//Tell petros and garrison to equip themselves
AS_Arsenal_initialized = true;
publicVariable "AS_Arsenal_initialized";
