#include "../macros.hpp"
AS_SERVER_ONLY("AS_fnc_changeWeather.sqf");

params [["_skipping", false]];

private _clear = AS_P("clear");

if (isNil "_clear") exitWith {

  AS_Pset("clear",false);
  [] spawn AS_weather_fnc_randomWeather; //Randomise once for legacy saves
  diag_log format ["AS_changeWeather, time: %1 Weather param 'clear' not found, executing AS_weather_fnc_randomWeather", time];

};

if (_clear) exitWith {}; //Weather set for clear, no need for manipulation. Use this to check for legacy saves

//current values


private _overcast = AS_P("overcast");
private _rain = AS_P("rain");
private _windDir = AS_P("windDir");
private _windSpeed = AS_P("windSpeed");
private _gusts = AS_P("gusts");
private _lightnings = AS_P("lightnings");
private _waves = AS_P("waves");
private _fog = AS_P("fog");

diag_log format ["AS_weather: Previous, time: %1 /nOvercast %2/nRain %3/nWindDir %4/nWindSpeed %9/nGusts %5/nLightnings %6/nWaves %7/nFog %8", time, _overcast, _rain, _windDir, _gusts, _lightnings, _waves, _fog, _windSpeed];

// Change overcast TODO: tweak this

_overcast = (-0.2 + (random 0.35) + (_overcast*(random 2)) min 1) max 0;

if (_overcast >= 0.7) then {
  _rain = ((_rain - 0.2 + _overcast * (random 1)^2) min 1) max 0;
  if (random 10 < 5) then {
    _overcast = _overcast - 0.1;
  };
} else {
  _rain = 0;
};

// Wind change

private _maxWind = 10 - (_overcast * 7) + (_rain * 15);
private _dirChange = _maxWind * 18;
_windDir = round (_windDir - _dirChange/2 + (random _dirChange));
if (_windDir < 0) then {_windDir =  _windDir + 360};
if (_windDir > 360) then {_windDir = _windDir - 360};

private _windChange = -1.5 + (_maxWind/2)*(random 1)^3;
_windspeed = ((_windspeed + _windChange) max 0) min _maxWind;

private _windX = (cos _windDir) * _windSpeed;
private _windY = (sin _windDir) * _windSpeed;

//Thus the final wind vector

private _wind = [_windX, _windY, true];

//Gusts are allways random independent of previous values

_gusts = ((_windSpeed/18) min 1)*(random 1)^2;

// lightnings

_lightnings = 0;

if (_rain >= 0.3 and {random 10 < _overcast*4 + _rain*4 + _windSpeed/18}) then {

  _lightnings = 0.50*_overcast+0.50*_rain;

};

//waves

_waves = 0;

if (_windSpeed > 3) then {

  _waves = ((_windspeed/18)*(random 1)^2) min 1;

};

//Set fog

//At dawn more chance for fog

if (sunOrMoon == 0) then { //Previously: daytime > 4 && daytime < 10

  if (random 10 < (2+_overcast*4)) then {
    _fog = ((_fog + (random 0.4) - 0.1) max 0) min 1;
  } else {
    _fog = ((_fog - (random 0.1)) max 0) min 1;
  };
} else {

  if (random 10 < (1 +_overcast)) then {
    _fog = ((_fog + (random 0.4) - 0.1) max 0) min 1;
  } else {
    _fog = ((_fog - (random 0.2)) max 0) min 1;
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

diag_log format ["AS_weather: Set, time: %1 /nOvercast %2/nRain %3/nWindDir %4/nWindSpeed %9/nGusts %5/nLightnings %6/nWaves %7/nFog %8", time, _overcast, _rain, _windDir, _gusts, _lightnings, _waves, _fog, _windSpeed];

//If skipping time, calculate weather but don't execute
if (_skipping) exitWith {};

//[_overcast] call Bis_fnc_setOvercast; //This func uses instant change, avoid

[60, _overcast] remoteExec ["setOvercast",0];
sleep 60;
[60, _rain] remoteExec ["setRain",0];
sleep 60;
setWind _wind;
[60, _gusts] remoteExec ["setGusts", 0];
sleep 60;
[60, _lightnings] remoteExec ["setLightnings", 0];
sleep 60;
[60, _waves] remoteExec ["setWaves", 0];
sleep 60;
60 setFog [_fog, 0.05, 0];
