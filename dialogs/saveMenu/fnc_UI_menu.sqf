disableSerialization;
createDialog "AS_saveMenu";

waitUntil {sleep 0.1; !(isNull (findDisplay 1601))};

[] call AS_fnc_UI_loadMenu_update;
