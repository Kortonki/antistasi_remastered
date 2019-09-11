#include "macros.hpp"

params ["_target", "_caller"];

private _position = getpos _target;

//CHECKS

if (count (["watchpost"] call AS_location_fnc_T) >= BE_current_FIA_WP_Cap) exitWith {
  [petros, "sideChat", "FIA cannot maintain more watchposts. Remove watchposts or upgrade FIA level"] remoteExec ["AS_fnc_localCommunication", _caller];
};

if (AS_P("hr") < 2) exitWith {
  [petros, "sideChat", "Not enough HR (2)"] remoteExec ["AS_fnc_localCommunication", _caller];
};

if (AS_P("resourcesFIA") < 100) exitWith {
  [petros, "sideChat", "Not enough money (100€)"] remoteExec ["AS_fnc_localCommunication", _caller];
};

private _nearLocations = false;

{
  if (((_x call AS_location_fnc_position) distance2D _position) < AS_enemyDist) exitWith {_nearLocations = true};
} foreach (["AAF", "CSAT"] call AS_location_fnc_S);

if (_nearLocations) exitWith {
  [petros, "sideChat", "The location is too close to an enemy location"] remoteExec ["AS_fnc_localCommunication", _caller];
};

{
  if (((_x call AS_location_fnc_position) distance2D _position) < 100) exitWith {_nearLocations = true};
} foreach (["FIA"] call AS_location_fnc_S);

if (_nearLocations) exitWith {
  [petros, "sideChat", "The location is too close to a friendly location (100m)"] remoteExec ["AS_fnc_localCommunication", _caller];
};

///////////////////////END OF CHECKS/////////////////////////////////

private _mrk = createMarker [format ["FIAwatchpost%1", _position], _position];
_mrk setMarkerShape "ELLIPSE";
_mrk setMarkerSize [20,20];
_mrk setMarkerAlpha 0;

[_mrk, "watchpost", false] call AS_location_fnc_add;
// location takes ownership of _mrk
[_mrk, "name", _name, false] call AS_location_fnc_set;
[_mrk, "side", "FIA"] call AS_location_fnc_set;
[_mrk, "garrison", ["Sniper","Rifleman"]] call AS_location_fnc_set;

[-2, -100] remoteExec ["AS_fnc_changeFIAmoney", 2];
[_target, "remove"] call AS_fnc_addAction;
[_target] spawn AS_fnc_activateVehicleCleanup;
