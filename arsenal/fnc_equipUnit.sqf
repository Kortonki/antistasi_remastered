#include "../macros.hpp"
params ["_unit", "_arsenal"];

_unit call AS_fnc_emptyUnit;
_unit call AS_fnc_equipDefault;

_unit forceAddUniform (selectRandom (["FIA", "uniforms"] call AS_fnc_getEntity));

_arsenal params ["_vest", "_helmet", "_googles", "_backpack",
    "_primaryWeapon", "_primaryMags", "_secondaryWeapon",
    "_secondaryMags", "_scope", "_items", "_primaryWeaponItems", "_binoculars"
];

private _fnc_equipUnit = {
    params ["_weapon", "_mags"];
    if (_weapon != "") then {
        //[_unit, _weapon, 0, 0] call BIS_fnc_addWeapon; //does not add weapon when run on client

        for "_i" from 0 to (count (_mags select 0) - 1) do {
            private _name = (_mags select 0) select _i;
            private _amount = (_mags select 1) select _i;
            _unit addMagazines [_name, _amount];
        };
        _unit addWeapon _weapon;
    };
};

if (_vest != "") then {
    _unit addVest _vest;
};

if (_helmet != "") then {
    _unit addHeadgear _helmet;
};

if (_googles != "") then {
    _unit linkItem _googles;
};

if (_backpack != "") then {
    _unit addBackpackGlobal _backpack;
};

[_primaryWeapon, _primaryMags] call _fnc_equipUnit;
[_secondaryWeapon, _secondaryMags] call _fnc_equipUnit;

// add items
private _i = 0;
while {_i < count _items} do {
    private _item = (_items select _i) select 0;
    private _amount = (_items select _i) select 1;

    private _j = 0;
    while {_j < _amount} do {
        if (_unit canAdd _item) then {
            _unit addItem _item;
        };
        _j = _j + 1;
    };
    _i = _i + 1;
};

if (_scope != "") then {
    _unit addPrimaryWeaponItem _scope;
};

if (_binoculars != "") then {
    _unit addWeapon _binoculars;
};

{
    _unit addPrimaryWeaponItem _x;
} forEach _primaryWeaponItems;

//All arsenal removal and adding happens on server: EXPERIMENT
// remove from box stuff that was used.
//Added check if player is using the Arsenal (probably unnecessary, arsenal fiddling is done all in server)

private _cargo = [_unit, true] call AS_fnc_getUnitArsenal;

waitUntil {sleep 0.1; isNil "AS_savingServer" and {!(AS_S("lockArsenal"))}};

[_cargo] remoteExecCall ["AS_fnc_removeFromArsenal", 2];



_unit selectWeapon (primaryWeapon _unit);
