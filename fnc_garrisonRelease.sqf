params ["_location"];

//Only do this if the garrison is spawned
if(!(_location call AS_spawn_fnc_exists)) exitWith {};

private _garrison = [_location, "FIAsoldiers"] call AS_spawn_fnc_get;
private _group = createGroup ("FIA" call AS_fnc_getFactionSide);
{
  [_x] joinSilent _group;
  _x setVariable ["marcador", nil, true]; //Units are no longer part of the garrison. Important for location detection to the enemy
} foreach _garrison;
if (isPlayer AS_commander) then {
  AS_commander hcsetGroup [_group];
} else {
  //Dismiss the squad if no player TODO: where to dismiss if FIA HQ moving is in progress?
  [[_group]] spawn AS_fnc_dismissFIAsquads;
};

_group setVariable ["UPSMON_Remove", true]; //UPSMON no longer interferes

//Remove new HC squad from the garrison and the spawn but preserve NATO soldiers in the spawn

[_location, "garrison", []] call AS_location_fnc_set;
[_location, "FIAsoldiers", []] call AS_spawn_fnc_set;
[_location, "soldiers", ([_location, "soldiers"] call AS_spawn_fnc_get) - _garrison] call AS_spawn_fnc_set;

private _locType = _location call AS_location_fnc_type;
private _locName = text (nearestLocation [_location call AS_location_fnc_position, ""]); //Conside AS_fnc_getlocationName here

private _text = format ["%1 near 2% garrison is now under your command", _locType, _locName];
[leader _group, "sideChat", _text] call AS_fnc_localCommunication;
