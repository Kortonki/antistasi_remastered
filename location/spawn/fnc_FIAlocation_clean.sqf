#include "../../macros.hpp"

params ["_location"];
private _posicion = _location call AS_location_fnc_position;
private _size = _location call AS_location_fnc_size;

private _soldadosFIA = [_location, "FIAsoldiers"] call AS_spawn_fnc_get;

waitUntil {sleep AS_spawnLoopTime; not(_location call AS_location_fnc_spawned)};

private _buildings = nearestObjects [_posicion, AS_destroyable_buildings, _size*1.5];
[_buildings] remoteExec ["AS_fnc_updateDestroyedBuildings", 2];

private _vs = [];

private _cargo_w = [[], []];
private _cargo_m = [[], []];
private _cargo_i = [[], []];
private _cargo_b = [[], []];

if (_location call AS_location_fnc_side == "FIA") then {

  {

        //Recover units arsenal

        private _arsenal = [_x, true] call AS_fnc_getUnitArsenal;  // restricted to locked weapons
  			_cargo_w = [_cargo_w, _arsenal select 0] call AS_fnc_mergeCargoLists;
  			_cargo_m = [_cargo_m, _arsenal select 1] call AS_fnc_mergeCargoLists;
  			_cargo_i = [_cargo_i, _arsenal select 2] call AS_fnc_mergeCargoLists;
  			_cargo_b = [_cargo_b, _arsenal select 3] call AS_fnc_mergeCargoLists;
  			[cajaVeh, (_arsenal select 4)]; call AS_fnc_addMagazineRemains;

        //Vehicles, their equipment and fuel: TODO exclude statics for optimisation

        if (!isNull (assignedVehicle _x)) then {
  				private _veh = assignedVehicle _x;
  				if !(_veh in _vs) then {
  					_vs pushBack _veh; //Do not recover same vehicle twice

            //TODO: Consider if below even necessary. Can garrison have vehicles that ar enot persistent?
  					if (!(_veh in AS_P("vehicles")) and {_veh != _x}) then {

						//Recover fuel and price

             _resourcesFIA = _resourcesFIA + ([(typeOf _veh)] call AS_fnc_getFIAvehiclePrice);

  						private _fuel = _veh call AS_fuel_fnc_getVehicleFuel;
  						if (finite (getFuelCargo _veh)) then {_fuel = _fuel + (_veh getVariable ["fuelCargo",0]);};
  						[_fuel] remoteExec ["AS_fuel_fnc_changeFIAfuelReserves", 2];

  						//Any vehicle (statics) attached to the vehicle

  						if (count attachedObjects _veh > 0) then {
  						        private _subVeh = (attachedObjects _veh) select 0;
  						        _resourcesFIA = _resourcesFIA + ([(typeOf _subVeh)] call AS_fnc_getFIAvehiclePrice);
  						        [_subVeh] RemoteExecCall ["deleteVehicle", _subVeh];
  						};

  						//Recover equipment from the squad vehicle

  						private _vehArsenal = [_veh, true] call AS_fnc_getBoxArsenal;
  						_cargo_w = [_cargo_w, _vehArsenal select 0] call AS_fnc_mergeCargoLists;
  						_cargo_m = [_cargo_m, _vehArsenal select 1] call AS_fnc_mergeCargoLists;
  						_cargo_i = [_cargo_i, _vehArsenal select 2] call AS_fnc_mergeCargoLists;
  						_cargo_b = [_cargo_b, _vehArsenal select 3] call AS_fnc_mergeCargoLists;
  						[cajaVeh, (_vehArsenal select 4)]; call AS_fnc_addMagazineRemains;

  						[_veh] RemoteExecCall ["deleteVehicle", _veh];
  					};
  				};


  			};

      if (alive _x) then {
          if (vehicle _x != _x) then {moveOut _x;}; //This was added so vehicle soldier is in is not deleted
          deleteVehicle _x;
      };
    } forEach _soldadosFIA;
};

//add everything

[caja, _cargo_w, _cargo_m, _cargo_i, _cargo_b] call AS_fnc_populateBox;

([_location, "resources"] call AS_spawn_fnc_get) params ["_task", "_groups", "_vehicles", "_markers"];
[_groups, _vehicles, _markers] call AS_fnc_cleanResources;
[_location, "delete", true] call AS_spawn_fnc_set;
