// make possible missions available and vice-versa.
#include "../macros.hpp"
AS_SERVER_ONLY("AS_mission_fnc_updateAvailable");

// maximum distance from HQ for a mission to be available
#define AS_missions_MAX_DISTANCE 5000
// maximum number of missions available or active.
#define AS_missions_MAX_MISSIONS 15

diag_log format ["[AS]: Updating missions list: Time %1", time];

private _fnc_allPossibleMissions = {
    private _possible = [];

    private _locations = [[
        "outpost", "base", "airfield", "powerplant",
        "resource", "factory", "seaport", "outpostAA"
    ], "AAF"] call AS_location_fnc_TS;

    _locations append ("city" call AS_location_fnc_T); //All cities possible for example convoy missions. AAF supply convoy missions are prioritsed for FIA cities

    private _fnc_isPossibleMission = {
        // Checks whether the combination of location and mission type is a possible mission
        params ["_missionType", "_location"];
        //In following missions _location is the destination so it doesn't matter if it's spawned or not
        (not(_location call AS_location_fnc_spawned) or (_missionType in ["convoy_supplies", "convoy_money", "convoy_fuel", "convoy_armor", "convoy_prisoners", "convoy_hvt", "convoy_ammo"]))
            // and{(_location call AS_location_fnc_position) distance2D (getMarkerPos "FIA_HQ") < AS_missions_MAX_DISTANCE} // Commented out for now. So player cannot prevent missions by having HQ far. Also AAF needs to be able to send convoys to neutral towns
    };

    private _cityMissions = [
        "kill_specops",
        "help_meds","rescue_refugees",
        "convoy_supplies"
    ];
    private _baseMissions = [
        "destroy_vehicle", "convoy_armor", "convoy_ammo", "convoy_prisoners", "convoy_hvt", "convoy_fuel",
        "kill_officer", "rescue_prisioners", "steal_ammo", "steal_fuel"
    ];
    private _logisticsMissions = [
      "convoy_money"
    ];

    private _logisticsLocations = [
      "factory", "base", "airfield", "seaport"
    ];

    private _conquerableLocations = [
        "outpost", "base", "airfield", "powerplant",
        "resource", "factory", "seaport", "outpostAA"
    ];

    private _fnc_isValidMission = {
        // checks whether a given mission type is valid for a given location
        params ["_missionType", "_location"];
        private _type = _location call AS_location_fnc_type;

        false or
        {_type in _logisticsLocations and {_missionType == "convoy_money"}} or
        {_type == "outpost" and {_missionType in ["rescue_prisioners", "steal_ammo", "steal_fuel"]}} or
        {_type == "city" and {_missionType in _cityMissions}} or
        {_type == "base" and {_missionType in _baseMissions}} or
        {_type == "airfield" and {_missionType == "destroy_helicopter"}} or
        {_type in _conquerableLocations and {_missionType == "conquer"}}
    };

    private _fnc_isAvailable = {
        // checks whether a given (mission type, location) is available given the current state
        params ["_missionType", "_location"];

        //The actual check

        False or
        (not (_missionType in ["convoy_money", "convoy_supplies", "convoy_armor", "convoy_ammo", "convoy_prisoners", "convoy_hvt", "convoy_fuel", "rescue_refugees", "kill_specops"])) or
        {_missionType in ["convoy_supplies", "convoy_fuel", "convoy_ammo", "convoy_prisoners", "convoy_hvt", "convoy_money"] and {

          private _locs = ["base", "airfield"];
          if (_missionType == "convoy_money") then {
            _locs = _logisticsLocations + ["resource"];
          };
          private _lead_condition = ("cars_transport" call AS_AAFarsenal_fnc_countAvailable) > 1; //One for lead and one for possible HVT
          private _truck_condition = ("trucks" call AS_AAFarsenal_fnc_countAvailable) > 3;
          private _base = [_location call AS_location_fnc_position, _locs] call AS_fnc_getBasesForConvoy;
          private _base_condition = _base != "" and {!(_base call AS_location_fnc_busy)};

          private _condition = {false or (_base_condition and {_lead_condition and {_truck_condition}})};
          call _condition
        }} or
        {_missionType == "convoy_armor" and {

          private _lead_condition = ("cars_transport" call AS_AAFarsenal_fnc_countAvailable) > 0;
          private _truck_condition = ("trucks" call AS_AAFarsenal_fnc_countAvailable) > 3;
          private _armor_condition = ("tanks" call AS_AAFarsenal_fnc_countAvailable) > 0;
          private _base = [_location call AS_location_fnc_position, ["base"]] call AS_fnc_getBasesForConvoy;
          private _base_condition = _base != "" and {!(_base call AS_location_fnc_busy)};

          private _condition = {false or (_armor_condition and {_lead_condition and {_base_condition and {_truck_condition}}})};
          call _condition
        }} or
        {_missionType in ["rescue_refugees", "kill_specops"] and {
          private _condition = {false or (_location call AS_location_fnc_side) != "FIA"};
          call _condition
        }}

    };

    {
        private _location = _x;
        {
            private _mission = [_x, _location];
            if (_mission call _fnc_isPossibleMission and {_mission call _fnc_isValidMission}) then {
                _possible pushBack _mission;
            };
            //"conquer", "destroy_antenna" removed for now, they don't need to be as missions
        } forEach _cityMissions + _baseMissions + _logisticsMissions + [
            "destroy_helicoper"
            //, "rob_bank" //Commented for until mission developed
        ];
    } forEach _locations;

    // add other missions
    /*{
        private _location = _x call AS_location_fnc_nearest;
        if ((_x distance (getMarkerPos "FIA_HQ") < AS_missions_MAX_DISTANCE) and
            (_location call AS_location_fnc_side == "AAF") and
            not(_location call AS_location_fnc_spawned)) then {
            _possible pushBack ["destroy_antenna", _location];
        };
    } forEach AS_P("antenasPos_alive");*/

    //Bank robberies deactivated until improved
    /*{
        private _position = _x call AS_location_fnc_position;
        private _mission = ["rob_bank", _x];
        if (not (_mission in _possible) and {_position distance (getMarkerPos "FIA_HQ") < AS_missions_MAX_DISTANCE} and
            {
                private _bank_position = [AS_bankPositions, _position] call BIS_fnc_nearestPosition;
                (_position distance _bank_position) < (_x call AS_location_fnc_size)} and
            {_x call AS_location_fnc_side == "AAF"} and
            {not(_x call AS_location_fnc_spawned)}) then {
            _possible pushBack _mission;
        };
    } forEach (call AS_location_fnc_cities);*/

    {
        private _location = _x;
        private _mission = ["black_market", _location];
        // it uses exitWith so there is only one possible mission at the time.
        if (_mission call _fnc_isPossibleMission) exitWith {
            _possible pushBack _mission;
        };
    } forEach ((["city"] call AS_location_fnc_T) call AS_fnc_shuffle);

    _possible select {_x call _fnc_isAvailable}
};



// 1. intersect the list of possible missions with the cached possible missions
//  * makes all available missions possible
{
    [_x, "status", "possible"] call AS_mission_fnc_set;
} forEach (([] call AS_mission_fnc_all) select {_x call AS_mission_fnc_status == "available"});

// Removes all possible missions no longer possible and already in progress (is spawned)
private _new_possible = call _fnc_allPossibleMissions;
{
    private _signature = [_x call AS_mission_fnc_type, _x call AS_mission_fnc_location];
    if (not(_signature in _new_possible))  then {
        _x call AS_mission_fnc_remove;
    };
} forEach ((call AS_mission_fnc_all) select {_x call AS_mission_fnc_status in ["possible"]});

// Add new possible missions
private _possible = (call AS_mission_fnc_all) select {_x call AS_mission_fnc_status == "possible"};
private _active_available = (call AS_mission_fnc_all) select {_x call AS_mission_fnc_status == "active"};
{
    _x params ["_type", "_location"];
    private _sig = (format ["%1_%2", _type, _location]);
    if not (_sig in _possible or _sig in _active_available or _sig call AS_spawn_fnc_exists) then { //added spawn exist condition to not add missions still not ended and deleted
        _x call AS_mission_fnc_add;
        _possible pushBack _sig;
    };
} forEach _new_possible;

// 2. convert possible missions to available missions up to MAX available+active missions

private _count = count _active_available;

{
    if (_count >= AS_missions_MAX_MISSIONS) exitWith {};
    // make mission available
    if not (_x in _active_available) then {
        [_x, "status", "available"] call AS_mission_fnc_set;
        // update in-memory
        _active_available pushBack _x;
        _count = _count + 1;
    };
} forEach (_possible call AS_fnc_shuffle);
