params ["_veh"];

private _fuelusage = 0.0002; //Approximate fuel for the return trip to base. Roughly 0,2 liter per 1km for a standard car, more for tanks etc.
private _fuel = (((getpos _veh) distance ("FIA_HQ" call AS_location_fnc_position)) * (_fuelusage * ((_veh call AS_fuel_fnc_getFuelTankSize) / 60)));
_fuel
