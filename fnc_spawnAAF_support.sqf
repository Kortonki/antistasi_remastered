params ["_origin", "_dir", "_destination", "_side", ["_types", ["repair", "ammo", "fuel"]]];

private _vehicles = [];
private _units = [];
private _supportGroup = createGroup (_side call AS_fnc_getFactionSide);
private _position = +_origin;

{
  private _class = format ["truck_%1", _x];
  private _vehType = [_side, _class] call AS_fnc_getEntity; //In templates this is not an array like the others, but a single classname
  ([_vehType, _position, _dir, _side, "gunner", 0, "NONE"] call AS_fnc_createVehicle) params ["_veh", "_vehGroup"];
  {
    [_x, _side, true] call AS_fnc_initUnit;
    [_x] join _supportGroup;
    _units pushback _x;
  } foreach (units _vehGroup);

  [_veh, _side] call AS_fnc_initVehicle;
  _vehicles pushback _veh;
  deleteGroup _vehGroup;

  _position = [_position, 20, _dir + 180] call BIS_fnc_relpos;
} foreach _types;

private _wp0 = _supportGroup addWaypoint [_destination, 0];
_wp0 setwaypointType "SUPPORT";
_wp0 setWaypointBehaviour "SAFE";
_wp0 setWaypointFormation "COLUMN";

[_vehicles, _supportGroup, _units];
