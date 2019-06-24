#include "../macros.hpp"
params ["_box", "_unit"];

if (AS_S("lockArsenal")) exitWith {"Another player is using the Arsenal. Wait."};
AS_Sset("lockArsenal", true);

// if the box is not "caja", then transfer everything to caja.
// This guarantees that the player still has access to everything.
if (_box != caja) then {
    [_box, caja] call AS_fnc_transferToBox;
};

// Get all stuff in the unit before going to the arsenal
private _old_cargo = [_unit, true] call AS_fnc_getUnitArsenal;

// specify what is available in the arsenal.
([caja, true] call AS_fnc_getBoxArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b"];

// add allowed stuff.
_box setvariable ["bis_addVirtualWeaponCargo_cargo",nil,true];  // see http://stackoverflow.com/a/43194611/7808917
[_box,(_cargo_w select 0) + unlockedWeapons, true] call BIS_fnc_addVirtualWeaponCargo;
[_box,(_cargo_m select 0) + unlockedMagazines, true] call BIS_fnc_addVirtualMagazineCargo;
[_box,(_cargo_i select 0) + unlockedItems, true] call BIS_fnc_addVirtualItemCargo;
[_box,(_cargo_b select 0) + unlockedBackpacks, true] call BIS_fnc_addVirtualBackpackCargo;

["Open",[nil,_box,_unit]] call BIS_fnc_arsenal;

// wait for the arsenal to close.
waitUntil {isnull ( uinamespace getvariable "RSCDisplayArsenal" )};
// BIS_fnc_arsenal creates a new action. We remove it so the only arsenal available is this one
_box removeAction (_box getVariable "bis_fnc_arsenal_action");

private _new_cargo = [_unit, true] call AS_fnc_getUnitArsenal;

// add all the old stuff and removes all the new stuff.
_cargo_w = [_cargo_w, _old_cargo select 0] call AS_fnc_mergeCargoLists;
_cargo_m = [_cargo_m, _old_cargo select 1] call AS_fnc_mergeCargoLists;
_cargo_i = [_cargo_i, _old_cargo select 2] call AS_fnc_mergeCargoLists;
_cargo_b = [_cargo_b, _old_cargo select 3] call AS_fnc_mergeCargoLists;

[_old_cargo] remoteExec ["AS_fnc_addtoArsenal", 2];

_cargo_w = [_cargo_w, _new_cargo select 0, false] call AS_fnc_mergeCargoLists;
_cargo_m = [_cargo_m, _new_cargo select 1, false] call AS_fnc_mergeCargoLists;
_cargo_i = [_cargo_i, _new_cargo select 2, false] call AS_fnc_mergeCargoLists;
_cargo_b = [_cargo_b, _new_cargo select 3, false] call AS_fnc_mergeCargoLists;

[_new_cargo] remoteExecCall ["AS_fnc_removeFromArsenal", 2];


// remove from unit items that are not available.
for "_i" from 0 to (count (_cargo_b select 0) - 1) do {
	private _name = (_cargo_b select 0) select _i;
	private _amount = (_cargo_b select 1) select _i;
	if (_amount <= 0) then {
		for "_j" from 0 to (-_amount - 1) do {
            _old_cargo = [backpackContainer _unit, false] call AS_fnc_getBoxArsenal;
            _cargo_w = [_cargo_w, _old_cargo select 0] call AS_fnc_mergeCargoLists;
            _cargo_m = [_cargo_m, _old_cargo select 1] call AS_fnc_mergeCargoLists;
            _cargo_i = [_cargo_i, _old_cargo select 2] call AS_fnc_mergeCargoLists;
            _cargo_b = [_cargo_b, _old_cargo select 3] call AS_fnc_mergeCargoLists;

            [_old_cargo] remoteExec ["AS_fnc_addToArsenal", 2];
			removeBackpack _unit;
		};
	};
};

// Remove vests only. This is a container, so it has to be before all other stuff.
for "_i" from 0 to (count (_cargo_i select 0) - 1) do {
	private _name = (_cargo_i select 0) select _i;
	private _amount = (_cargo_i select 1) select _i;
	if (_amount < 0 and (_name in AS_allVests)) exitWith {  // exitWith because unit can only have one vest.
        private _old_cargo = [vestContainer _unit, false] call AS_fnc_getBoxArsenal;
        _cargo_w = [_cargo_w, _old_cargo select 0] call AS_fnc_mergeCargoLists;
        _cargo_m = [_cargo_m, _old_cargo select 1] call AS_fnc_mergeCargoLists;
        _cargo_i = [_cargo_i, _old_cargo select 2] call AS_fnc_mergeCargoLists;
        _cargo_b = [_cargo_b, _old_cargo select 3] call AS_fnc_mergeCargoLists;

        [_old_cargo] remoteExec ["AS_fnc_addToArsenal", 2];
        removeVest _unit;
	};
};

// weapons may contain items and mags, so we need to remove them first
for "_i" from 0 to (count (_cargo_w select 0) - 1) do {
	private _name = (_cargo_w select 0) select _i;
	private _amount = (_cargo_w select 1) select _i;
	if (_amount <= 0) then {
		for "_j" from 0 to (-_amount - 1) do {  // _amount == 0 means this does nothing, which is fine.
            private _items = [];
            if (primaryWeapon _unit == _name) then {
                _items = primaryWeaponItems _unit;
                _items = _items + primaryWeaponMagazine _unit;
            };
            if (secondaryWeapon _unit == _name) then {
                _items = secondaryWeaponItems _unit;
                _items = _items + secondaryWeaponMagazine _unit;
            };
            if (handgunWeapon _unit == _name) then {
                _items = handgunItems _unit;
                _items = _items + handgunMagazine _unit;
            };
            // store the current mag
            _cargo_i = [_items, _cargo_i] call AS_fnc_listToCargoList;

            [[[],[]],[[],[]],_cargo_i,[[],[]]] remoteExec ["AS_fnc_addToArsenal", 2];
			_unit removeWeaponGlobal _name;
		};
	};
};
private _magRemoved = 0;
for "_i" from 0 to (count (_cargo_m select 0) - 1) do {
	private _name = (_cargo_m select 0) select _i;
	private _amount = (_cargo_m select 1) select _i;
	if (_amount <= 0) then {
    private _loaded = false;
		for "_j" from 0 to (-_amount - 1) do {

      //Remove loaded mags first
      _loaded = false;
      {
          if (_x select 2 and {(_x select 1 > 0)}) exitWith { //added condition to not empty the same mag all over again
            switch (_x select 3) do {
              case 1 : {_unit setammo [primaryWeapon _unit, 0]};
              case 2 : {_unit setammo [handgunWeapon _unit, 0]};
              case 4 : {_unit setammo [secondaryWeapon _unit, 0]};
            };
            _loaded = true;
            _magRemoved = _magRemoved + 1;
          };


      }
      foreach magazinesAmmoFull _unit;

      if (!(_loaded)) then {
        _unit removeMagazine _name;
        _magRemoved = _magRemoved + 1;
      };
		};
	};
};

if (_magRemoved > 0) then {
  private _text = format ["%1 Magazines removed", _magRemoved];
  [petros, "hint", _text, 2] spawn AS_fnc_localCommunication;

};

for "_i" from 0 to (count (_cargo_i select 0) - 1) do {
	private _name = (_cargo_i select 0) select _i;
	private _amount = (_cargo_i select 1) select _i;
    if (_amount <= 0 and !(_name in AS_allVests)) then {
        call {
            if (_amount < 0 and (_name in AS_allHelmets)) exitWith {  // no need to remove the item from the player, so exitWith
                removeHeadgear _unit;
            };
            // todo: if in AS_allGoogles, exitWith removeGoogles
            if (_amount < 0 and (_name in (AS_allNVGs + AS_allBinoculars))) then {
                _unit unassignItem _name;
            };
            if (_amount < 0) then {
                for "_j" from 0 to (-_amount - 1) do {
                    _unit removeItem _name;
                };
            };
        };
    };
};



AS_Sset("lockArsenal", false);
