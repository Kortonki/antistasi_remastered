params ["_veh", "_killer"];
if ((_veh call AS_fnc_getSide) != "AAF") exitWith {diag_log "[AS] Warning: EH_AAF_VehicleKilled executed for non-AAF vehicle";}; //If vehicle was stolen, there's nothing to do here
  //Deduct from AAF arsenal regardless of killers side
  //Also remove from spawn counter so new one can spawn
private _vehicleType = typeOf _veh;
[_vehicleType] call AS_AAFarsenal_fnc_deleteVehicle;
[_vehicleType, false] call AS_AAFarsenal_fnc_spawnCounter;

private _vehicleCategory = _vehicleType call AS_AAFarsenal_fnc_category;



  //This was moved so XP is gained only if FIA is the killer or capturer
if (side _killer == ("FIA" call AS_fnc_getFactionSide)) then {

  private _citySupportEffect = 0;
  private _xpEffect = "";
  switch _vehicleCategory do {
    case "planes": {
      _citySupportEffect = 5;
      _xpEffect = "des_arm";
    };
    case "helis_armed": {
      _citySupportEffect = 5;
      _xpEffect = "des_arm";
    };
    case "tanks": {
      _citySupportEffect = 4;
      _xpEffect = "des_arm";
    };
    case "helis_transport": {
      _citySupportEffect = 3;
      _xpEffect = "des_veh";
    };
    case "apcs": {
      _citySupportEffect = 2;
      _xpEffect = "des_arm";
    };
    case "boats" : {
      _xpEffect = "_des_veh";
      _citySupportEffect = 1;
    };
    case "cars_armed" : {
      _xpEffect = "_des_veh";
      _citySupportEffect = 1;
    };
    case "trucks" : {
      _xpEffect = "des_veh";
    };
    case "cars_transport" : {
      _xpEffect = "des_veh";
    };



    default {
      diag_log format ["[AS] ERROR in AS_AAF_VE_EHkilled: '%1' is invalid type", typeOf _veh];
    };
  };
  if (_citySupportEffect != 0) then {
    [-_citySupportEffect,_citySupportEffect,position _veh] remoteExec ["AS_fnc_changeCitySupport",2];
  };
  if (_xpEffect != "") then {[_xpEffect] remoteExec ["fnc_BE_XP", 2]};
};
