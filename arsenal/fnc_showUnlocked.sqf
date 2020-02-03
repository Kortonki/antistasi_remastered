#include "../macros.hpp"
params ["_container", "_unit"];

//Run where unit is local
if (!local _unit) exitWith {[_container, _unit] remoteExec ["AS_fnc_showUnlocked", _unit]};

waitUntil {not(AS_S("lockArsenal"))}; //Don't fiddle while arsenal is accessed

//Check whether unlockeds are already accessible vi ainventory

([_container, false] call AS_fnc_getBoxArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b"];

//if found, add as many as needed to reach the target
//They're local as it's just for convenience if arsenal is used by someone else

{
  private _index = (_cargo_w select 0) find _x;
  if (_index != -1) then {
    _container addWeaponCargoGlobal [_x, (1-((_cargo_w select 1) select _index)) max 0];
  } else {
    _container addWeaponCargoGlobal [_x, 1];
  };


} foreach unlockedWeapons;

{
  private _index = (_cargo_m select 0) find _x;
  if (_index != -1) then {
    _container addMagazineCargoGlobal [_x, (30-((_cargo_m select 1) select _index)) max 0];
  } else {
    _container addMagazineCargoGlobal [_x, 30];
  };

} foreach unlockedMagazines;

{
  private _index = (_cargo_i select 0) find _x;

  private _amount = 1;
  if (_x == "FirstAidKit" or (hasAceMedical and {_x in AS_aceBasicMedical or _x in AS_aceAdvMedical})) then {
  _amount = 20;
  };
    if (_index != -1) then {
      _container addItemCargoGlobal [_x, (_amount-((_cargo_i select 1) select _index)) max 0];
      }  else {
    _container addItemCargoGlobal [_x, _amount];
  };


} foreach unlockedItems;


{
  private _index = (_cargo_b select 0) find _x;
  if (_index != -1) then {
    _container addBackpackCargoGlobal [_x, (1-((_cargo_b select 1) select _index)) max 0];
  }  else {
    _container addBackpackCargoGlobal [_x, 1];
  };

} foreach unlockedBackpacks;
