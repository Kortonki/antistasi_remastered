#include "macros.hpp"

[["You decided to rest some time","BLACK OUT",5]] remoteExec ["cutText", [0,-2] select isDedicated];
[[], {player enableSimulation false}] remoteExec ["call", [0,-2] select isDedicated]; //Careful with this shit
sleep 5;
//TODO: A dialog to choose how long to skip?
private _skiptimeMax = 1*60;
private _skippedTime = 0;
private _attack = false;
private _text = "Time to go";
//AS_weather_fnc_randomWeather", 2];

//Fail all current convoy missions
{
	private _mission = _x;

	private _location = _mission call AS_mission_fnc_location;
	private _position = _location call AS_location_fnc_position;

	//FAIL the mission naturally to avoid problems. Teleport mainvehicle to target

	[_mission, _position] spawn {
		params ["_mission", "_position"];
		waitUntil {sleep 0.5; ([_mission, "state_index"] call AS_spawn_fnc_get) == 2};
		private _mainVehicle = [_mission, "mainVehicle"] call AS_spawn_fnc_get;
		_mainVehicle setVehiclePosition [_position, [], 0, "NONE"];
		_mainVehicle forcespeed 0;
	};

} foreach ((call AS_mission_fnc_active_missions) select {"convoy" in _x});

//Shut down resources and spawn loops first:

[false] call AS_spawn_fnc_toggle;
[false] call AS_fnc_resourcesToggle;

//Cancel all active missions (immersion etc.)
//TODO exploit for not failing convoy missions or others?
//FAILing them might not work, some fail functions need mission specific params
//-> FAIL all convoy missions
//Consider failing/canceling

//Wait for a good measure
sleep (2*AS_spawnLoopTime);

while {!(_attack) and {_skippedTime < _skipTimeMax}} do {

  while {private _date = dateToNumber date; !(_skippedTime >= _skipTimeMax or _date >= AS_P("nextUpdate") or _date >= AS_P("nextAttack"))} do {
    skiptime (1/60); //Skip one minute at a time
    _skippedTime = _skippedTime + 1;
  };

  if ((dateTonumber date) >= AS_P("nextAttack")) then {
      _attack = [true] call AS_movement_fnc_sendAAFattack;
  };

  if ((dateToNumber date) >= AS_P("nextUpdate")) then {
      [true] call AS_fnc_resourcesUpdate;
  };
};

//Switch everything back on:

[[], {player enableSimulation true}] remoteExec ["call", [0,-2] select isDedicated];

[true] call AS_spawn_fnc_toggle;
[true] call AS_fnc_resourcesToggle;

//One more weather change without skipping argumet to execute:

[] spawn AS_weather_fnc_changeWeather;

if (_attack) then {_text = "Alarm!"};

[[_text, "BLACK IN", 5]] remoteExec ["cutText", [0,-2] select isDedicated];
