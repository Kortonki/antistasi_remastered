#include "../macros.hpp"
AS_SERVER_ONLY("AS_FIAarsenal_fnc_toDict");
private _dict = call DICT_fnc_create;

private _all = [[[], []], [[], []], [[], []], [[], []]];
private _allMagazineRemains = [];

private _fnc_getUnitsEquipment = {
    params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b"];

    {
        if ((_x call AS_fnc_getSide == "FIA") and {alive _x}) then {
            private _arsenal = [_x, true] call AS_fnc_getUnitArsenal;
            _cargo_w = [_cargo_w, _arsenal select 0] call AS_fnc_mergeCargoLists;
            _cargo_m = [_cargo_m, _arsenal select 1] call AS_fnc_mergeCargoLists;
            _cargo_i = [_cargo_i, _arsenal select 2] call AS_fnc_mergeCargoLists;
            _cargo_b = [_cargo_b, _arsenal select 3] call AS_fnc_mergeCargoLists;
            {
              _allMagazineRemains pushback _x; //Get array of partial mags with [type, ammo] to allmagsremains
            } foreach (_arsenal select 4);
        };
    } forEach allUnits;
    [_cargo_w, _cargo_m, _cargo_i, _cargo_b]
};

private _fnc_getVehiclesEquipment = {
    params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b"];
    {
        private _closest = (getPos _x) call AS_location_fnc_nearest;
        private _size = _closest call AS_location_fnc_size;
        if ((_closest call AS_location_fnc_side == "FIA") and
                {(_x in AS_permanent_HQplacements) or (_x call AS_fnc_getSide) == "FIA"} and
                {alive _x} and
                {_x distance2D (_closest call AS_location_fnc_position) < _size} and
                {private _invalid = weaponsItemsCargo _x; not isNil "_invalid"}) then {

            private _arsenal = [_x, true] call AS_fnc_getBoxArsenal;
            _cargo_w = [_cargo_w, _arsenal select 0] call AS_fnc_mergeCargoLists;
            _cargo_m = [_cargo_m, _arsenal select 1] call AS_fnc_mergeCargoLists;
            _cargo_i = [_cargo_i, _arsenal select 2] call AS_fnc_mergeCargoLists;
            _cargo_b = [_cargo_b, _arsenal select 3] call AS_fnc_mergeCargoLists;
            {
              _allMagazineRemains pushback _x; //Get array of partial mags with [type, ammo] to allmagsremains
            } foreach (_arsenal select 4);
        };
    } forEach vehicles;
    [_cargo_w, _cargo_m, _cargo_i, _cargo_b]
};

//Collect also loot from dead bodies as in collectdroppedequipment when despawning a location
private _fnc_collectDroppedEquipment = {
params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b"];
{

  private _location = _x;
  private _size = _location call AS_location_fnc_size;
  private _position = _location call AS_location_fnc_position;

  {
    private _arsenal = [_x, true] call AS_fnc_getBoxArsenal;
    _cargo_w = [_cargo_w, _arsenal select 0] call AS_fnc_mergeCargoLists;
    _cargo_m = [_cargo_m, _arsenal select 1] call AS_fnc_mergeCargoLists;
    _cargo_i = [_cargo_i, _arsenal select 2] call AS_fnc_mergeCargoLists;
    _cargo_b = [_cargo_b, _arsenal select 3] call AS_fnc_mergeCargoLists;
    {
      _allMagazineRemains pushback _x; //Get array of partial mags with [type, ammo] to allmagsremains
    } foreach (_arsenal select 4);

  } forEach nearestObjects [_position, ["WeaponHolder"], _size]; // No weaponholder simulated because it's included in vehicles

  {
      if not (alive _x) then {
        private _arsenal = [_x, true] call AS_fnc_getUnitArsenal;
        _cargo_w = [_cargo_w, _arsenal select 0] call AS_fnc_mergeCargoLists;
        _cargo_m = [_cargo_m, _arsenal select 1] call AS_fnc_mergeCargoLists;
        _cargo_i = [_cargo_i, _arsenal select 2] call AS_fnc_mergeCargoLists;
        _cargo_b = [_cargo_b, _arsenal select 3] call AS_fnc_mergeCargoLists;
        {
          _allMagazineRemains pushback _x; //Get array of partial mags with [type, ammo] to allmagsremains
        } foreach (_arsenal select 4);
      };
  } forEach (_position nearObjects ["Man", _size]);
} foreach ("FIA" call AS_location_fnc_S);
[_cargo_w, _cargo_m, _cargo_i, _cargo_b]
};

private _fnc_getMagRemains = {
    params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b"];

    //Create a dummy container, give it all the spares and then get its container as any other vehicles
    //Then delete _dummy
    //TODO: Optimise this

    _dummy = "Box_NATO_AmmoVeh_F" createVehicle [0,0,0]; //This crate should already be empty
    [_dummy, _allMagazineRemains] call AS_fnc_addMagazineRemains;

    private _arsenal = [_dummy, true] call AS_fnc_getBoxArsenal;
    _cargo_w = [_cargo_w, _arsenal select 0] call AS_fnc_mergeCargoLists;
    _cargo_m = [_cargo_m, _arsenal select 1] call AS_fnc_mergeCargoLists;
    _cargo_i = [_cargo_i, _arsenal select 2] call AS_fnc_mergeCargoLists;
    _cargo_b = [_cargo_b, _arsenal select 3] call AS_fnc_mergeCargoLists;

    deleteVehicle _dummy;

    [_cargo_w, _cargo_m, _cargo_i, _cargo_b]
};

_all = _all call _fnc_getUnitsEquipment;
_all = _all call _fnc_getVehiclesEquipment;
_all = _all call _fnc_collectDroppedEquipment;
_all = _all call _fnc_getMagRemains;

[_dict, "weapons", _all select 0] call DICT_fnc_setGlobal;
[_dict, "magazines", _all select 1] call DICT_fnc_setGlobal;
[_dict, "items", _all select 2] call DICT_fnc_setGlobal;
[_dict, "backpacks", _all select 3] call DICT_fnc_setGlobal;

[_dict, "unlockedWeapons", unlockedWeapons] call DICT_fnc_setGlobal;
[_dict, "unlockedMagazines", unlockedMagazines] call DICT_fnc_setGlobal;
[_dict, "unlockedItems", unlockedItems] call DICT_fnc_setGlobal;
[_dict, "unlockedBackpacks", unlockedBackpacks] call DICT_fnc_setGlobal;

_dict
