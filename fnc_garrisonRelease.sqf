params ["_location"];

if (isnil "_location") exitWith {
  diag_log "[AS] Warning: garrisonRelease executed for nil location. Aborted";
};

//Only do this if the garrison is spawned. if not, spawn it
if(!(_location call AS_spawn_fnc_exists)) then {
  _location call AS_location_fnc_spawn;

  [_location, "location"] call AS_spawn_fnc_add;
  [[_location], "AS_spawn_fnc_execute"] call AS_scheduler_fnc_execute;
};

//This might be run while the spawning has yet finished even tough spawned returns true (updateALl city flip)
//Thus wait until spawn state has finished (location/spawns/FIAgeneric.sqf)

waitUntil {sleep 0.2; _location call AS_spawn_fnc_exists};

waitUntil {sleep 0.2; ([_location, "state_index"] call AS_spawn_fnc_get) >= 1};


private _garrison = [_location, "FIAsoldiers"] call AS_spawn_fnc_get;
private _groups = [];
private _count = 0;
private _group = createGroup ("FIA" call AS_fnc_getFactionSide);
_groups pushBack _group;
//Make HC groups of 8
{
  if (_count == 8) then {
     _group = createGroup ("FIA" call AS_fnc_getFactionSide);
     _groups pushBack _group;
     _count = 0;
  };
  [_x] joinSilent _group;
  _x setVariable ["marcador", nil, true];
  _count = _count + 1;
} foreach _garrison;
if (isPlayer AS_commander) then {
  {
    AS_commander hcsetGroup [_x];
    _x setVariable ["isHCgroup", true, true];
  } foreach _groups;
} else {
  //Dismiss the squad if no player TODO: where to dismiss if FIA HQ moving is in progress?
[_groups] spawn AS_fnc_dismissFIAsquads;
};





//Remove new HC squad from the garrison and the spawn but preserve NATO soldiers in the spawn

[_location, "garrison", []] call AS_location_fnc_set;
[_location, "FIAsoldiers", []] call AS_spawn_fnc_set;
[_location, "soldiers", ([_location, "soldiers"] call AS_spawn_fnc_get) - _garrison] call AS_spawn_fnc_set;

private _locType = _location call AS_location_fnc_type;
private _locName = text (nearestLocation [_location call AS_location_fnc_position, ""]); //Conside AS_fnc_getlocationName here

private _text = format ["%1 near 2% garrison is now under your command", _locType, _locName];
[leader _group, "sideChat", _text] call AS_fnc_localCommunication;

[_group,{_this setvariable ["UPSMON_NOWP", 3]}] remoteExec ["call", groupowner _group]; //This will prevent UPSMON for creating waypoints for HC squad, target sharing remains. TODO: consider NOVEH2 parameter here

/*_group setVariable ["UPSMON_Remove", true]; //UPSMON no longer interferes
sleep 20;
[leader _group, _location, "NOWP3", "NOVEH2"] spawn UPSMON; //_location passed as patrolmarker for upsmon to work: with nowp3 it won't be used
*/
