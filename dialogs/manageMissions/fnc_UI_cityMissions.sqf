#include "../../macros.hpp"
createDialog "AS_cityMissions";

waitUntil {sleep 0.02; !(isNil "AS_cityMission_type")};


openMap true;

private _typeString = "";
switch (AS_cityMission_type) do {
    case "send_meds" : {_typeString = "supply";};
    case "pamphlets" : {_typeString = "drop leaflets";};
    case "broadcast" : {_typeString = "propaganda";};
    default {};
};

hint format ["Choose target city for %1 mission", _typeString];

MapPos = [];
onMapSingleClick "MapPos = _pos";
waitUntil {count MapPos > 0 or !visibleMap;};

if (count MapPos == 0) exitWith {AS_cityMission_type = nil;};

private _location = [call AS_location_fnc_cities, MapPos] call bis_fnc_NearestPosition;



private _sig = format ["%1_%2", AS_cityMission_type, _location];

//If same mission not active, activate new one.

if (!(_sig call AS_mission_fnc_status == "active")) then {

  //Pass the same checks as the mission were spawned randomly
  if (AS_cityMission_type == "pamphlets" and {[_location, "AAFsupport"] call AS_location_fnc_get == 0 or (AS_P("resourcesFIA") < 100)}) exitWith {
    hint "This mission is not possible at this time. (Costs 100 € and AAF support must be over 0)";
  };
  if (AS_cityMission_type == "send_meds" and {AS_P("resourcesFIA") < 100}) exitWith {
    hint "This mission is not possible at this time. (Costs 100€)";
  };
  if (AS_cityMission_type == "broadcast" and {[_location, "FIAsupport"] call AS_location_fnc_get <= 10 or (AS_P("resourcesFIA") < 600)}) exitWith {
    hint "This mission is not possible at this time. (Costs 600€ and FIA support must be over 10)";
  };


private _mission = [AS_cityMission_type, _location] call AS_mission_fnc_add;
_mission call AS_mission_fnc_activate;


} else {
  hint "This mission is already active!";
};

openMap false;

AS_cityMission_type = nil;
MapPos = nil;
