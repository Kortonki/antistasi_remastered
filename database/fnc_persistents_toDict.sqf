#include "../macros.hpp"
AS_SERVER_ONLY("AS_database_fnc_persistents_toDict");

private _money = AS_P("resourcesFIA");
private _hr = AS_P("hr");
private _fuelReserves = AS_P("fuelFIA");

// money for spawned units
{
    if ((alive _x) and {!(_x call AS_medical_fnc_isUnconscious)} and
            {(_x call AS_fnc_getSide) == "FIA"} and
            {_x getVariable ["BLUFORSpawn", true]} and // garrisons are already tracked by the garrison list
            {!isPlayer _x} and
             //survivors as members of FIA should count? they're inited to side == "FIA" if rescued, otherwise no side
            {group _x in (hcAllGroups AS_commander)}) then { //TODO uncoscious player leaders?

        _hr = _hr + 1;
        diag_log format ["AS: Savegame, FIA unit (%1: %2) converted to 1 HR", _x, typeOf _x];

        if (group _x in (hcAllGroups AS_commander) and {group _x != group AS_commander}) then  {
        _money = _money + ((_x call AS_fnc_getFIAUnitType) call AS_fnc_getCost);
        diag_log format ["AS: Savegame, FIA unit (%1: %2) converted to %3 money", _x, typeOf _x, ((_x call AS_fnc_getFIAUnitType) call AS_fnc_getCost)];
      };

    };
} forEach allUnits;



// money and fuel for FIA vehicles TODO: vehicles to garages?
{
    private _closest = (getPos _x) call AS_location_fnc_nearest;
    private _closest_pos = _closest call AS_location_fnc_position;

    //Vehicles closer than 200m and owned by FIA will become persistent
    if (alive _x and {not(_x in AS_P("vehicles")) and {_closest_pos distance2D (position _x) <= 200 and {(_x call AS_fnc_getSide) isEqualTo "FIA"}}}) then {
      [_x] call AS_fnc_changePersistentVehicles;
      diag_log format ["AS: Savegame, FIA vehicle (%1) saved as persistent. Location: %2", _x,  _closest];
    } else {

      if    ((alive _x) and {not(_x in AS_P("vehicles"))} and // these are saved and so they are not converted to money
            {(_x call AS_fnc_getSide) == "FIA"} and
            {(_x getvariable "owner") in (hcAllGroups AS_commander) and !(isPlayer(leader (_x getvariable "owner")))} and
            {([_x] call AS_fuel_fnc_getVehicleFuel) >= (_x call AS_fuel_fnc_returnTripFuel)}
            ) then {

        private _price = ([typeOf _x] call AS_fnc_getFIAvehiclePrice);
        {_price = _price + ([typeOf _x] call AS_fnc_getFIAvehiclePrice)} forEach attachedObjects _x;

        private _fuel = (_x call AS_fuel_fnc_getVehicleFuel) - (_x call AS_fuel_fnc_returnTripFuel);
        if (finite (getFuelCargo _x)) then {_fuel = _fuel + (_x getVariable ["fuelCargo",0])};

        _fuelReserves = _fuelReserves + _fuel;
        _money = _money + _price;


        diag_log format ["AS: Savegame, FIA vehicle (%1) converted to %2 money, %3 fuel. Location: %4", _x, _price, _fuel, _closest];

      };
    };

} forEach vehicles;

// convert vehicles to positional information
//if motor vehicle, get vehicle fuel


//TODO consider below if vehicles far away from FIA locations should be persistent?


private _vehicles = [];

{
    private _type = typeOf _x;
    private _pos = getPos _x;
    private _dir = getDir _x;

    private _fuel = fuel _x;
    private _damage = damage _x;
    //Store fuel insteed
    /*_fuelReserves = _fuelReserves + _fuel;
    if (finite (getFuelCargo _x)) then {_fuelReserves = _fuelReserves + (_x getVariable ["fuelCargo",0])};*/
    private _fuelCargo = _x call AS_fuel_fnc_getFuelCargo;

    _vehicles pushBack [_type, _pos, _dir, _fuel, _fuelCargo, _damage];
    diag_log format ["AS: Savegame, vehicle (%1) saved as persistent: Type %2 Pos %3 Dir %4 Fuel %5 Fuelcargo %6 Damage %7 ",_x, _type, _pos, _dir, _fuel, _fuelCargo, _damage];

} forEach AS_P("vehicles");

// convert everything to a dictionary
private _dict = call DICT_fnc_create;
{
    call {
        if (_x == "vehicles") exitWith {
            [_dict, _x, _vehicles] call DICT_fnc_setGlobal;
        };
        if (_x == "hr") exitWith {
            [_dict, _x, _hr] call DICT_fnc_setGlobal;
        };
        if (_x == "date") exitWith {
            [_dict, _x, date] call DICT_fnc_setGlobal;
        };
        if (_x == "BE_module") exitWith {
            [_dict, _x, call fnc_BE_save] call DICT_fnc_setGlobal;
        };
        if (_x == "resourcesFIA") exitWith {
            [_dict, _x, _money] call DICT_fnc_setGlobal;
        };
        if (_x == "fuelFIA") exitWith {
            [_dict, _x, _fuelReserves] call DICT_fnc_setGlobal;
        };

        [_dict, _x, AS_P(_x)] call DICT_fnc_setGlobal;
    };
} forEach AS_database_persistents;
_dict
