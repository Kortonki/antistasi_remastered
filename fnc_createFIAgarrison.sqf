#include "macros.hpp"
private _location = _this;

private _soldados = [];
private _grupos = [];

private _position = _location call AS_location_fnc_position;
private _size = _location call AS_location_fnc_size;
private _type = _location call AS_location_fnc_type;
private _estaticas = AS_P("vehicles") select {(typeOf _x) in AS_allStatics and {_x distance2D _position < _size}};
private _garrison = _location call AS_location_fnc_garrison;

private _grupoMort = grpNull;
private _grupoEst = grpNull;

private _grupo = createGroup ("FIA" call AS_fnc_getFactionSide);
_grupos = _grupos + [_grupo];
{
	if !(_location call AS_location_fnc_spawned) exitWith {};
	private _unit = objNull;
	call {
		// men the statics close to the location
		if ((_x == "Crew") and (count _estaticas > 0)) exitWith {
			private _estatica = _estaticas select 0;
			if (typeOf _estatica in AS_allMortarStatics) then {
                if (isNull _grupoMort) then {
                    _grupoMort = createGroup ("FIA" call AS_fnc_getFactionSide);
                };
				_unit = [_x, _position, _grupoMort] call AS_fnc_spawnFIAUnit;
				_soldados pushBack _unit;
				_unit assignAsGunner _estatica;
				_unit moveInGunner _estatica;

				[_estatica] execVM "scripts\UPSMON\MON_artillery_add.sqf";
			} else {
                if (isNull _grupoEst) then {
                    _grupoEst = createGroup ("FIA" call AS_fnc_getFactionSide);
                };
				_unit = [_x, _position, _grupoEst] call AS_fnc_spawnFIAUnit;
				_soldados pushBack _unit;
				_unit assignAsGunner _estatica;
				_unit moveInGunner _estatica;
			};
			_estaticas = _estaticas - [_estatica];
		};

		_unit = [_x, _position, _grupo] call AS_fnc_spawnFIAUnit;
		_soldados pushBack _unit;
		if (_x == "Squad Leader") then {_grupo selectLeader _unit};
	};
	[_unit,false,_location] remoteExec ["AS_fnc_initUnitFIA", _unit];
	//_soldados pushBack _unit; //This moved to corresponding unit creation to avoid possibility that _unit would refer to the vehicle unit is mounted on
	sleep 0.5;

	// create a new group for every 8 units
	if (count units _grupo == 8) then {
		_grupo = createGroup ("FIA" call AS_fnc_getFactionSide);
		_grupos pushBack _grupo;
	};
} forEach _garrison;

// give orders to the groups
private _behaviour = "SAFE";
if (_type == "watchpost") then {
	_behaviour = "STEALTH";
};

//Create the patrol marker to avoid UPSMON issues

private _patrolMarker = createMarker [format ["fia_gar_%1", _location], _position];
_patrolMarker setMarkerShape "ELLIPSE";
_patrolMarker setMarkerSize [100,100];
_patrolMarker setMarkerAlpha 0;


{
	[leader _x, _patrolMarker, _behaviour,"SPAWNED","RANDOM","NOVEH2","NOFOLLOW","LIMITED"] spawn UPSMON; //Changed NOVEH2 to NOVEH to allow manning of statics in combat
} forEach _grupos;

if !(isNull _grupoMort) then {
	_grupos pushBack _grupoMort;
};
if !(isNull _grupoEst) then {
	_grupos pushBack _grupoEst;
};

[_soldados, _grupos, _patrolMarker]
