#include "macros.hpp"

params ["_location", "_groups"];
//Send each soldier away from closest BLUFORspawn to avoid soldier multiplying when location despawns and spawns while
//soldiers do not (individually checked for spawn condition). OTOH removing them immediately might make them
//despawn far away from location but close to a player or FIA soldiers (UPSMON can send them away and otherwise)

private _spawnDist =  AS_P("spawnDistance");
private _position = _location call AS_location_fnc_position;
private _blufors = [_spawnDist, _position, "BLUFORSpawn", "array"] call AS_fnc_unitsAtDistance;

//Determine closest blufor
private _closest = objNull;
private _dist = _spawnDist;
{
  if (_x distance2D _position < _dist) then {
    _dist = _x distance2D _position;
    _closest = _x;
  };
} foreach _blufors;

if (!isNull(_closest)) then {

  private _dir = _closest getDir _position;
  private _newPos = _closest getRelpos [_spawnDist*1.5, _dir];
  _newpos = [_newpos, 0, _spawnDist/2, 1, 0] call Bis_fnc_findSafePos;
  //UBER-FAILSAFE
  if (count _newPos == 0) then {_newPos = _position};

  //Make sure they retreat
  {
    _x setVariable ["UPSMON_Remove", true];
    //Give time for UPSMON to do its things
    sleep 10;
    _x move _newPos;
    _x setCombatMode "GREEN";
    _x setSpeedMode "FULL";
  } foreach _groups;
};
