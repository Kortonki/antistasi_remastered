#include "../macros.hpp"
AS_SERVER_ONLY("AS_fnc_pollServerArsenal.sqf");

params ["_unit", "_phase", "_box"];

private _owner = owner _unit;

if (_phase == "open") then {

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
    //{
    // if ((_type select 1) select _foreachIndex <= 0) then {(_type select 0) = (_type select 0) - [_x]}; //Delete non-existants from the list.
    // } foreach (_type select 0);
    _x deleteAt 1; //Amount are not needed for arsenal operation
  } foreach _arsenalOpen;
  [_arsenalOpen, _box, _unit] remoteExecCall ["AS_fnc_openArsenal", _owner, false];

} else {
  //Arsenal is locked during the time player gear is checked and removed from ARSENAL
  waitUntil {isNil "AS_savingServer" and {!(lockArsenal)}};
  lockArsenal = true;
  private _arsenalCheck = call AS_fnc_getArsenal;
  //Changed to call to prevent player side slow processing to keep arsenal locked
  [_arsenalCheck, _unit] remoteExecCall ["AS_fnc_checkArsenal", _owner, false];
};
