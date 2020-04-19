#include "../macros.hpp"
private _isJip = false;
if isNull player then {
    _isJip = true;
};
diag_log "[AS] Client: waiting for player...";
waitUntil {sleep 0.1; !isNull player and {player == player}};
player enablesimulation false;
player setcaptive true;
cutText ["Initializing...","BLACK"];

diag_log "[AS] Client: initializing...";
player setPos ((getMarkerPos "FIA_HQ") findEmptyPosition [2, 10, typeOf (vehicle player)]);
[player] call AS_fnc_emptyUnit;
player call AS_fnc_equipDefault;
[] spawn {
    private _dots = "";
    while {isNil "AS_common_variables_initialized" and {isnil "AS_commander"}} do {
        hint ("The mission is initializating" + _dots);
        sleep 1;
        _dots = _dots + ".";
    };
    hint "";
};

call compile preprocessFileLineNumbers "briefing.sqf";

if not isServer then {
    diag_log "[AS] Client: initializing common variables...";
    call compile preprocessFileLineNumbers "initialization\common_variables.sqf";
} else {
    diag_log "[AS] Client: waiting for common variables...";
    waitUntil {sleep 1; not isNil "AS_common_variables_initialized"};
  };

if isMultiplayer then {
	["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;//Exec on client
};

///// display what mods the client has
private _texto = "";

if hasTFAR then {
	_texto = "TFAR Detected.\nAntistasi will use TFAR radios.\n";
};
if (hasACE) then {
	_texto = _texto + "ACE 3 Detected\n
                       \nACE items added.
                       \nDefault AI control disabled.";
    if (hasACEMedical) then {
        _texto = _texto + "\nACE Medical being used: default revive system disabled.";
    };
};

if (hasTFAR or hasACE) then {
	hint format ["%1",_texto];
};

/////////////////////////////////////////////////////////////////////////////
///////////// Client waits to become an admin or a game to start ////////////
/////////////////////////////////////////////////////////////////////////////
diag_log "[AS] Client: waiting for the admin to choose sides...";

waitUntil {sleep 1;

    if (player call AS_fnc_isAdmin and {not (isNil "AS_server_variables_initialized")}) then {
        hint "You are the current administrator.";

        if (isNil {AS_P("player_side")} and {not(_isJip)}) then {
            // game hasn't started: launch start menu and wait for it to start
            [] spawn AS_fnc_UI_startMenu_menu;
            waitUntil {sleep 1; not isNil {AS_P("player_side")}};
        };
    };

    not isNil ({AS_P("player_side")}) or _isJip
};

if not isServer then {
    waitUntil {not isNil ({AS_P("player_side")})};
    call compile preprocessFileLineNumbers "initialization\common_side_variables.sqf";
    waitUntil {not isNil "AS_dataInitialized"};
    call AS_scheduler_fnc_initialize;
} else {
    waitUntil {sleep 0.1; not isNil "AS_server_side_variables_initialized" and {not isNil "AS_dataInitialized"}};
};

[] execVM "reinitY.sqf";
[] spawn AS_fnc_UI_showTopBar;

["Soldier", "delete"] call AS_fnc_spawnPlayer;

[] spawn AS_fnc_activatePlayerRankLoop;


/////////////////////////
///// JIP STUFF /////////
/////////////////////////

if _isJip then {
	{
	if (_x isKindOf "FlagCarrier") then {
		private _location = [call AS_location_fnc_all, getPos _x] call BIS_fnc_nearestPosition;
		if !((_location call AS_location_fnc_type) in ["hill", "roadblock"]) then {
			if (_location call AS_location_fnc_side == "FIA") then {
				_x addAction [localize "STR_act_recruitUnit", {call AS_fnc_UI_recruitUnit_menu;},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];
				_x addAction [localize "STR_act_buyVehicle", {call AS_fnc_UI_buyVehicle_menu;},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];
				_x addAction [localize "STR_act_persGarage", {nul = [true] spawn AS_fnc_accessGarage},nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',objNull])"];
			};
		};
	};
  if (_x isKindof "Truck_F" and {!((_x call AS_fuel_fnc_getfuelCargoSize) > 0)}) then {
    [_x, "recoverEquipment"] call AS_fnc_addAction;
    [_x, "transferTo"] call AS_fnc_addAction;

    //TODO somehow to check that boxcargo has synced? is it even necessary?
    if (count(_x getVariable ["boxCargo",[]]) > 0) then {
      [_x, "unloadCargo"] call AS_fnc_addAction;
      };

    };

  if (_x isKindof "Truck_F" and {_x call AS_fnc_getSide == "FIA" and {_x call AS_fuel_fnc_getfuelCargoSize > 0}}) then {
    [_x, "refuel_truck"] call AS_fnc_addAction;
    [_x, "refuel_truck_check"] call AS_fnc_addAction;
    };


	} forEach vehicles - [bandera,fuego,caja,cajaVeh];

	{
	if ([_x] call AS_fnc_getFIAUnitType == "Survivor") then {
		if (!isPlayer (leader group _x)) then {
			_x addAction [localize "STR_act_orderRefugee", AS_actions_fnc_rescue,nil,0,false,true];
		};
	};
	} forEach allUnits;

	// sync the inventory content to the JIP.
  //Unnecessary, done below
	//[false] remoteExec ["AS_fnc_refreshArsenal", 2];
};

[] spawn {
    waitUntil {sleep 1; not isNil "petros"};
    [petros, "mission"] call AS_fnc_addAction;
};

player enablesimulation true;
cutText ["","BLACK IN", 1];


removeAllActions caja;
[caja,"arsenal"] call AS_fnc_addAction;
[caja,"transferFrom"] call AS_fnc_addAction;
[caja,"emptyPlayer"] call AS_fnc_addAction;
[caja, "vehicle_cargo_check"] call AS_fnc_addAction;

//OBSOLETE if no arsenal waiting
//caja addEventHandler ["ContainerOpened", {_this spawn AS_fnc_showUnlocked}];

removeAllActions mapa;
mapa addAction [localize "str_act_gameOptions", {CreateDialog "game_options";},nil,0,false,true,"","(isPlayer _this) and {_this call AS_fnc_isAdmin}"];
mapa addAction [localize "str_act_commanderMenu", {CreateDialog "commander_menu";},nil,0,false,true,"","(isPlayer _this) and (_this == AS_commander) and (_this == _this getVariable ['owner',_this])"];
mapa addAction [localize "str_act_mapInfo", AS_actions_fnc_location_mapInfo,nil,0,false,true,"","(isPlayer _this) and (_this == _this getVariable ['owner',_this])"];

removeAllActions bandera;
[bandera,"unit"] call AS_fnc_addAction;
[bandera,"vehicle"] call AS_fnc_addAction;
[bandera,"garage"] call AS_fnc_addAction;

bandera addAction [localize "str_act_hqOptions",AS_fnc_UI_manageHQ_menu,nil,0,false,true,"","(isPlayer _this) and (player == AS_commander) and (_this == _this getVariable ['owner',_this])"];
bandera addAction [localize "STR_act_manageTraits",AS_fnc_UI_manageTraits_menu,nil,0,false,true,"","(isPlayer _this) and {not (player call AS_fnc_controlsAI)}"];

removeAllActions cajaVeh;
[cajaVeh, "healandrepair"] call AS_fnc_addAction;
[cajaVeh, "refuel"] call AS_fnc_addAction;

removeAllActions fuego;
fuego addAction [localize "str_act_rest", AS_actions_fnc_skiptime,nil,0,false,true,"","(_this == AS_commander)"];

{
    [_x,"moveObject"] call AS_fnc_addAction;
} forEach [caja, mapa, bandera, cajaVeh, fuego];

diag_log "[AS] Client: initialized";
