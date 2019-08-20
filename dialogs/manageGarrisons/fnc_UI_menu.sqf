disableSerialization;

createDialog "AS_manageGarrisons";

((findDisplay 1602) displayCtrl 2) ctrlSetText "FIA_HQ";
[] spawn AS_fnc_UI_manageGarrisons_updateList;

//If exited the dialog, check if garrison changed:

waitUntil {sleep 1; isNull (findDisplay 1602)};

if (not(isNil "garrisonUpdated")) then {
  [map_location] spawn AS_location_fnc_respawnGarrison;
  map_location = nil;
  garrisonUpdate = nil;
};
