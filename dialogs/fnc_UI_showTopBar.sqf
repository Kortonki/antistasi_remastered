#include "../macros.hpp"
if (!isNil "showStatistics") exitWith {};
showStatistics = true;
disableSerialization;
private _layer = ["estadisticas"] call bis_fnc_rscLayer;
_layer cutRsc ["H8erHUD","PLAIN",0,false];
waitUntil {!isNull (uiNameSpace getVariable "H8erHUD")};

private _display = uiNameSpace getVariable "H8erHUD";
private _setText = _display displayCtrl 1001;
_setText ctrlSetBackgroundColor [0,0,0,0];
private _oldText = "";
private _texto = "";
if (isMultiplayer) then {
	while {showStatistics} do {
		waitUntil {sleep 0.5; not (player call AS_fnc_controlsAI)};
		private _natoSupport = format ["%1 Support: %2", (["NATO", "name"] call AS_fnc_getEntity), AS_P("NATOsupport")];
		if (player != AS_commander) then {
			private _commanderName = "NONE";
			if (isPlayer AS_commander) then {_commanderName = name AS_commander};
			_texto = format ["<t size='0.55'>" + "Commander: %3 | %2 | HR: %1 | Your Money: %4 € | %5 | %6 | %7",
							 AS_P("hr"),
							 player getVariable ["Rank_PBar", "Init"],
							 _commanderName,
							 [player, "money"] call AS_players_fnc_get,
							 _natoSupport,
							 AS_S("BE_PBar"),
							 ["Not undercover", "<t color='#1DA81D'>Undercover</t>"] select (captive player)
			];
		} else {
			_texto = format ["<t size='0.55'>" + "%9 | Your Money: %1 | HR: %2 | FIA Money: %3 € | Fuel: %4 l | %5 | %6 | %7",
				[player, "money"] call AS_players_fnc_get,
				AS_P("hr"),
				AS_P("resourcesFIA"),
				round(AS_P("fuelFIA")),
				_natoSupport,
				AS_S("BE_PBar"),
				["Not undercover", "<t color='#1DA81D'>Undercover</t>"] select (captive player),
				player getVariable ["Rank_PBar", "Init"]
			];
		};
		if (_texto != _oldText) then {
			_setText ctrlSetStructuredText (parseText format ["%1", _texto]);
			_setText ctrlCommit 0;
			_oldText = _texto;
		};
		if (player == leader (group player)) then {
			if (not(group player in (hcAllGroups player))) then {player hcSetGroup [group player]};
		};
		sleep 1;
	};
} else {
	while {showStatistics} do {
		waitUntil {sleep 0.5; not (player call AS_fnc_controlsAI)};
		private _natoSupport = format ["%1 Support: %2", (["NATO", "name"] call AS_fnc_getEntity), AS_P("NATOsupport")];
		_texto = format ["<t size='0.55'>" + "HR: %1 | FIA Money: %2 € | Fuel: %3 l | %4 | %5 | %6",
			AS_P("hr"),
			AS_P("resourcesFIA"),
			round(AS_P("fuelFIA")),
			_natoSupport,
			AS_S("BE_PBar"),
			["Not undercover", "<t color='#1DA81D'>Undercover</t>"] select (captive player)
		];
		if (_texto != _oldText) then {
			_setText ctrlSetStructuredText (parseText format ["%1", _texto]);
			_setText ctrlCommit 0;
			_oldText = _texto;
		};
		sleep 1;
	};
};
