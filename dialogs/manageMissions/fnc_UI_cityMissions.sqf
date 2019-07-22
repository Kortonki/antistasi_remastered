#include "../../macros.hpp"
createDialog "AS_cityMissions";

waitUntil {sleep 0.1; !(isNil "AS_cityMission_type")};


openMap true;

private _typeString = "";
switch (AS_cityMission_type) do {
    case "send_meds" : {_typeString = "supply";};
    case "pamphlets" : {_typeString = "drop leaflets";};
    case "broadcast" : {_typeString = "propaganda";};
    default {};
};
waitUntil {sleep 0.1; visibleMap};

hint format ["Choose target city for %1 mission", _typeString];

MapPos = [];
onMapSingleClick "MapPos = _pos;";
waitUntil {sleep 1; count MapPos > 0 or !visibleMap};

if (count MapPos == 0) exitWith {AS_cityMission_type = nil; onMapSingleClick "";};

private _location = [[] call AS_location_fnc_cities, MapPos] call bis_fnc_NearestPosition;



private _sig = format ["%1_%2", AS_cityMission_type, _location];

//If same mission not active, activate new one.

private _status = _sig call AS_mission_fnc_status;

if (isNil "_status") then {_status = "";};
if (!(_status == "active")) then {

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


//private _mission = [AS_cityMission_type, _location] call AS_mission_fnc_add;
//_mission call AS_mission_fnc_activate;
if (!(_status in ["possible", "available"])) then {
    [AS_cityMission_type, _location] remoteExec ["AS_mission_fnc_add", 2];

waitUntil {sleep 0.2; (_sig call AS_mission_fnc_status) == "possible"};
sleep 1;

  };
[_sig] remoteExec ["AS_mission_fnc_activate", 2];


} else {
  hint "This mission is already active!";
};

openMap false;

AS_cityMission_type = nil;
MapPos = [];
onMapSingleClick "";
