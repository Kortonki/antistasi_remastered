#include "../macros.hpp"
AS_SERVER_ONLY("AS_fnc_pollServerArsenal.sqf");

params ["_unit", "_phase", "_box", ["_mineTypes", "at_mines"]];

private _owner = owner _unit;

if (_phase == "open") exitWith {

  if lockArsenal then {
    ["Arsenal is busy, wait"] remoteExec ["hint", _unit];
  };

  private _time = time + 20;
  waitUntil {!lockArsenal or time > _time};

  if (time > _time) exitWith {
    ["Arsenal is very busy or server overloaded. Arsenal request timed out. \n\nTry again or ask admin to fix arsenal by typing lockArsenal = false to console and run it for server. Be careful with this, there's a possibility to lose a lot of gear if it's done while AI is taking stuff from arsenal (Garrisons, unit recruits)"] remoteExec ["hint", _unit];
    _unit setVariable ["arsenalPoll", nil, owner _unit];
  };

  //Do not open if player has left
  if (_unit distance _box > 10 or not(alive _unit)) exitWith {_unit setVariable ["arsenalPoll", nil, owner _unit];};

  private _arsenalOpen = +(call AS_fnc_getArsenal); //Copied not referenced to avoid unforeseen consequences with arrays as this copy is fiddled
  {
    private _names = _x select 0;
    private _counts = _x select 1;
    /*
    _names = _names select {_counts select (_names find _x) > 0};
    _counts = _counts select {_x > 0};*/
    private _index = _counts find 0;
    while {_index != -1} do {
      _names deleteAt _index;
      _counts deleteAt _index;
      _index = _counts find 0;
    };

    //{
    // if ((_type select 1) select _foreachIndex <= 0) then {(_type select 0) = (_type select 0) - [_x]}; //Delete non-existants from the list.
    // } foreach (_type select 0);
    _x deleteAt 1; //Amount are not needed for arsenal operation
  } foreach _arsenalOpen;
  [_arsenalOpen, _box, _unit] remoteExecCall ["AS_fnc_openArsenal", _owner, false];

};

if (_phase == "check") exitWith {
  //Arsenal is locked during the time player gear is checked and removed from ARSENAL
  waitUntil {isNil "AS_savingServer" and {!(lockArsenal)}};
  lockArsenal = true;
  private _arsenalCheck = +(call AS_fnc_getArsenal);
  //Changed to call to prevent player side slow processing to keep arsenal locked
  [_arsenalCheck, _unit] remoteExecCall ["AS_fnc_checkArsenal", _owner, false];
};

if (_phase == "inventory") exitWith {

  private _arsenalInventory = +(call AS_fnc_getArsenal);
  [_box, _unit, nil, _arsenalInventory, true] remoteExec ["AS_actions_fnc_vehicle_cargo_check", _owner, false];
};

if (_phase == "minefield") exitWith {
  private _magazines = +((call AS_fnc_getArsenal) select 1);
  [_mineTypes, _magazines] remoteExec ["AS_fnc_deployFIAminefield", _owner, false];
};

diag_log format ["[AS] error: AS_fnc_pollServerArsenal called with invalid phase: %1", _phase];
