#include "macros.hpp"

["You decided to rest some time","BLACK",10] remoteExec ["cutText", [0,-2] select isDedicated];
sleep 10;
//TODO: A dialog to choose how long to skip?
private _skiptimeMax = 8*60;
private _skippedTime = 0;
private _attack = false;
private _text = "Time to go";
//AS_weather_fnc_randomWeather", 2];

//Shut down resources and spawn loops first:

[false] call AS_spawn_fnc_toggle;
[false] call AS_fnc_resourcesToggle;

//Wait for a good measure
sleep (2*AS_spawnLoopTime);

while {!(_attack) and {_skippedTime < _skipTimeMax}} do {

  while {private _date = dateToNumber date; !(_skippedTime > _skipTimeMax or _date > AS_P("nextUpdate") or _date > AS_P("nextAttack"))} do {
    skiptime (1/60); //Skip one minute at a time
    _skippedTime = _skippedTime + 1;
  };

  if ((dateTonumber date) > AS_P("nextAttack")) then {
      _attack = [true] call AS_movement_fnc_sendAAFattack;
  };

  if ((dateToNumber date) > AS_P("nextUpdate")) then {
      [true] call AS_fnc_resourcesUpdate;
  };
};

//Switch everything back on:

[true] call AS_spawn_fnc_toggle;
[true] call AS_fnc_resourcesToggle;

//One more weather change without skipping argumet to execute:

[] spawn AS_weather_fnc_changeWeather;

if (_attack) then {_text = "Alarm!"};

sleep 10;
[_text, "BLACK IN", 10] remoteExec ["cutText", [0,-2] select isDedicated];
