#include "macros.hpp"
AS_SERVER_ONLY("fnc_updateAll.sqf");

params [["_skipping", false]];

private _AAFnewMoney = 0;
private _FIAnewMoney = 25;
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
    private _population = [_x, "population"] call AS_location_fnc_get;
    private _AAFsupport = [_x, "AAFsupport"] call AS_location_fnc_get;
    private _FIAsupport = [_x, "FIAsupport"] call AS_location_fnc_get;
    private _power = [_city] call AS_fnc_location_isPowered;

    private _incomeAAF = 0;
    private _incomeFIA = 0;
    private _HRincomeFIA = 0;

    private _popFIA = (_population * (_FIAsupport / 100));
    private _popAAF = (_population * (_AAFsupport / 100));
    _FIAtotalPop = _FIAtotalPop + _popFIA;
    _AAFtotalPop = _AAFtotalPop + _popAAF;

    if !(_city in AS_P("destroyedLocations")) then {
        private _incomeMultiplier = 0.33;
        if (not _power) then {_incomeMultiplier = 0.5*0.33};

        _incomeAAF = _incomeMultiplier*_popAAF;
        _incomeFIA = _incomeMultiplier*_popFIA;
        _HRincomeFIA = (_population * (_FIAsupport / 20000));

        if (_side == "FIA") then {
            _incomeAAF = _incomeAAF/2;
            if _power then {
                if (_FIAsupport + _AAFsupport + 1 <= 100) then {[0,1,_city] spawn AS_fnc_changeCitySupport};
            }
            else {
                if (_FIAsupport > 6) then {
                    [0,-1,_city] spawn AS_fnc_changeCitySupport;
                } else {
                    [1,0,_city] spawn AS_fnc_changeCitySupport;
                };
            };
        } else {
            _incomeFIA = (_incomeFIA/2);
            _HRincomeFIA = (_HRincomeFIA/2);
            if _power then {
                if (_AAFsupport + _FIAsupport + 1 <= 100) then {[1,0,_city] call AS_fnc_changeCitySupport};
            }
            else {
                if (_AAFsupport > 6) then {
                    [-1,0,_city] spawn AS_fnc_changeCitySupport;
                } else {
                    [0,1,_city] spawn AS_fnc_changeCitySupport;
                };
            };
        };
    };

    _AAFnewMoney = _AAFnewMoney + _incomeAAF;
    _FIAnewMoney = _FIAnewMoney + _incomeFIA;
    _FIAnewHR = _FIAnewHR + _HRincomeFIA;

    // flip cities due to majority change.
    if ((_AAFsupport < _FIAsupport) and (_side == "AAF")) then {
        [["TaskSucceeded", ["", format ["%1 joined FIA",[_city, false] call AS_fnc_getLocationName]]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
        _city call AS_location_fnc_updateMarker;

        ["con_cit"] call fnc_BE_XP;

        [0,5] call AS_fnc_changeForeignSupport;
        [_city, !_power] spawn AS_fnc_changeStreetLights;
    };
    if ((_AAFsupport > _FIAsupport) and (_side == "FIA")) then {
        [["TaskFailed", ["", format ["%1 joined %2",[_city, false] call AS_fnc_getLocationName, (["AAF", "name"] call AS_fnc_getEntity)]]],"BIS_fnc_showNotification"] call BIS_fnc_MP;
        _city call AS_location_fnc_updateMarker;
        [0,-5] call AS_fnc_changeForeignSupport;
        [_city, !_power] spawn AS_fnc_changeStreetLights;
    };
} forEach call AS_location_fnc_cities;



// control the airport and have majority => win game.
//Edited: must have twice as much influence as AAF
if ((_FIAtotalPop > (2 * _AAFtotalPop)) and ("AS_airfield" call AS_location_fnc_side == "FIA")) exitWith {
    "end1" call BIS_fnc_endMissionServer;
};

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
          _FIAnewFuel = _FIAnewFuel + (50 * _powerMultiplier * _FIAResIncomeMultiplier);
        };

        if (_side == "AAF") then {_AAFnewMoney = _AAFnewMoney + (100 * _powerMultiplier * _AAFResIncomeMultiplier)};
    };
} forEach ("resource" call AS_location_fnc_T);


//Addition: Unused HR will earn money for FIA. Consider them working for supplies etc. //TODO: probably needs balancing
private _resCount = {(_x call AS_location_fnc_side) == "FIA"} count (["resource", "seaport"] call AS_location_fnc_T);
_FIAnewMoney = _FIAnewMoney + (_resCount+1)*_FIAResIncomeMultiplier*(AS_P("hr"));



//HR builds up over time for a full HR. There's a bonus for it in case of single player or low number of players
private _hr_cum = AS_persistent getVariable ["hr_cum", 0];
private _player_count = count (allPlayers - entities "HeadlessClient_F");

_hr_cum = _hr_cum + _FIAnewHR - (floor _FIAnewHR);
if (_player_count < 5) then {
  _hr_cum = _hr_cum + (0.5/_player_count); //TODO: balance this out. Now it's 1 HR every two updates for single player
};

while {_hr_cum >= 1} do {
  _FIAnewHR = _FIAnewHR + 1;
  _hr_cum = _hr_cum - 1;
};

private _texto = format ["<t size='0.6' color='#C1C0BB'>Taxes Income.<br/> <t size='0.5' color='#C1C0BB'><br/>Manpower: +%1<br/>Money: +%2 €<br/>Fuel: +%3",floor _FIAnewHR, round _FIAnewMoney, round _FIAnewFuel];

[petros, "income",_texto] remoteExec ["AS_fnc_localCommunication", [0,-2] select isDedicated];

_FIAnewHR = AS_P("hr") + floor _FIAnewHR;

if (_FIAnewHR > 0) then {
    _FIAnewHR = _FIAnewHR min (["HR"] call fnc_BE_permission);
};

_AAFnewMoney = AS_P("resourcesAAF") + round _AAFnewMoney;
_FIAnewMoney = AS_P("resourcesFIA") + round _FIAnewMoney;
_FIAnewFuel = AS_P("fuelFIA") + _FIAnewFuel;

//Set next update time:

private _upFreq = AS_P("upFreq");
private _nextUpdate = [date select 0, date select 1, date select 2, date select 3, (date select 4) + (_upFreq/60)];
_nextUpdate = dateToNumber _nextUpdate;

AS_Pset("nextUpdate", _nextUpdate);
AS_Pset("hr",_FIAnewHR);
AS_Pset("hr_cum", _hr_cum);
AS_Pset("resourcesFIA",_FIAnewMoney);
AS_Pset("resourcesAAF",_AAFnewMoney);
AS_Pset("fuelFIA",_FIAnewFuel);

[_skipping] spawn AS_weather_fnc_changeWeather;
