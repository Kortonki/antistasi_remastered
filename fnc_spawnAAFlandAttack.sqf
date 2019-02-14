params ["_toUse", "_origin", "_patrol_marker", "_threatEval"];

private _groups = [];
private _vehicles = [];

private _vehicleType = selectRandom (_toUse call AS_AAFarsenal_fnc_valid);

//Use function instead

([_origin, getMarkerPos _patrol_marker] call AS_fnc_findSpawnSpots) params ["_pos", "_dir"];


([_vehicleType, _pos, _dir, "AAF", "any"] call AS_fnc_createVehicle) params ["_vehicle", "_vehicleGroup"];
_groups pushBack _vehicleGroup;
_vehicles pushBack _vehicle;

// set waypoints
if (_toUse == "tanks") then {
	//_vehicle allowCrewInImmobile true;
	[_origin, getMarkerPos _patrol_marker, _vehicleGroup, _patrol_marker, _threatEval] spawn AS_tactics_fnc_ground_attack;
} else {
	private _groupType = [["AAF", "squads"] call AS_fnc_getEntity, "AAF"] call AS_fnc_pickGroup;
	private _group = createGroup ("AAF" call AS_fnc_getFactionSide);
	[_groupType call AS_fnc_groupCfgToComposition, _group, _pos, _vehicle call AS_fnc_availableSeats] call AS_fnc_createGroup;

	{
		[_x] call AS_fnc_initUnitAAF;
		_x assignAsCargo _vehicle;
		_x moveInCargo _vehicle;
		[_x] allowGetin true;
		[_x] orderGetin true;
	} forEach units _group;

	// APC drops the group in the safe position and moves to SAD (Search and Destroy)
	if (_toUse == "apcs") then {
		{
			[_x] joinSilent _vehicleGroup;
		} forEach units _group;
		deleteGroup _group;

		//[_vehicle] spawn AS_AI_fnc_activateUnloadUnderSmoke;
		//_vehicle allowCrewInImmobile true;
		[_origin, getMarkerPos _patrol_marker, _vehicleGroup, _patrol_marker, _threatEval] spawn AS_tactics_fnc_ground_combined;
	} else {  // is truck
		_groups pushBack _group;

		[_origin, getMarkerPos _patrol_marker, _vehicleGroup, _patrol_marker, _group, _threatEval] spawn AS_tactics_fnc_ground_disembark;
	};
};
[_groups, _vehicles]
