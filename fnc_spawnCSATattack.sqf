#include "macros.hpp"
params ["_patrolMarker", "_maxcount", "_threatEvalAir"];
//count here is the max count for csat choppers, otherwise depends on csatsupport

private _position = getMarkerPos _patrolMarker;

private _originPos = getMarkerPos "spawnCSAT";

private _groups = [];
private _vehicles = [];

private _transportHelis = ["CSAT", "helis_transport"] call AS_fnc_getEntity;
private _attackHelis = (["CSAT", "helis_armed"] call AS_fnc_getEntity) + (["CSAT", "helis_attack"] call AS_fnc_getEntity);

[0,-10] remoteExec ["AS_fnc_changeForeignSupport", 2]; //CSAT support lowered each attack

private _count = (1 + floor (AS_P("CSATsupport")/25)) min _maxcount;

for "_i" from 1 to _count do {
    private _waveType = selectRandom ["fastrope", "disembark", "paradrop"];
    private _helicopterType = selectRandom _transportHelis;
    if (_i == 1) then {
        _waveType = "cas";
        _helicopterType = selectRandom _attackHelis;
    };
    // find spawn position
    private _pos = [];

    _pos = _originPos findEmptyPosition [0, 500, _helicopterType];
    if (count _pos == 0) then {
      _pos = _originPos;
    };

    _pos set [2,300];

    //([_pos, 0, _helicopterType, "CSAT" call AS_fnc_getFactionSide] call bis_fnc_spawnvehicle) params ["_heli", "_heliCrew", "_grupoheli"];
    ([_helicopterType, _pos, 0, "CSAT", "pilot", 300, "FLY"] call AS_fnc_createVehicle) params ["_heli", "_grupoheli"];

    _groups pushBack _grupoheli;
    _vehicles pushBack _heli;

    call {
        // CAS => send chopper on SAD
        if (_waveType == "cas") exitWith {
            private _wp1 = _grupoheli addWaypoint [_position, 0];
            _wp1 setWaypointType "SAD";
            [_heli, "CSAT Air Attack"] spawn AS_fnc_setConvoyImmune;
        };
        // it is a transport wave

        // helicopter does not participate in battle
        {
            _x setBehaviour "CARELESS";
            _x disableAI "TARGET";
            _x disableAI "AUTOTARGET";
        } forEach units _grupoheli;
        [_heli,"CSAT Air Transport"] spawn AS_fnc_setConvoyImmune;

        // initialize group
		private _groupType = [["CSAT", "squads"] call AS_fnc_getEntity, "CSAT"] call AS_fnc_pickGroup;
		private _group = createGroup ("CSAT" call AS_fnc_getFactionSide);
		[_groupType call AS_fnc_groupCfgToComposition, _group, _pos, _heli call AS_fnc_availableSeats] call AS_fnc_createGroup;
		{
			_x assignAsCargo _heli;
			_x moveInCargo _heli;
			[_x] spawn AS_fnc_initUnitCSAT;
		} forEach units _group;
		_groups pushBack _group;

        if (_waveType == "paradrop") exitWith {
            [_originPos, _position, _grupoheli, _patrolMarker, _group, _threatEvalAir] spawn AS_tactics_fnc_heli_paradrop;
        };
        if (_waveType == "disembark") exitWith {
            _vehicles append ([_originPos, _position, _grupoheli, _group, _patrolMarker] call AS_tactics_fnc_heli_disembark);
        };
        [_originPos, _position, _grupoheli, _patrolMarker, _group, _threatEvalAir] spawn AS_tactics_fnc_heli_fastrope;
    };
};

[_groups, _vehicles]
