params ["_truck", "_unit", "_id"];

if (!(isNil{_truck getVariable "Loading"})) exitWith {
  private _text = "This truck is already handling cargo";
  [_unit, "hint", _text] call AS_fnc_localCommunication;

};

private _boxcount = count (_truck getVariable "boxCargo");

private _box = (_truck getVariable "boxCargo") select (_boxcount - 1); //Always take the last box

if (isNull attachedTo _box) exitWith {

  _box setVariable ["asCargo", false, true];
  private _text = "Cargo is already unloaded";
  [_unit, "hint", _text] call AS_fnc_localCommunication;

  true
};

if (vehicle _unit != _unit and {speed vehicle _unit >= 1}) exitWith {
      private _text = "Stop the truck first!";
      [_unit, "hint", _text] call AS_fnc_localCommunication;
      false
};


//Dismount unit first

if (vehicle _unit != _unit) then {
  _unit action ["Eject", _truck];
  sleep 3;
};




//Find a spot to unload behind the truck

private _dist = (abs(((boundingBox _truck select 0) select 1) - ((boundingBox _truck select 1) select 1))) / 2; // get distance from veh center to rear end

private _dir = getDir _truck;
private _pos = [(getpos _truck select 0) - (_dist * (sin _dir)), (getpos _truck select 1) - (_dist *(cos _dir)), 0];
//Experiment which one is better
//_pos = [_pos, 0, 2, 1.7, 0, 0,0,[], []] call bis_fnc_findSafePos;
_pos = _pos findEmptyPosition [0, 10, (["CIV", "box"] call AS_fnc_getEntity)];
if (_pos isEqualTo []) exitWith {

  private _text = "There's no space to unload the cargo!";
  [_unit, "hint", _text] call AS_fnc_localCommunication;
  false

};

if ([position _box, 50] call AS_fnc_enemiesNearby) exitWith {

_truck setVariable ["Loading", nil, true];
private _text = "You cannot unload cargo with enemies nearby!";
[_unit, "hint", _text] call AS_fnc_localCommunication;
false

};

_truck setVariable ["Loading", true, true];

_unit playActionNow "MedicOther";

[_truck, (position _truck), 5, {speed _truck < 1}, {([position _box, 50] call AS_fnc_enemiesNearby) or speed _truck > 10}, "Keep the truck still", ""] call AS_fnc_wait_or_fail;

if ([position _box, 50] call AS_fnc_enemiesNearby) exitWith {

_truck setVariable ["Loading", nil, true];
private _text = "You cannot unload cargo with enemies nearby!";
[_unit, "hint", _text] call AS_fnc_localCommunication;
false

};

if (speed _truck > 10) exitWith {
  _truck setVariable ["Loading", nil, true];
  false

};

[_truck, false] remoteExecCall [allowdamage, _truck];
[_box, false] remoteExecCall [allowdamage, _box];

sleep 0.2;
detach _box;

//"NONE" doesnt seem to work to avoid collision
_box setVehicleposition [_pos, [], 0, "CAN_COLLIDE"];

sleep 0.2;

[_truck, true] remoteExecCall [allowdamage, _truck];
[_box, true] remoteExecCall [allowdamage, _box];

_box setVariable ["asCargo", false, true];
_truck setVariable ["boxCargo", (_truck getVariable "boxCargo") - [_box], true];
if ((_boxcount - 1) == 0) then {
  //Reset actions: Removing doesn't quite work reliably, different clients have different ids
  [_truck, "remove"] remoteExecCall ["AS_fnc_addAction", [0, -2] select isDedicated];
  if (_truck isKindof "Truck_F" and {!((_truck call AS_fuel_fnc_getfuelCargoSize) > 0)}) then {
    [_truck] spawn {
        params ["_truck"];
        sleep 2;
		    [_truck, "recoverEquipment"] remoteExec ["AS_fnc_addAction", [0,-2] select isDedicated];
		    [_truck, "transferTo"] remoteExec ["AS_fnc_addAction", [0, -2] select isDedicated];
      };
	  };
};
_truck setVariable ["Loading", nil, true];

private _text = "Cargo unloaded from the truck";
[_unit, "hint", _text] call AS_fnc_localCommunication;

true
