disableSerialization;

createDialog "AS_manageGarrisons";

//Commented out, this happens through selectonMAP
//((findDisplay 1602) displayCtrl 2) ctrlSetText "FIA_HQ";
//[] spawn AS_fnc_UI_manageGarrisons_updateList;

//If exited the dialog, check if garrison changed:

waitUntil {sleep 1; isNull(findDisplay 1602) and {isNull(findDisplay 1702)}};

if (not(isNil "garrisonUpdated")) then {
  [map_location] spawn AS_location_fnc_respawnGarrison;
  map_location = nil;
  garrisonUpdated = nil;
};
