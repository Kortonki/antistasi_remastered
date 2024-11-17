#include "../macros.hpp"
AS_SERVER_ONLY("AS_markers_fnc_enemyDetected");

params ["_enemyGroupLeader"];

private _daytime = dayTime; // assuming dayTime returns 1.66046
private _hours = floor _daytime;											//  1
private _minutes = floor ((_daytime - _hours) * 60);						// 39

private _markername = format ["_USER_DEFINED econtact_%1_%2_%3", _hours, _minutes ,call AS_fnc_uniqueID];

private _marker = createMarker [_markername, _enemyGroupLeader, 1];
_marker setMarkerType "hd_objective_noShadow";
_marker setMarkerColor "ColorRed";

private _type = "Enemy ";
private _vehicles = assignedVehicles (group _enemyGroupLeader);

//TODO: Only one vehicles is picked. OTherwise would need a logic to prioritze.
//Consider it rare for group to have multiples types of vehicles

//TODO: make below a separate function for AI group calls etc. to use

{
  private _vehtype = (_x call bis_fnc_objectType) select 1;

  if (_vehtype == "Tank") exitWith {_type = _type + "tank "};
  if (_vehtype == "Plane") exitWith {_type = _type + "plane "};
  if (_vehtype == "Helicopter") exitWith {_type = _type + "helicopter "};
  if (_vehtype == "Car") exitWith {_type = _type + "motorized "};
  if (_vehtype in ["TrackedAPC", "WheeledAPC"]) exitWith {_type = _type + "APC "};
  if (_vehtype == "StaticWeapon") exitWith {_type = _type + "static "};

} foreach _vehicles;


private _markerText = format ["%1at %2:%3",_type, _hours, _minutes call AS_fnc_minutesDisplay];

_marker SetMarkerText _markerText;
