disableSerialization;

if (not(alive petros)) exitwith {hint "Petros is dead"};

createDialog "AS_ManageMissions";

call AS_fnc_UI_manageMissions_updateList;
