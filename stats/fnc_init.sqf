#include "../macros.hpp"
AS_SERVER_ONLY("AS_stats_fnc_init");

//Starting stats for a game. Run only on new game

["startdate", date] call AS_stats_fnc_set;

//City populations at start for end calcs
[AS_container, "stats", "startcitypops", call DICT_fnc_create] call DICT_fnc_setGlobal;

private _pop = 0;
{
	private _citypop = [_x, "population"] call AS_location_fnc_get;
  [AS_container, "stats", "startcitypops", _x, _citypop] call DICT_fnc_setGlobal;
	_pop = _pop + _citypop;
} forEach call AS_location_fnc_cities;

["startpop", _pop] call AS_stats_fnc_set;

//Side casualties
//COMMON for all sides

private _commonStats = ["casualties", "civKills", "journalistKills"];


{
  private _type = _x;
  [AS_container, "stats", _type, call DICT_fnc_create] call DICT_fnc_setGlobal;
  {
    [AS_container, "stats", _type, _x, 0] call DICT_fnc_setGlobal;
  } foreach ["FIA", "NATO","AAF", "CSAT"];
} foreach _commonStats;

private _vehicleTypes = ["d_vehicles", "d_tanks", "d_apcs", "d_helis", "d_planes"];
//other side variables
{
  private _type = _x;
  [AS_container, "stats", _type, call DICT_fnc_create] call DICT_fnc_setGlobal;
  {
    [AS_container, "stats", _type, _x, 0] call DICT_fnc_setGlobal;
  } foreach ["NATO","AAF", "CSAT", "FIA"];
} foreach _vehicleTypes;

//FIA stats

private _FIAstats = ["rescued", "civHealed", "vehsCaptured", "apcsCaptured", "tanksCaptured", "helisCaptured", "planesCaptured", "traitorsKilled"];

[AS_container, "stats", "fiastats", call DICT_fnc_create] call DICT_fnc_setGlobal;
{
	[AS_container, "stats", "fiastats", _x, 0] call DICT_fnc_setGlobal;
} foreach _FIAstats;

//Stored messages

["storedmessages", []] call AS_stats_fnc_set;
