params ["_box", "_unit", "_id"];

if (!(isNil{_box getVariable "loading"})) exitWith {
  private _text = "This crate is already being loaded";
  [_unit, "hint", _text] call AS_fnc_localCommunication;

};

//Search for a nearby vehicles
private _vehicleReq = _box getVariable ["requiredVehs", ["Truck_F"]];

private _candidates = (position _box) nearEntities [_vehicleReq, 10];
if (count _candidates == 0) exitWith {
  private _text = "You need a proper truck close to the cargo to load";
  [_unit, "hint", _text] call AS_fnc_localCommunication;
};

//Nearest trcuk gets loaded
private _truck = _candidates select 0;



if (([_truck] call AS_fnc_getSide) != "FIA") exitWith {
  private _text = "Nearest vehicle isn't yours!";
  [_unit, "hint", _text] call AS_fnc_localCommunication;
  false
};

if ((_truck call AS_fuel_fnc_getFuelCargo) > 0 or (getRepairCargo _truck) > 0) exitWith {
  private _text = "Nearest vehicle isn't suitable for this cargo";
  [_unit, "hint", _text] call AS_fnc_localCommunication;
  false
};


if (!isNil{_truck getVariable "Loading"}) exitWith {
  private _text = "This truck is already handling cargo!";
  [_unit, "hint", _text] call AS_fnc_localCommunication;
  false

};

if (isNil{_truck getVariable "boxCargo"}) then {_truck setVariable ["boxCargo", [],true];};
private _boxCount = count (_truck getVariable "boxCargo");


if (_boxcount >= 3) exitWith {
  private _text = "Nearest vehicle is full of cargo";
  [_unit, "hint", _text] call AS_fnc_localCommunication;
  false
};

if (!(alive _truck)) exitWith {
  private _text = "You cannot load cargo into a wreck";
  [_unit, "hint", _text] call AS_fnc_localCommunication;
  false
};

if (vehicle _unit != _unit and {speed vehicle _unit >= 1}) exitWith {
  private _text = "Stop the truck first!";
  [_unit, "hint", _text] call AS_fnc_localCommunication;
  false
};

if ([position _box, 50] call AS_fnc_enemiesNearby) exitWith {

_box setVariable ["loading", nil, true];
private _text = "You cannot load cargo with enemies nearby!";
[_unit, "hint", _text] call AS_fnc_localCommunication;
false

};

if (vehicle _unit != _unit) then {
  _unit action ["Eject", _truck];sleep 3;
};



//Avoid double loading

_box setVariable ["loading", true, true];
_truck setVariable ["Loading", true, true];

_unit playActionNow "MedicOther";

[_truck, (position _truck), 10, {speed _truck < 1}, {!(alive _truck) or ([position _box, 50] call AS_fnc_enemiesNearby) or _truck distance _box > 10}, "Keep the truck still", ""] call AS_fnc_wait_or_fail;

if (!(alive _truck)) exitWith {_box setVariable ["loading", nil, true];};

if ([position _box, 50] call AS_fnc_enemiesNearby) exitWith {

_box setVariable ["loading", nil, true];
_truck setVariable ["Loading", nil, true];
private _text = "You cannot load cargo with enemies nearby!";
[_unit, "hint", _text] call AS_fnc_localCommunication;
false

};

if (_truck distance _box > 10) exitWith {
  _box setVariable ["loading", nil, true];
  _truck setVariable ["Loading", nil, true];
  private _text = "Truck is too far from the crate";
  [_unit, "hint", _text] call AS_fnc_localCommunication;
  false

};


_box setVariable ["asCargo", true, true];


_truck setVariable ["boxCargo", (_truck getVariable "boxCargo") + [_box], true];

//TODO check for memory points for proper attach point

_box setdir (getdir _truck + 90);

private _selectionName = "trup";
if (!(_truck iskindOf "Truck_F")) then {
  _box attachTo [_truck, [0, (-1)-(_boxcount), 0], _selectionName]; //"trup works good with vanilla vehicles"
} else {
  _box attachTo [_truck, [0, -(_boxcount), 0], _selectionName]; //"trup works good with vanilla vehicles"
};

if ((_boxcount + 1) == 1) then {
  [_truck, "unloadCargo"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated, true];
};

private _text = "Cargo loaded into the truck";
[_unit, "hint", _text] call AS_fnc_localCommunication;

_box setVariable ["loading", nil, true];
_truck setVariable ["Loading", nil, true];

true

//allow to access boxes inventory via vehicle inventory. Also if storing the vehcile while it has
//cargo the items are stored;
