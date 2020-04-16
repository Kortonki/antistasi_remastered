#include "../macros.hpp"
if not hasInterface exitWith {};

params ["_object","_type"];

#define IS_PLAYER "(isPlayer _this) and (_this == _this getVariable ['owner',_this])"
#define IS_PLAYER_IN_VEHICLE "(isPlayer _this) and (_this == _this getVariable ['owner',_this]) and (vehicle _this != _this)"
#define IS_COMMANDER "(isPlayer _this) and (_this == _this getVariable ['owner',_this]) and (_this == AS_commander)"
#define IS_UNLOADED "not(_target getVariable 'asCargo')"
#define NOT_MOVING "isNil {_this getVariable 'ObjAttached'}"
#define NOT_IN_VEHICLE "(vehicle _this == _this)"


switch _type do {
	case "unit": {_object addAction [localize "STR_act_recruitUnit", {call AS_fnc_UI_recruitUnit_menu},nil,0,false,true,"",IS_PLAYER]};
	case "vehicle": {_object addAction [localize "STR_act_buyVehicle", {call AS_fnc_UI_buyVehicle_menu},nil,0,false,true,"",IS_PLAYER]};
	case "mission": {removeAllActions petros; petros addAction [localize "STR_act_missionRequest", {call AS_fnc_UI_manageMissions_menu},nil,0,false,true,"",IS_COMMANDER]};
	case "transferFrom": {_object addAction [localize "STR_act_unloadCargo", AS_actions_fnc_transferFrom,nil,0,false,true,"",NOT_IN_VEHICLE, 10]};
	case "transferTo": {_object addAction [localize "STR_act_loadCargo", AS_actions_fnc_transferFrom,nil,0,false,true,"",NOT_IN_VEHICLE, 10]};
	case "recoverEquipment": {_object addAction [localize "STR_act_recoverEquipment", AS_actions_fnc_recoverEquipment,nil,0,false,true,"",NOT_IN_VEHICLE, 10]};
	case "emptyPlayer": {_object addAction [localize "STR_act_emptyPlayer", AS_actions_fnc_emptyPlayer, nil, 0, false, true, "",IS_PLAYER]};
	case "remove": {
		for "_i" from 0 to (_object addAction ["",""]) do {
			_object removeAction _i;
		};
		-1
	};
	case "refugiado": {_object addAction [localize "STR_act_orderRefugee", AS_actions_fnc_rescue,nil,0,false,true]};
	case "prisionero": {_object addAction [localize "STR_act_liberate", AS_actions_fnc_rescue,nil,0,false,true]};
	case "interrogate": {_object addAction [localize "STR_act_interrogate", AS_actions_fnc_interrogate,nil,0,false,true,"",NOT_IN_VEHICLE]};
	case "offerToJoin": {_object addAction [localize "STR_act_offerToJoin", AS_actions_offerToJoin,nil,0,false,true,"",NOT_IN_VEHICLE]};
	case "buildHQ": {_object addAction [localize "STR_act_buildHQ", {[] remoteExec ["AS_fnc_HQbuild", 2]},nil,3,false,true,"","true", 10]};
	case "seaport": {_object addAction ["Buy Boat", AS_actions_fnc_buyBoat,nil,0,false,true,"",IS_PLAYER]};
	case "garage": {
		if isMultiplayer then {
			_object addAction [localize "STR_act_persGarage", {[true] spawn AS_fnc_accessGarage},nil,0,false,true,"",IS_PLAYER]
		};
		_object addAction [localize "STR_act_FIAGarage", {[false] spawn AS_fnc_accessGarage},nil,0,false,true,"",IS_COMMANDER]
	};
	case "heal_camp": {_object addAction [localize "STR_act_useMed", AS_actions_fnc_heal,nil,0,false,true,"",IS_PLAYER, 10]};
	case "refuel": {_object addAction [localize "STR_act_refuel", AS_actions_fnc_refuel,nil,0,false,false,"",IS_PLAYER_IN_VEHICLE, 20]};
	case "refuel_truck": {_object addAction [localize "STR_act_refuel_truck", AS_actions_fnc_refuel_truck,nil,0,false,false,"",IS_PLAYER, 10]};
	case "refuel_truck_check": {_object addAction [localize "STR_act_refuel_truck_check", AS_actions_fnc_refuel_truck_check,nil,0,false,false,"",IS_PLAYER,10]};
	case "vehicle_cargo_check" : {_object addAction [[localize "STR_act_vehicle_cargo_check", localize "STR_act_arsenal_cargo_check"] select (_object == caja), AS_actions_fnc_vehicle_cargo_check,nil,0,false,false,"",IS_PLAYER,10]};
	case "buy_exp": {_object addAction [localize "STR_act_buy", {CreateDialog "exp_menu";},nil,0,false,true,"",IS_PLAYER]};
	case "jam": {_object addAction [localize "STR_act_jamCSAT", AS_actions_fnc_jamLRRadio,nil,0,false,true,"",NOT_IN_VEHICLE]};
	case "toggle_device": {_object addAction [localize "STR_act_toggleDevice", "Scripts\toggleDevice.sqf",nil,0,false,true,"","true"]};
	case "moveObject" : {_object addAction [localize "STR_act_moveAsset", AS_actions_fnc_moveObject,nil,0,false,true,"",IS_COMMANDER + " and " + NOT_MOVING]};
	case "deploy" : {_object addAction [localize "STR_act_buildPad", {[_this select 0, _this select 1] remoteExec ["AS_fnc_HQdeployPad", 2]},nil,0,false,true,"",IS_COMMANDER]};
	case "arsenal" : {_object addAction [localize "STR_act_arsenal", AS_actions_fnc_arsenal,nil,4,false,true,"",IS_PLAYER]};
	case "repackMagazines" : {_object addAction [localize "STR_act_repack", AS_actions_fnc_repackMagazines,nil,0,false,true,"",IS_PLAYER]};
	case "loadCargo" : {_object addAction [localize "STR_act_loadBoxCargo" + "(" + (_object getVariable ["dest", "any"]) + ")", AS_actions_fnc_loadCargo,nil,0,false,true,"",IS_UNLOADED, 10]};
	case "unloadCargo" : {_object addAction [localize "STR_act_unloadBoxCargo", AS_actions_fnc_unloadCargo,nil,0,false,true,"",NOT_IN_VEHICLE, 10]};
	case "radio" : {_object addAction [localize "STR_act_radio", AS_actions_fnc_radio,nil,0,false,true,"","true", 4]};
	case "build_camp" : {_object addAction [localize "STR_act_buildCamp", {[_this select 0, _this select 1] remoteExec ["AS_fnc_buildCamp", 2]},nil,1,false,true,"",IS_UNLOADED]};
	case "build_roadblock" : {_object addAction [localize "STR_act_buildRoadblock", {[_this select 0, _this select 1] remoteExec ["AS_fnc_buildRoadblock", 2]},nil,1,false,true,"",IS_UNLOADED]};
	case "build_watchpost" : {_object addAction [localize "STR_act_buildWatchpost", {[_this select 0, _this select 1] remoteExec ["AS_fnc_buildWatchpost", 2]},nil,1,false,true,"",IS_UNLOADED]};
	default {
		diag_log format ["[AS] Error: AS_fnc_addAction: invalid action type '%1'", _type];
		-1
	};
}
