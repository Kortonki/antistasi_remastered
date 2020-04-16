#include "../macros.hpp"
AS_SERVER_ONLY("server.sqf");

call AS_scheduler_fnc_initialize;

// AS_persistent are public server-side variables.
AS_persistent = createSimpleObject ["Static", [0, 0, 0]];
publicVariable "AS_persistent";

// AS_shared are public temporary server-side variables.
AS_shared = createSimpleObject ["Static", [0, 0, 0]];
publicVariable "AS_shared";

// AS_container is used to store persistent variables from generic APIs
AS_container = createSimpleObject ["Static", [0, 0, 0]];
publicVariable "AS_container";

diag_log "[AS] Server: starting";

call compile preprocessFileLineNumbers "initLocations.sqf";
diag_log "[AS] Server: initLocations done";

call compile preprocessFileLineNumbers "initialization\common_variables.sqf";
// tells the client.sqf running on this machine that variables are initialized

AS_common_variables_initialized = true; //this moved here was common_variables before
publicVariable "AS_common_variables_initialized";
diag_log "[AS] Server: common variables initialized";

call compile preprocessFileLineNumbers "initialization\server_variables.sqf";
diag_log "[AS] Server: server variables initialized";

AS_server_variables_initialized = true;
publicVariable "AS_server_variables_initialized";

["Initialize"] call BIS_fnc_dynamicGroups;

{if not isPlayer _x then {deleteVehicle _x}} forEach allUnits;

diag_log "[AS] Server: waiting for side...";
waitUntil {sleep 0.1; not isNil {AS_P("player_side")}};
sleep 0.2;


call compile preprocessFileLineNumbers "initialization\common_side_variables.sqf";
call compile preprocessFileLineNumbers "initialization\server_side_variables.sqf";
AS_server_side_variables_initialized = true;
publicVariable "AS_server_side_variables_initialized";
diag_log "[AS] Server: server side-variables initialized";

waitUntil {not (isNil "AS_dataInitialized")};

if isMultiplayer then {
    // after game start because disconnects before have no influence
    addMissionEventHandler ["HandleDisconnect", {
        [_this select 0] call AS_fnc_onPlayerDisconnect;
        true
    }];

    // for the spawns
    addMissionEventHandler ["HandleDisconnect", {
        private _owner = _this select 4;
        _owner call AS_spawn_fnc_drop;
        false
    }];

    // this will wait until a commander is chosen
    waitUntil {sleep 1; count (allPlayers - entities "HeadlessClient_F") > 0 and {isnull AS_commander}};

    ["none"] call AS_fnc_chooseCommander;
} else {
    [player] call AS_fnc_setCommander;
};


[true] call AS_spawn_fnc_toggle;
[true] call AS_fnc_resourcesToggle;
