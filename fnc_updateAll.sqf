#include "macros.hpp"
AS_SERVER_ONLY("fnc_updateAll.sqf");

params [["_skipping", false]];

private _AAFnewMoney = 0;
private _FIAnewMoney = 50;
private _FIAnewHR = 0;
private _FIAnewFuel = 0;

private _FIAtotalPop = 0;
private _AAFtotalPop = 0;
private _AAFResIncomeMultiplier = 1;
private _FIAResIncomeMultiplier = 1;

// forEach city, add to HR and money
{
    private _city = _x;
    private _side = _city call AS_location_fnc_side;
    private _size = _city call AS_location_fnc_size;
    private _position = _city call AS_location_fnc_position;
    private _population = [_x, "population"] call AS_location_fnc_get;
    private _AAFsupport = [_x, "AAFsupport"] call AS_location_fnc_get;
    private _FIAsupport = [_x, "FIAsupport"] call AS_location_fnc_get;
    private _power = [_city] call AS_fnc_location_isPowered;

    //EACH tick check if enemy side has any troops in the area -> lower support depending on amount
    //The fear element of gaining city support, in addition to providing supplies
    //Big bicture: killing can only lower support, sending supplies and propaganda can also increase
    //TODO: Make an assumption that if city is spawned, so is a possible nearby location thus their spawns have presence normally
    //Nearby enemy locs to affect support

    if (_city call AS_location_fnc_spawned) then {
      if (_side == "AAF") then {
          private _enemyUnits = {_x call AS_fnc_getSide in ["NATO", "FIA"] and {_x call AS_fnc_canFight and {!(captive _x) and {_x distance2D _position <= _size}}}} count allUnits;

          if (_enemyUnits > 0) then {
            [-_enemyUnits, 0, _city] call AS_fnc_changeCitySupport;
            [[_city], "AS_movement_fnc_sendAAFpatrol"] call AS_scheduler_fnc_execute;

            private _text = format [localize "STR_msg_AAFcity_FIApresence",
            _city,
            ["FIA", "shortname"] call AS_fnc_getEntity,
            ["AAF", "shortname"] call AS_fnc_getEntity
            ];

            [_text, 15, "AAFcity_FIApresence", false] spawn AS_fnc_globalMessage;
          };
      };

      if (_side == "FIA") then {
        private _enemyUnits = {_x call AS_fnc_getSide in ["AAF", "CSAT"] and {_x call AS_fnc_canFight and {_x distance2D _position <= _size}}} count allUnits;

        if (_enemyUnits > 0) then {
          [0, -_enemyUnits, _city, true] call AS_fnc_changeCitySupport;

          private _text = format [localize "STR_msg_FIAcity_AAFpresence",
          _city,
          ["AAF", "shortname"] call AS_fnc_getEntity
          ];

          [_text, 5, "FIAcity_AAFpresence", false] spawn AS_fnc_globalMessage;
        };
      };
    } else {
      if (_side == "AAF") then {
        //Check if city is inside a location, that counts as presence too. -> Nearby non spawned cities and other locations soon turn into near occupiers side
        private _nearestLoc = ["FIA" call AS_location_fnc_S, _position] call BIS_fnc_nearestPosition;
        if ((_nearestLoc call AS_location_fnc_position) distance2D _position <= (_nearestLoc call AS_location_fnc_size)) then {
          private _enemyUnits = (count (_nearestLoc call AS_location_fnc_garrison));

          if (_enemyUnits > 0) then {
            [-_enemyUnits, 0, _city] call AS_fnc_changeCitySupport;
            [[_city], "AS_movement_fnc_sendAAFpatrol"] call AS_scheduler_fnc_execute;

            private _text = format [localize "STR_msg_AAFcity_FIApresence",
            _city,
            ["FIA", "shortname"] call AS_fnc_getEntity,
            ["AAF", "shortname"] call AS_fnc_getEntity
            ];

            [_text, 15, "AAFcity_FIApresence", false] spawn AS_fnc_globalMessage;
          };
        };
      };

      if (_side == "FIA") then {
        //Check if city is inside a location, that counts as presence too. -> Nearby non spawned cities and other locations soon turn into near occupiers side
        private _nearestLoc = [["AAF", "CSAT"] call AS_location_fnc_S, _position] call BIS_fnc_nearestPosition;
        if ((_nearestLoc call AS_location_fnc_position) distance2D _position <= (_nearestLoc call AS_location_fnc_size)) then {
          private _enemyUnits = round((_nearestLoc call AS_location_fnc_size)/7.5); //This is an approximation
          [0, -_enemyUnits, _city, true] call AS_fnc_changeCitySupport;

          private _text = format [localize "STR_msg_FIAcity_AAFpresence",
          _city,
          ["AAF", "shortname"] call AS_fnc_getEntity
          ];

          [_text, 5, "FIAcity_AAFpresence", false] spawn AS_fnc_globalMessage;
        };
      };
    };

    // flip cities due to majority change. THIS MOVED BEFORE CALCULATING INCOME
    if ((_AAFsupport < _FIAsupport) and {_side == "AAF"}) then {
        //For now use the location as string. getlocationName returns empty string
        ["TaskSucceeded", ["", format ["%1 joined FIA",_city]]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];

        [_city, "side", "FIA"] call AS_location_fnc_set;
        _city call AS_location_fnc_updateMarker;

        ["con_cit"] call fnc_BE_XP;

        [0,5] call AS_fnc_changeForeignSupport;
        [_city, !_power] spawn AS_fnc_changeStreetLights;
    };
    if ((_AAFsupport > _FIAsupport) and {_side == "FIA"}) then {
        ["TaskFailed", ["", format ["%1 joined %2", _city, ["AAF", "shortname"] call AS_fnc_getEntity ]]] remoteExec ["BIS_fnc_showNotification", AS_CLIENTS];

        [_city, "side", "AAF"] call AS_location_fnc_set;
        _city call AS_location_fnc_updateMarker;

        [0,-5] call AS_fnc_changeForeignSupport;
        [_city, !_power] spawn AS_fnc_changeStreetLights;

        //Release garrison if spawned, otherwise refund garrison
        //Changed to check location spawned instead of if spawn exist. Reason: Spawn exists for some time after deletion even though things are deleted
        //spawned parameter is changed to false when despawning process starts
        if (_city call AS_location_fnc_spawned) then {
          _city call AS_fnc_garrisonRelease;
        } else {
          [_city, "garrison", []] call AS_location_fnc_set;
          private _garHR = 0;
          private _garMoney = 0;
          {
            _garHR = _garHR + 1;
            _garMoney = _garMoney + (_x call AS_fnc_getCost);
          } foreach ([_city, "garrison"] call AS_location_fnc_get);
          [_garHr, _garMoney] spawn AS_fnc_changeFIAmoney; //Spawned so the lock won't slow down actual update
        };

        //Small chance for a traitor mission depending on natoSupport

        if ((AS_P("NATOsupport") + 50) < random 100) then {

          //If city is spawned, do not spawn mission there. random new location
          if (_city call AS_location_fnc_spawned) then {
            private _maxdist = 2500;
            private _cities = (["city"] call AS_location_fnc_T);
            while {private _distance = (_city call AS_location_fnc_position) distance2D ("fia_hq" call AS_location_fnc_position);
                  _distance > _maxdist or _distance < AS_P("spawnDistance") or _city call AS_location_fnc_spawned} do {
            _cities = _cities - [_city];
            if (count _cities == 0) exitWith {_city == ""};
            _city = selectRandom _cities;
            _maxdist = _maxdist + 500;
            sleep 1;
            };
          };
          if (_city == "") exitWith {diag_log "[AS] updateAll: No traitor mission possible, no valid cities"};
          private _mission = ["kill_traitor", _city] call AS_mission_fnc_add;
          _mission call AS_mission_fnc_activate;
        };
    };

    private _incomeAAF = 0;
    private _incomeFIA = 0;
    private _HRincomeFIA = 0;

    //Check sides again, might have flipped

    _side = _city call AS_location_fnc_side;

    private _popFIA = (_population * (_FIAsupport / 100));
    private _popAAF = (_population * (_AAFsupport / 100));
    _FIAtotalPop = _FIAtotalPop + _popFIA;
    _AAFtotalPop = _AAFtotalPop + _popAAF;

    if !(_city in AS_P("destroyedLocations")) then {
        private _incomeMultiplier = 0.33;
        if (not _power) then {_incomeMultiplier = 0.5*_incomeMultiplier};

        _incomeAAF = _incomeMultiplier*_popAAF;
        _incomeFIA = _incomeMultiplier*_popFIA;
        _HRincomeFIA = (_population * (_FIAsupport / 10000));

        if (_side == "FIA") then {
            _incomeAAF = _incomeAAF/2;
            if _power then {
                if (_FIAsupport + _AAFsupport + 1 <= 100) then {[0,1,_city] call AS_fnc_changeCitySupport};
            }
            //This edited so no longer city support loss without power (game balance)
            /*else {
                if (_FIAsupport > 6) then {
                    [0,-1,_city] call AS_fnc_changeCitySupport;
                } else {
                    [1,0,_city] call AS_fnc_changeCitySupport;
                };
            };*/
        } else {
            _incomeFIA = (_incomeFIA/2);
            _HRincomeFIA = (_HRincomeFIA/2);
            if _power then {
                if (_AAFsupport + _FIAsupport + 1 <= 100) then {[1,0,_city] call AS_fnc_changeCitySupport};
            }
            /*else {
                if (_AAFsupport > 6) then {
                    [-1,0,_city] call AS_fnc_changeCitySupport;
                } else {
                    [0,1,_city] call AS_fnc_changeCitySupport;
                };
            };*/
        };
    };

    _AAFnewMoney = _AAFnewMoney + _incomeAAF;
    _FIAnewMoney = _FIAnewMoney + _incomeFIA;
    _FIAnewHR = _FIAnewHR + _HRincomeFIA;

} forEach call AS_location_fnc_cities;



//WIN CONDITION
// control the airport and have majority => win game.
//Edited: must have twice as much influence as AAF:: 66% against 33%
//TODO: consider having a world spesific win locations instead of the airfield
//TODO: Not end the mission here straight, but make AAF offer peace treaty
//If player declines, able to conquer rest of the island, but with a loss of NATO support
if ((_FIAtotalPop > (2 * _AAFtotalPop)) and ("AS_airfield" call AS_location_fnc_side == "FIA")) exitWith {
    "end1" call BIS_fnc_endMissionServer;
};

//TODO: END Game when too much civ casualties?

// forEach factory, add to multiplier
{
    private _side = _x call AS_location_fnc_side;
    private _power = [_x] call AS_fnc_location_isPowered;
    if ((_power) and (not(_x in AS_P("destroyedLocations")))) then {
        if (_side == "FIA") then {_FIAResIncomeMultiplier = _FIAResIncomeMultiplier + 0.25};
        if (_side == "AAF") then {_AAFResIncomeMultiplier = _AAFResIncomeMultiplier + 0.25};
    };
} forEach ("factory" call AS_location_fnc_T);

// forEach resource, add to money
{
    private _side = _x call AS_location_fnc_side;
    private _power = [_x] call AS_fnc_location_isPowered;
    if !(_x in AS_P("destroyedLocations")) then {
        private _powerMultiplier = 1;
        if _power then {
            _powerMultiplier = 3;
        };
        if (_side == "FIA") then {
          _FIAnewMoney = _FIAnewMoney + (100 * _powerMultiplier * _FIAResIncomeMultiplier);
          _FIAnewFuel = _FIAnewFuel + (10 * _powerMultiplier * _FIAResIncomeMultiplier);
        };

        if (_side == "AAF") then {_AAFnewMoney = _AAFnewMoney + (100 * _powerMultiplier * _AAFResIncomeMultiplier)};
    };
} forEach ("resource" call AS_location_fnc_T);

//Addition: Unused HR will earn money for FIA. Consider them working for supplies etc. //TODO: probably needs balancing
private _resCount = {(_x call AS_location_fnc_side) == "FIA"} count (["resource", "factory", "seaport"] call AS_location_fnc_T);
_FIAnewMoney = _FIAnewMoney + (_resCount+1)*_FIAResIncomeMultiplier*(AS_P("hr"));


//HR builds up over time for a full HR. There's a bonus for it in case of single player or low number of players
private _hr_cum = AS_persistent getVariable ["hr_cum", 0];
private _player_count = count (allPlayers - entities "HeadlessClient_F");



_hr_cum = _hr_cum + _FIAnewHR - (floor _FIAnewHR);
if (_player_count < 5 and {_player_count > 0}) then {
  _hr_cum = _hr_cum + (0.5/_player_count); //TODO: balance this out. Now it's 1 HR every two updates for single player
};

while {_hr_cum >= 1} do {
  _FIAnewHR = _FIAnewHR + 1;
  _hr_cum = _hr_cum - 1;
};

//While petros is dead or HQ is on the move, no HR or money benefits to the players. This to keep players exploiting by keeping petros dead to avoid HQ attacks or others
//TODO: Notification during update about petros death / hq moving

if (!(alive petros) or !(isNil "AS_HQ_moving")) then {
  _FIAnewMoney = 0;
  _FIAnewHR = 0;
  _FIAnewFuel = 0;
} else {

  private _texto = format ["<t size='0.6' color='#C1C0BB'>Taxes Income.<br/> <t size='0.5' color='#C1C0BB'><br/>Manpower: +%1<br/>Money: +%2 €<br/>Fuel: +%3",floor _FIAnewHR, round _FIAnewMoney, round _FIAnewFuel];

  [petros, "income",_texto] remoteExec ["AS_fnc_localCommunication", [0,-2] select isDedicated];

};

_FIAnewHR = AS_P("hr") + floor _FIAnewHR;

if (_FIAnewHR > 0) then {
  _FIAnewHR = _FIAnewHR min (["HR"] call fnc_BE_permission);
};

_AAFnewMoney = AS_P("resourcesAAF") + round _AAFnewMoney;
_FIAnewMoney = AS_P("resourcesFIA") + round _FIAnewMoney;
_FIAnewFuel = AS_P("fuelFIA") + _FIAnewFuel;

//Share money among FIA members TODO: adjustment to the share value? make it persistent then
//Share is the percentage or FIA income whichever is smaller

if (_player_count > 0) then {
  [round(((AS_players_share/100)*_FIAnewMoney) min (_FIAnewMoney - AS_P("resourcesFIA")))] call AS_players_fnc_shareMoney;
};

//Commander gets score every update
if (not(isNull AS_commander)) then {

  [AS_commander, "score", 1] call AS_players_fnc_change;

};


AS_Pset("hr",_FIAnewHR);
AS_Pset("hr_cum", _hr_cum);
AS_Pset("resourcesFIA",_FIAnewMoney);
AS_Pset("resourcesAAF",_AAFnewMoney);
AS_Pset("fuelFIA",_FIAnewFuel);

[_skipping] spawn AS_weather_fnc_changeWeather;
