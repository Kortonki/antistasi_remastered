#include "../macros.hpp"

params ["_mission", ["_args", []]];
private _location = _mission call AS_mission_fnc_location;
private _position = _location call AS_location_fnc_position;
private _type = _mission call AS_mission_fnc_type;
/*
PARAMS:

params [["_commander_score", 0],
        ["_players_score", [0,[0,0,0],0]],
        ["_prestige", [0, 0]],
        ["_resourcesFIA", [0, 0]],
        ["_citySupport", [0, 0, []]],
        ["_changeAAFattack", 0],
        ["_custom", []],
        ["_increaseBusy", ["", 0]]

*/

if (_type == "kill_traitor") exitWith {
  _args params [["_possibleLocations", []], ["_fiaHQpos", [0,0,0]]];
    [-10, 0, [0, 0], [0,0], [0, 0, []], -30*60, [
      ["Traitor can reveal our locations or worsen our relations with foreign operators", {
        params ["_possibleLocations", "_fiaHQpos"];
        private _newFIAHQpos = "fia_hq" call AS_location_fnc_position;

        private _debug = "[AS] Traitor fail:";

        _debug = format ["%1 possibleLocations: %2, fiaHQpos: %3,", _debug, _possibleLocations, _fiaHQpos];

        //remove FIA HQ from possible locations if it has been moved or is moving
        if (not(isnil "AS_HQ_moving") or _fiaHQpos distance2D _newFIAHQpos >= 500) then {_possibleLocations = _possibleLocations - ["fia_hq"]};
        //remove already knownLocations from revealable locations
        private _locations = _possibleLocations - ([] call AS_location_fnc_knownLocations);

        _debug = format ["%1 revealable locations: %2", _debug, _locations];
        //private _locations = ("FIA" call AS_location_fnc_S) select {(_x call AS_location_fnc_type) in ["watchpost", "roadblock", "camp", "fia_hq"]};
        if (count _locations > (random 2)) then {
          private _reveal = selectRandom _locations;
          [_reveal] call AS_location_fnc_knownLocations;
          _debug = format ["%1 Added %2 to knownlocations", _debug, _reveal];
        } else {
          [-5, 5] remoteExec ["AS_fnc_changeForeignSupport", 2];
          [-2, 0.2*(AS_P("resourcesFIA"))] remoteExec ["AS_fnc_changeFIAMoney", 2];
          _debug = format ["%1 Resources deducted", _debug];
        };
        diag_log _debug;
        //[AS_commander, "hint", _debug] remoteExec ["AS_fnc_localCommunication", AS_commander];
      }, [_possibleLocations, _fiaHQpos]]
    ]
  ];
};
if (_type == "kill_officer") exitWith {
    [-10, 0, [0, 5], [0, 0], [5, 0, _position], -10*60, [], [_location,-30]]
};
if (_type == "kill_specops") exitWith {
    [-10, 0, [0, 0], [0, 0], [5, 0, _position], -10*60]
};
if (_type == "aaf_attack_hq") exitWith {
    [-25, [500, _position, 10], [0, 3], [0, 0], [0,0, []], 5*60]
};
if (_type == "black_market") exitWith {
    [-10, 0, [-5, 0]]
};
if (_type == "aaf_attack") exitWith {
    [-25, 0, [-2, 0], [0, -1000], [0, 0, []], 2700]
};
if (_type == "conquer") exitWith {
    [-5, 0, [0, 0], [0, 0], [5, 0, _position], -10*60]
};
if (_type == "convoy_supplies") exitWith {
    [-10, 0, [0, 0], [0, 0], [20, 0, _position], 0]
};
if (_type == "convoy_money") exitWith {
    [-10, 0, [0, 0], [0, 0], [0, 0, []], 0, [[(["AAF", "shortname"] call AS_fnc_getEntity) + " gains money", {[5000] call AS_fnc_changeAAFmoney}]]]
};
if (_type == "convoy_ammo") exitWith {
    [-10, 0, [0, 0], [0, 0], [0, 0, []], -10*60, [[(["AAF", "shortname"] call AS_fnc_getEntity) + " gains money", {[10000] call AS_fnc_changeAAFmoney}]]]
};
if (_type == "convoy_fuel") exitWith {
    [-10, 0, [0, 0], [0, 0], [0, 0, _position], -10*60, [[(["AAF", "shortname"] call AS_fnc_getEntity) + " gains money", {[5000] call AS_fnc_changeAAFmoney}]]]


};


if (_type == "convoy_armor") exitWith {
    [-10, 0, [0, 0], [0, 0], [0, 0, []], -30*60]
};
if (_type == "convoy_hvt") exitWith {
    [-10, 0, [0, 0], [0, 0], [0, 0, []], -30*60]
};
if (_type == "convoy_prisoners") exitWith {
    [-10, 0, [0, 0], [0, 0], [-5, -5, _position], 0]
};
if (_type == "defend_city") exitWith {
    [-50, [500, _position, 5], [5, -5], [0, 0], [-20, -10, _position, true], -10*60, [
        ["City is destroyed", {
            params ["_location"];
            [_location] call AS_fnc_destroy_location;
        }, [_location]],
        ["FIA loses 5 support in all cities", {{[0,-5,_x] call AS_fnc_changeCitySupport} forEach (call AS_location_fnc_cities)}]
    ]]
};
if (_type == "defend_camp") exitWith {
    [-5, [500, _position, 5], [0, -5], [0, 0], [0, -5, _position], -10*60]
};
if (_type == "defend_location") exitWith {
    [-5, [500, _position, 5], [0, -5], [0, 0], [0, 0, _position], -10*60]
};
if (_type == "defend_hq") exitWith {
    [-10, [500, _position, 5], [0, -5], [0, 0], [0, -10, _position], -10*60]
};
if (_type in ["destroy_antenna", "destroy_helicopter", "destroy_vehicle", "steal_ammo", "rob_bank","steal_fuel"]) exitWith {
    [-10, 0, [0, 0], [0, 0], [0, 0, []], -10*60]
};

if (_type == "send_meds") exitWith {
    [-10, 0, [0, 0], [0, 0], [0,-10,_position, true]]
};
if (_type == "help_meds") exitWith {
    [-10, 0, [0, 5], [0, 0], [0,0,[]]] //City support depends on if the crate was left intact
};
if (_type in ["nato_armor", "nato_ammo", "nato_artillery", "nato_uav", "nato_roadblock", "nato_qrf", "nato_cas"]) exitWith {
    [-10, 0, [-10, 0]]
};
if (_type == "broadcast") exitWith {
    [-5, 0, [0, 0], [0, 0], [5,-5,_position, true]]
};
if (_type == "pamphlets") exitWith {
    [-5, 0, [0, 0], [0, 0], [0,-5,_position, true]]
};
if (_type == "repair_antenna") exitWith {
    _args params [["_antennaPos", [0,0,0]]];
    [-10, 0, [0, 0], [0, 0], [5, 0, _position], -10*60,
        [[(["AAF", "shortname"] call AS_fnc_getEntity) + " antenna is repaired", {
            params ["_antennaPos"];
            AS_Pset("antenasPos_alive", AS_P("antenasPos_alive") + [_antennaPos]);
            AS_Pset("antenasPos_dead", AS_P("antenasPos_dead") - [_antennaPos]);


            private _marker = [allMapMarkers select {markerType _x == "hd_destroy"}, _antennaPos] call BIS_fnc_nearestPosition;
            _marker setMarkerType "loc_Transmitter";
            _marker setMarkerColor "ColorWhite";
            private _typeVarName = format ["%1_type", _marker];
            private _type = missionNameSpace getVariable [_typeVarName, AS_antenasTypes select 0];

            private _antenna = (nearestobjects [_antennaPos, AS_antenasTypes, 25]) select 0;
            //if (isnull _antenna) then {
          //    _antenna = (_antennaPos nearObjects [_type, 25]) select 0;
          //  };

            //new _antenna and hide the old one
            private _newAntenna = createVehicle [_type, (getpos _antenna), [], 0, "CAN_COLLIDE"];
            _newAntenna setdir (getDir _antenna);
            _newAntenna addEventHandler ["Killed", AS_fnc_antennaKilledEH];
            _antenna hideobjectGlobal true;



        }, [_antennaPos]]]
    ];
};
if (_type == "rescue_prisioners") exitWith {
    _args params [["_dead", 0]];
    [-10, 0, [-(round(_dead/2)), 0], [0, 0], [0, 0, []], 0, [["Variable lost of NATO support", {}]]]
};
if (_type == "rescue_refugees") exitWith {
    _args params [["_dead", 0]];
    [-10, 0, [-(round(_dead/2)), 0], [0, 0], [0, (-_dead/2), _position, true], 0, [["Variable lost of NATO and city support", {}]]]
};
[-10]
