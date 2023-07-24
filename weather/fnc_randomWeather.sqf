/*This sets the initial weather after resting in fireplace or starting a new inGameUISetEventHandler
this Shuold only lrun on server and brocadcast local values to clients


*/
params [["_skipTime", 0]];

if (!(isNil "ace_weather_enabled") and {ace_weather_enabled}) exitWith{}; //ACE weather

#include "../macros.hpp"
AS_SERVER_ONLY("AS_fnc_randomWeather.sqf");

// Overcast calcs

private _overcast = (random 1)^2;

private _rain = 0;

if (_overcast >= 0.7) then {
  _rain = _overcast * (random 1)^2;
} else {
  _rain = 0;
};

//Wind calcs

private _maxWind = 10 - (_overcast * 7) + (_rain * 15); //maximum wind component, 18 m/s, depends on Overcast and rain
private _windDir = round (random 360);
private _windSpeed = _maxWind * (random 1)^4;
private _windX = (cos _windDir) * _windSpeed;
private _windY = (sin _windDir) * _windSpeed;

//Thus the final wind vector

private _wind = [_windX, _windY, true];

private _gusts = ((_windSpeed/18) min 1)*(random 1)^2;

// lightnings

private _lightnings = 0;

if (_rain >= 0.3 and {random 10 < _overcast*4 + _rain*4 + _windSpeed/18}) then {

_lightnings = 0.50*_overcast+0.50*_rain;

};

//waves

private _waves = 0;

if (_windSpeed > 3) then {

_waves = ((_windspeed/18)*(random 1)^2) min 1;

};

//Set fog

private _fog = 0;

//This is for calculating upcoming weather when skipping time

private _daytime = daytime + _skipTime;
if(_daytime > 24) then {_daytime = _daytime - 24};

//At dawn more chance for fog

if (sunOrMoon == 0) then { //Previously (_daytime > 4 && _daytime < 10)

  if (random 10 < (2+_overcast*4)) then {
  _fog = ((1-(_windSpeed/18)) max 0) * (random 1)^2;
  };
} else {

  if (random 10 < (1 +_overcast)) then {
  _fog = ((1-(_windSpeed/18)) max 0) * (random 1)^2;
  };
};

//Set as persistent Variables

AS_Pset("overcast",_overcast);
AS_Pset("rain",_rain);
AS_Pset("windDir",_windDir);
AS_Pset("windSpeed",_windSpeed);
AS_Pset("gusts",_gusts);
AS_Pset("lightnings",_lightnings);
AS_Pset("waves",_waves);
AS_Pset("fog",_fog);


//Set everything

[_overcast] call bis_fnc_setOvercast;
[10, _rain] remoteExec ["setRain",0];
sleep 10;
setWind _wind;
[10, _gusts] remoteExec ["setGusts", 0];
sleep 10;
[10, _lightnings] remoteExec ["setLightnings", 0];
sleep 10;
[10, _waves] remoteExec ["setWaves", 0];
sleep 10;
10 setFog [_fog, 0.05, 0];
forceWeatherChange;
