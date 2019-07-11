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
    [-10, 0, [0, 0], [-2, -2000], [0, 0, []], -10*60, [
      ["Traitor can reveal our locations or worsen our relations with foreign operators", {
        private _locations = ("FIA" call AS_location_fnc_S) select {(_x call AS_location_fnc_type) in ["watchpost", "roadblock", "camp", "fia_hq"]};
        if (count _locations > 0) then {
          private _reveal = selectRandom _locations;
          [_reveal] call AS_location_fnc_knownLocations;
        } else {
          [-5, 5] remoteExec ["AS_fnc_changeForeignSupport", 2];
        };
      }]
    ]]
};
if (_type == "kill_officer") exitWith {
    [-10, 0, [0, 0], [0, 0], [5, 0, _position], -10*60, [], [_location,-30]]
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
    [-10, 0, [0, 5], [0, 0], [15, 0, _position], 0]
};
if (_type == "convoy_money") exitWith {
    [-10, 0, [0, 5], [0, 0], [20, 0, _position], 0, [[(["AAF", "name"] call AS_fnc_getEntity) + " gains money", {[5000] call AS_fnc_changeAAFmoney}]]]
};
if (_type == "convoy_ammo") exitWith {
    [-10, 0, [0, 0], [0, 0], [0, 0, []], -10*60, [[(["AAF", "name"] call AS_fnc_getEntity) + " gains money", {[10000] call AS_fnc_changeAAFmoney}]]]
};
if (_type == "convoy_fuel") exitWith {
    [-10, 0, [0, 0], [0, 0], [0, 0, _position], -10*60, [[(["AAF", "name"] call AS_fnc_getEntity) + " gains money", {[5000] call AS_fnc_changeAAFmoney}]]]


};


if (_type == "convoy_armor") exitWith {
    [-10, 0, [0, 0], [0, 0], [0, 0, []], -20*60]
};
if (_type == "convoy_hvt") exitWith {
    [-10, 0, [0, 0], [0, 0], [0, 0, []], -20*60]
};
if (_type == "convoy_prisoners") exitWith {
    [-10, 0, [0, 0], [0, 0], [-5, -5, _position], 0]
};
if (_type == "defend_city") exitWith {
    [-50, [500, _position, 5], [5, -5], [0, 0], [-10, -20, _position], -10*60, [
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
    [-5, [500, _position, 5], [0, -5], [0, 0], [0, -5, _position], -10*60]
};
if (_type == "defend_hq") exitWith {
    [-10, [500, _position, 5], [0, -5], [0, 0], [0, -10, _position], -10*60]
};
if (_type in ["destroy_antenna", "destroy_helicopter", "destroy_vehicle", "steal_ammo", "rob_bank","steal_fuel"]) exitWith {
    [-10, 0, [0, 0], [0, 0], [0, 0, []], -10*60]
};

if (_type == "send_meds") exitWith {
    [-10, 0, [0, 0], [0, 0], [0,-15,_position]]
};
if (_type == "help_meds") exitWith {
    [-10, 0, [0, 5], [0, 0], [0,0,[]]] //City support depends on if the crate was left intact
};
if (_type in ["nato_armor", "nato_ammo", "nato_artillery", "nato_uav", "nato_roadblock", "nato_qrf", "nato_cas"]) exitWith {
    [-10, 0, [-10, 0]]
};
if (_type == "broadcast") exitWith {
    [-5, 0, [0, 0], [0, 0], [5,-5,_position]]
};
if (_type == "pamphlets") exitWith {
    [-5, 0, [0, 0], [0, 0], [0,-5,_position]]
};
if (_type == "repair_antenna") exitWith {
    _args params [["_antennaPos", [0,0,0]]];
    [-10, 0, [0, 0], [0, 0], [0, 0, []], -10*60,
        [[(["AAF", "name"] call AS_fnc_getEntity) + " antenna is repaired", {
            params ["_antennaPos"];
            AS_Pset("antenasPos_alive", AS_P("antenasPos_alive") + [_antennaPos]);
            AS_Pset("antenasPos_dead", AS_P("antenasPos_dead") - [_antennaPos]);
            private _antenna = nearestBuilding _antennaPos;
            _antenna setDammage 0;
            _antenna addEventHandler ["Killed", AS_fnc_antennaKilledEH];
        }, [_antennaPos]]]
    ];
};
if (_type == "rescue_prisioners") exitWith {
    _args params [["_dead", 0]];
    [-10, 0, [-_dead, 0], [0, 0], [0, 0, []], 0, [["Variable lost of NATO support", {}]]]
};
if (_type == "rescue_refugees") exitWith {
    _args params [["_dead", 0]];
    [-10, 0, [-_dead, 0], [0, 0], [0, -_dead, _position], 0, [["Variable lost of NATO and city support", {}]]]
};
[-10]
