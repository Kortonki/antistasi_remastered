#include "../macros.hpp"
AS_SERVER_ONLY("AS_database_fnc_persistents_fromDict");

params ["_dict"];
{
    private _value = [_dict, _x] call DICT_fnc_get;
    call {
        if (_x == "vehicles") exitWith {
            private _vehicles = [];
            {
                _x params ["_type", "_pos", "_dir", "_fuel", "_fuelCargo", "_damage"];

                private _vehicle = createVehicle [_type, _pos, [], 0, "CAN_COLLIDE"];
                _vehicle allowDamage false;
                _vehicle enableSimulationGlobal false;
                _vehicle setDir _dir;

                //Combatibility for legacy stuff
                if (isnil "_damage") then {
                  _vehicle setdamage 0;
                } else {
                  _vehicle setdamage _damage;
                };
                if (isNil "_fuelCargo") then {
                  _fuelCargo = 0;
                };
                if (isNil "_fuel") then {
                  _fuel = 0.5;
                };

                //Wait to initialise sides before initing vehicles
                [_vehicle, _fuel, _fuelCargo] spawn {
                  params ["_vehicle", "_fuel", "_fuelCargo"];
                  waitUntil {sleep 0.1; not isNil "AS_dataInitialized"};
                  [_vehicle, "FIA", _fuel, _fuelCargo] call AS_fnc_initVehicle;
                  //After init, enable simulation
                  sleep 1;
                  _vehicle enableSimulationGlobal true;
                  _vehicle allowDamage true;
              };
                _vehicles pushBack _vehicle;
            } forEach _value;
            AS_Pset(_x, _vehicles);
        };
        if (_x == "date") exitWith {
            setDate _value;
        };
        if (_x == "BE_module") exitWith {
             [_value] call fnc_BE_load;
        };
        if (_x == "fuelFIA") then {
          if (isNil "_value") then {
            //Fuel for legacy saves
            _value = [_dict, "fuelReservesFIA"] call DICT_fnc_get;
            };
          };
		if (_x == "ammoFIA") then {
         if (isNil "_value") then {
           //Fuel for legacy saves
           _value = [_dict, "ammoReservesFIA"] call DICT_fnc_get;
           };
          };
        AS_Pset(_x, _value);
    };
} forEach AS_database_persistents;

//Legacy stuff

if (isNil {AS_P("knownLocations")}) then {AS_Pset("knownLocations",[])};

if (isNil {AS_P("upFreq")}) then {AS_Pset("upFreq", paramsArray select 4)}; //Loading legacy save picks up game speed from parameters
if (isNil {AS_P("nextUpdate")}) then {
  private _nextUpdate = [date select 0, date select 1, date select 2, date select 3, (date select 4) + (AS_P("upFreq")/60)];
  _nextUpdate = datetoNumber _nextUpdate;
  AS_Pset("nextUpdate", _nextUpdate);
};

if (isNil {AS_P("nextAttack")}) then {
  private _upFreq = AS_P("upFreq");
  private _nextAttack = [date select 0, date select 1, date select 2, date select 3, (date select 4) + ((AS_P("secondsForAAFAttack"))/60)];
  AS_Pset("secondsForAAFattack",(2*_upFreq));
  _nextAttack = datetoNumber _nextAttack;
  AS_Pset("nextAttack", _nextAttack);
};


//Apply weather changes immediately if there is atan2
private _clear = AS_P("clear");
if (!(isNil "_clear")) then {

  private _overcast = AS_P("overcast");
  private _rain = AS_P("rain");
  private _windDir = AS_P("windDir");
  private _windSpeed = AS_P("windSpeed");
  private _gusts = AS_P("gusts");
  private _lightnings = AS_P("lightnings");
  private _waves = AS_P("waves");
  private _fog = AS_P("fog");

  //Wind parameters

  private _windX = (cos _windDir) * _windSpeed;
  private _windY = (sin _windDir) * _windSpeed;

  //Thus the final wind vector

  private _wind = [_windX, _windY, true];

  [60, _overcast] remoteExec ["setOvercast",0];
  [60, _rain] remoteExec ["setRain",0];
  setWind _wind;
  [60, _gusts] remoteExec ["setGusts", 0];
  [60, _lightnings] remoteExec ["setLightnings", 0];
  [60, _waves] remoteExec ["setWaves", 0];
  60 setFog [_fog, 0.05, 0];

  //Here we don't need gradual change and stutter won't matter

  forceWeatherChange;

};
