#include "macros.hpp"
AS_SERVER_ONLY("fnc_HQforceBuild.sqf");

params ["_position"];

//Forcing causes penalty for petros' death

if (alive petros) then {

  //Halve nato support
  private _nato = AS_P("NATOsupport");
  _nato = floor (_nato/2);
  AS_Pset("NATOsupport", _nato);

  //Halve all city support for FIA

  {
    private _sup = [_x, "FIAsupport"] call AS_location_fnc_get;
    _sup = floor (_sup/2);
    [_x, "FIAsupport", _sup] call AS_location_fnc_set;
  } forEach (call AS_location_fnc_cities);

};

deleteVehicle petros;
deletegroup grupoPetros;

//Release garrison
if ("fia_hq" call AS_spawn_fnc_exists) then {
  ["fia_hq"] call AS_fnc_garrisonRelease;
};

//TODO: Need to check if new HQ is too close to enemy location?

private _oldPos = ["fia_hq", "position"] call AS_location_fnc_get;
["fia_hq", "position", _position] call AS_location_fnc_set;
if (_position distance2D _oldPos >= 500) then {
	//If new FIA HQ is far enough from the old one, AAF has to discover it again
	["fia_hq", false] call AS_location_fnc_knownLocations;

  if ("fia_hq" in AS_P("patrollingLocations")) then {
    AS_Pset("patrollingLocations", (AS_P("patrollingLocations") - ["fia_hq"]));
  };
};

[] call AS_fnc_initPetros;

// place everything on its place
[] call AS_fnc_HQdeploy;

// and then show everything
if isMultiplayer then {
	{_x hideObjectGlobal false} forEach AS_permanent_HQplacements;
} else {
	{_x hideObject false} forEach AS_permanent_HQplacements;
};

{
	[_x] remoteExec ["AS_fnc_activateVehicleCleanup", _x];
} foreach AS_HQ_placements;

AS_HQ_placements = [];
