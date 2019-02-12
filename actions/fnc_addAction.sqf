#include "../macros.hpp"
if not hasInterface exitWith {};

params ["_object","_type"];

#define IS_PLAYER "(isPlayer _this) and (_this == _this getVariable ['owner',_this])"
#define IS_COMMANDER "(isPlayer _this) and (_this == _this getVariable ['owner',_this]) and (_this == AS_commander)"
#define IS_UNLOADED "not(_target getVariable 'asCargo')"
#define NOT_MOVING "isNil {_this getVariable 'ObjAttached'}"


switch _type do {
	case "unit": {_object addAction [localize "STR_act_recruitUnit", {call AS_fnc_UI_recruitUnit_menu},nil,0,false,true,"",IS_PLAYER]};
	case "vehicle": {_object addAction [localize "STR_act_buyVehicle", {call AS_fnc_UI_buyVehicle_menu},nil,0,false,true,"",IS_PLAYER]};
	case "mission": {removeAllActions petros; petros addAction [localize "STR_act_missionRequest", {call AS_fnc_UI_manageMissions_menu},nil,0,false,true,"",IS_COMMANDER]};
	case "transferFrom": {_object addAction [localize "STR_act_unloadCargo", "actions\transferFrom.sqf",nil,0,false,true,"",IS_PLAYER]};
	case "recoverEquipment": {_object addAction [localize "STR_act_recoverEquipment", "actions\recoverEquipment.sqf",nil,0,false,true,"",IS_PLAYER]};
	case "remove": {
		for "_i" from 0 to (_object addAction ["",""]) do {
			_object removeAction _i;
		};
		-1
	};
	case "refugiado": {_object addAction [localize "STR_act_orderRefugee", "actions\rescue.sqf",nil,0,false,true]};
	case "prisionero": {_object addAction [localize "STR_act_liberate", "actions\rescue.sqf",nil,0,false,true]};
	case "interrogate": {_object addAction [localize "STR_act_interrogate", "actions\askIntel.sqf",nil,0,false,true,"",IS_PLAYER]};
	case "offerToJoin": {_object addAction [localize "STR_act_offerToJoin", "actions\offerToJoin.sqf",nil,0,false,true,"",IS_PLAYER]};
	case "buildHQ": {_object addAction [localize "STR_act_buildHQ", {[] remoteExec ["AS_fnc_HQbuild", 2]},nil,0,false,true,"",IS_PLAYER]};
	case "seaport": {_object addAction ["Buy Boat", "actions\buyBoat.sqf",nil,0,false,true,"",IS_PLAYER]};
	case "garage": {
		if isMultiplayer then {
			_object addAction [localize "STR_act_persGarage", {[true] spawn AS_fnc_accessGarage},nil,0,false,true,"",IS_PLAYER]
		};
		_object addAction [localize "STR_act_FIAGarage", {[false] spawn AS_fnc_accessGarage},nil,0,false,true,"",IS_COMMANDER]
	};
	case "heal_camp": {_object addAction [localize "STR_act_useMed", "actions\heal.sqf",nil,0,false,true,"",IS_PLAYER, 10]};
	case "refuel": {_object addAction [localize "STR_act_refuel", "actions\refuel.sqf",nil,0,false,false,"",IS_PLAYER, 20]};
	case "refuel_truck": {_object addAction [localize "STR_act_refuel_truck", "actions\refuel_truck.sqf",nil,0,false,false,"",IS_PLAYER, 10]};
	case "refuel_truck_check": {_object addAction [localize "STR_act_refuel_truck_check", "actions\refuel_truck_check.sqf",nil,0,false,false,"",IS_PLAYER,10]};
	case "buy_exp": {_object addAction [localize "STR_act_buy", {CreateDialog "exp_menu";},nil,0,false,true,"",IS_PLAYER]};
	case "jam": {_object addAction [localize "STR_act_jamCSAT", "actions\jamLRRAdio.sqf",nil,0,false,true,"",IS_PLAYER]};
	case "toggle_device": {_object addAction [localize "STR_act_toggleDevice", "Scripts\toggleDevice.sqf",nil,0,false,true,"",IS_PLAYER]};
	case "moveObject" : {_object addAction [localize "STR_act_moveAsset", "actions\moveObject.sqf",nil,0,false,true,"",IS_COMMANDER + " and " + NOT_MOVING]};
	case "deploy" : {_object addAction [localize "STR_act_buildPad", {[_this select 0, _this select 1] remoteExec ["AS_fnc_HQdeployPad", 2]},nil,0,false,true,"",IS_COMMANDER]};
	case "arsenal" : {_object addAction [localize "STR_act_arsenal", "actions\arsenal.sqf",nil,0,false,true,"","(isPlayer _this)"]};
	case "repackMagazines" : {_object addAction [localize "STR_act_repack", "actions\repackMagazines.sqf",nil,0,false,true,"",IS_PLAYER]};
	case "loadCargo" : {_object addAction [localize "STR_act_loadBoxCargo", "actions\loadCargo.sqf",nil,0,false,true,"",IS_UNLOADED, 10]};
	case "unloadCargo" : {_object addAction [localize "STR_act_unloadBoxCargo", "actions\unloadCargo.sqf",nil,0,false,true,"","true", 10]};
	case "radio" : {_object addAction [localize "STR_act_radio", "actions\radio.sqf",nil,0,false,true,"","true", 4]};
	default {
		diag_log format ["[AS] Error: AS_fnc_addAction: invalid action type '%1'", _type];
		-1
	};
}
