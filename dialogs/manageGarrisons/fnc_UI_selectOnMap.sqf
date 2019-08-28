disableSerialization;
closeDialog 0;
openMap true;
map_location = "";
onMapSingleClick "_pos call AS_fnc_UI_manageGarrisons_onMapClick;";
waitUntil {sleep 0.5; (map_location != "") or !visibleMap};
openMap false;

onMapSingleClick "";

[] spawn AS_fnc_UI_manageGarrisons_menu;
if (map_location != "") then {
    waitUntil {sleep 0.1; not(isnull(findDisplay 1602))};
    ((findDisplay 1602) displayCtrl 2) ctrlSetText (map_location);
    call AS_fnc_UI_manageGarrisons_updateList;
};
