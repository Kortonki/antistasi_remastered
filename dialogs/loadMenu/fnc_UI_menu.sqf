disableSerialization;
createDialog "AS_loadMenu";

waitUntil {sleep 0.1; !(isNil "AS_database_savedGames") and !(isNull (findDisplay 1601))};

sleep 0.5;

[] call AS_fnc_UI_loadMenu_update;

// catch the escape so that the player returns to the previous menu
(findDisplay 1601) displayAddEventHandler ["KeyDown", {
    if ((_this select 1) == 1) exitWith {  // escape pressed
        [] spawn AS_fnc_UI_loadMenu_close;
        true
    };
    false
}];
