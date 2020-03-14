params ["_arsenal", "_box", "_unit"];

_arsenal params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b"];

// add allowed stuff.
_box setvariable ["bis_addVirtualWeaponCargo_cargo",nil,true];  // see http://stackoverflow.com/a/43194611/7808917
[_box,(_cargo_w select 0) + unlockedWeapons, true] call BIS_fnc_addVirtualWeaponCargo;
[_box,(_cargo_m select 0) + unlockedMagazines, true] call BIS_fnc_addVirtualMagazineCargo;
[_box,(_cargo_i select 0) + unlockedItems, true] call BIS_fnc_addVirtualItemCargo;
[_box,(_cargo_b select 0) + unlockedBackpacks, true] call BIS_fnc_addVirtualBackpackCargo;

//["Open",[nil,_box,_unit]] call BIS_fnc_arsenal;

["Open", [nil, _box, _unit]] call BIS_fnc_arsenal;


// BIS_fnc_arsenal creates a new action. We remove it so the only arsenal available is this one
waitUntil {!isnil{_box getVariable "bis_fnc_arsenal_action"}};

[_box, "remove"] remoteExec  ["AS_fnc_addAction", [0, -2] select isDedicated];

if (_box == caja) then {

  [_box, "arsenal"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated];
  [_box, "transferFrom"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];
  [_box, "emptyPlayer"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];
  [_box, "moveObject"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];
} else {
  [_box,"heal_camp"] RemoteExec ["AS_fnc_addAction", [0, -2] select isDedicated];
  [_box,"arsenal"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];
  [_box,"transferFrom"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];
};

//Remove and add actions to avoid bug where actual Arsenal action disappears in multiplayer (action index differs between clients?)

// wait for the arsenal to close.
//failsafe
waitUntil {isnull ( uinamespace getvariable "RSCDisplayArsenal") or not(alive _unit)};

if (not(alive _unit)) exitWith {};

[_unit, "check", _box] remoteExec ["AS_fnc_pollServerArsenal", 2];
