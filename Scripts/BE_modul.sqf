#define BE_REQ_XP [100, 150, 200, 300]

#define BE_FIA_SKILL_CAP [4, 8, 12, AS_maxSkill]
#define BE_FIA_GARAGE_CAPACITY [6, 10, 15, 20]
#define BE_PERS_GARAGE_CAPACITY [2, 4, 6, 8]
#define BE_VEHICLE_RESTRICTION [["MBT", "APC", "Heli"], ["MBT", "Heli"], ["Heli"], ["none"]]
#define BE_FIA_HR_CAP [100, 200, 400, 800]
#define BE_FIA_CAMP_CAP [2, 3, 4, 5]
#define BE_FIA_RB_CAP [2, 4, 6, 10]
#define BE_FIA_WP_CAP [2, 3, 4, 6]
#define BE_FIA_RB_STYLE [0, 0, 1, 1]
#define BE_FIA_WP_STYLE [0, 0, 1, 1]

#define BE_UPGRADE_PRICES [10000, 20000, 50000]
#define BE_UPGRADE_DISCOUNT [6000, 12000, 20000]

#define BE_COLOR_DONE "#1DA81D"
#define BE_COLOR_LOCK "#D8480A"
#define BE_COLOR_DEF "#C1C0BB"

#define BE_DISC_ONE 1000
#define BE_DISC_TWO 1500
#define BE_DISC_THREE 2000

fnc_BE_initialize = {
	if !(isNil "BE_INIT") exitWith {};

	BE_INIT = true;

	//These checks must be here because this init runs after loading a game

	if (isNil "BE_currentStage") then {BE_currentStage = 0;};
	if (isNil "BE_currentXP") then {BE_currentXP = 0;};
	if (isNil "BE_progressLock") then {BE_progressLock = false;};

	//Below are also used for AI target threat estimation

	BE_class_Heli = (["AAF", "helis"] call AS_fnc_getEntity) + (["CSAT", "helis"] call AS_fnc_getEntity) + (["NATO", "helis"] call AS_fnc_getEntity) + (["FIA", "air_vehicles"] call AS_fnc_getEntity);
	BE_class_MBT = (["AAF", "tanks"] call AS_fnc_getEntity) + (["NATO", "tanks"] call AS_fnc_getEntity);
	BE_class_APC = (["AAF", "apcs"] call AS_fnc_getEntity) + (["NATO", "apcs"] call AS_fnc_getEntity);
	BE_class_MRAP = (["AAF", "cars_armed"] call AS_fnc_getEntity) + (["AAF", "cars_transport"] call AS_fnc_getEntity) + (["NATO", "cars_armed"] call AS_fnc_getEntity) + (["NATO", "cars_transport"] call AS_fnc_getEntity);

	BE_mil_vehicles = BE_class_Heli + BE_class_MBT + BE_class_APC + BE_class_MRAP;

	[true] call fnc_BE_refresh;
	diag_log format ["[AS] Time %1: BE_module initialized", time];
};

fnc_BE_refresh = {
	BE_current_FIA_Skill_Cap = BE_FIA_SKILL_CAP select BE_currentStage;
	BE_current_FIA_GarageCap = BE_FIA_GARAGE_CAPACITY select BE_currentStage;
	BE_current_Pers_GarageCap = BE_PERS_GARAGE_CAPACITY select BE_currentStage;
	BE_current_Vehicle_Restriction = BE_VEHICLE_RESTRICTION select BE_currentStage;
	BE_current_FIA_HR_Cap = BE_FIA_HR_CAP select BE_currentStage;
	BE_current_FIA_Camp_Cap = BE_FIA_CAMP_CAP select BE_currentStage;
	BE_current_FIA_RB_Cap = BE_FIA_RB_CAP select BE_currentStage;
	BE_current_FIA_WP_Cap = BE_FIA_WP_CAP select BE_currentStage;

	[] call fnc_BE_pushVariables;
	[] call fnc_BE_updateProgressBar;

	BE_currentRestrictions = [
		BE_current_FIA_Skill_Cap,
		BE_current_FIA_GarageCap,
		BE_current_Pers_GarageCap,
		BE_current_Vehicle_Restriction,
		BE_current_FIA_HR_Cap,
		BE_current_FIA_Camp_Cap,
		BE_current_FIA_RB_Cap,
		BE_current_FIA_WP_Cap
	];
};

fnc_BE_pushVariables = {
	publicVariable "BE_current_FIA_Skill_Cap";
	publicVariable "BE_current_FIA_GarageCap";
	publicVariable "BE_current_Pers_GarageCap";
	publicVariable "BE_current_Vehicle_Restriction";
	publicVariable "BE_current_FIA_HR_Cap";
	publicVariable "BE_current_FIA_Camp_Cap";
	publicVariable "BE_current_FIA_RB_Cap";
	publicVariable "BE_current_FIA_WP_Cap";

	publicVariable "BE_class_Heli";
	publicVariable "BE_class_MBT";
	publicVariable "BE_class_APC";
	publicVariable "BE_class_MRAP";
	publicVariable "BE_mil_vehicles";

	publicVariable "BE_currentStage";
};

fnc_BE_XP = {
	// increases the experience of FIA
	AS_SERVER_ONLY("BE_modul.sqf/fnc_BE_XP");
	params ["_category"];
	private _delta = 0;

	if ((BE_currentStage > 3) || (BE_progressLock)) exitWith {};

	switch (_category) do {
		case "kill": {
			_delta = 0.5;
		};
		case "killCSAT": {

			_delta = 1;
		};
		case "mis": {
			_delta = 10;
		};
		case "des_veh": {
			_delta = 5;
		};
		case "des_arm": {
			_delta = 10;
		};
		case "cap_veh": {
			_delta = 8;
		};
		case "cap_arm": {
			_delta = 12;
		};
		case "con_ter": {
			_delta = 10;
		};
		case "con_bas": {
			_delta = 20;
		};
		case "con_cit": {
			_delta = 15;
		};
		case "cl_loc": {
			_delta = 5;
		};
		case "death": {
			_delta = -0.5;
		};
		case "deathP": {
			_delta = -1;
		};
		default {
			diag_log format ["Error in BE module XP - param 1: %1", _category];
		};
	};

	BE_currentXP = (BE_currentXP + _delta) max 0;
	[] call fnc_BE_updateProgressBar;
};

fnc_BE_updateProgressBar = {
	private ["_req", "_cV", "_pV", "_v"];

	_req = BE_REQ_XP select BE_currentStage;
	_cV = BE_currentXP / _req;
	_v = AS_P("skillFIA");

	if (BE_progressLock) exitWith {
		_pV = [BE_COLOR_LOCK, BE_COLOR_LOCK, BE_current_FIA_Skill_Cap, BE_current_FIA_Skill_Cap+1, "Army XP"];
		BE_currentXP = 0; //This set to so XP stays at max until no progress lock
		["Army XP", _pV, _cV] call AS_fnc_updateProgressBar;
	};

	_pV = [BE_COLOR_DONE, BE_COLOR_DEF, _v, _v+1, "Army XP"];

	if (_cV > 1) then {
		AS_Pset("skillFIA",_v+1);
		BE_currentXP = BE_currentXP - _req;
		if ((_v+1) >= BE_current_FIA_Skill_Cap) then {
			_pV = [BE_COLOR_LOCK, BE_COLOR_LOCK, BE_current_FIA_Skill_Cap, BE_current_FIA_Skill_Cap+1, "Army XP"];
			BE_progressLock = true;
			BE_currentXP = 0;
		};
		[format ["<t color='#1DA81D'>New FIA Skill Level: %1</t>", _v+1],0,0,4,0,0,4] remoteExec ["bis_fnc_dynamicText", [0, -2] select isDedicated];
		[] spawn {sleep 2; [] call fnc_BE_updateProgressBar};

	};

	["Army XP", _pV, _cV] call AS_fnc_updateProgressBar;
};

fnc_BE_REQs = {
	private ["_reqs", "_result", "_multi"];

	_result = 0;
	_multi = 0;

	call {
		if (BE_currentStage == 0) exitWith {
			_reqs = BE_reqs_0;
			_multi = BE_DISC_ONE;
		};
		if (BE_currentStage == 1) exitWith {
			_reqs = BE_reqs_1;
			_multi = BE_DISC_TWO;
		};
		if (BE_currentStage == 2) exitWith {
			_reqs = BE_reqs_2;
			_multi = BE_DISC_THREE;
		};
	};

	{
		if ((call _x) select 0) then {_result = _result + 1};
	} forEach _reqs;

	_result * _multi
};
publicVariable "fnc_BE_REQs";

fnc_BE_calcPrice = {
	if (BE_currentStage >= 3) exitWith {
		0
	};
	private _price = BE_UPGRADE_PRICES select BE_currentStage;

	_price - ((call fnc_BE_REQs) min (BE_UPGRADE_DISCOUNT select BE_currentStage))
};
publicVariable "fnc_BE_calcPrice";

fnc_BE_upgrade = {
	private _price = call fnc_BE_calcPrice;

	AS_Pset("skillFIA", BE_current_FIA_Skill_Cap);
	AS_Pset("resourcesFIA", (AS_P("resourcesFIA") - _price) max 0);
	BE_currentStage = BE_currentStage + 1;
	[] call fnc_BE_refresh;
	BE_progressLock = false;

	switch (BE_currentStage) do {
		case 1: {
			[10,0] remoteExec ["AS_fnc_changeForeignSupport",2];
		};
		case 2: {
			[20,0] remoteExec ["AS_fnc_changeForeignSupport",2];
		};
		case 3: {
			[30,0] remoteExec ["AS_fnc_changeForeignSupport",2];
		};
		default {
		};
	};

	[] call fnc_BE_updateProgressBar;
};

fnc_BE_save = {
	private _result = [];

	_result pushBack BE_currentStage;
	_result pushBack BE_currentXP;
	_result pushBack BE_progressLock;
	diag_log format ["[AS] Time %1: BE_module saved, currentStage: %2 current XP %3 progressLock %4  result: %5 ", time, BE_currentStage, BE_currentXP, BE_progressLock, _result];
	_result
};

fnc_BE_load = {
	params [["_save",[]]];

	BE_currentStage = (_save select 0);
	BE_currentXP = (_save select 1);
  BE_progressLock = (_save select 2);
	diag_log format ["[AS] Time %1: BE_module loaded, currentStage: %2 current XP %3 progressLock %4 ", time, BE_currentStage, BE_currentXP, BE_progressLock];

	[] call fnc_BE_refresh;
};

fnc_BE_permission = {
	params ["_category", ["_value", 1], ["_vehicle", ""]];

	private _result = false;
	private _return = -1;

	switch (_category) do {
		case "skill": {
			if (BE_current_FIA_Skill_Cap > AS_P("skillFIA")) then {
				_result = true;
			};
		};
		case "FIA_garage": {
			if (BE_current_FIA_GarageCap > (count AS_P("vehiclesInGarage"))) then {
				_result = true;
			};
		};
		case "pers_garage": {
			if (BE_current_Pers_GarageCap > (count ([player, "garage"] call AS_players_fnc_get))) then {
				_result = true;
			};
		};
		case "vehicle": {
			_result = true;
			if ((_value in BE_class_MBT) && ("MBT" in BE_current_Vehicle_Restriction)) exitWith {_result = false;};
			if ((_value in BE_class_APC) && ("APC" in BE_current_Vehicle_Restriction)) exitWith {_result = false;};
			if ((_value in BE_class_Heli) && ("Heli" in BE_current_Vehicle_Restriction)) exitWith {_result = false;};

			private _vehClass = getText (configFile >> "CfgVehicles" >> _value >> "vehicleClass");
			if (((tolowerANSI _vehClass find "heli" >= 0) || (_vehClass == "Air")) && ("Heli" in BE_current_Vehicle_Restriction)) exitWith {_result = false};

			/*
			//Capture vehicle rewards
			//This is handled in getin eventhandler
			if (!(_vehicle getVariable ["BE_mil_veh", false]) && (_value in BE_mil_vehicles)) then {
				call {
					if (_vehicle in BE_class_MBT) exitWith {["cap_arm"] remoteExec ["fnc_BE_XP", 2]};
					if (_vehicle in BE_class_APC) exitWith {["cap_arm"] remoteExec ["fnc_BE_XP", 2]};
					if (_vehicle in BE_class_MRAP) exitWith {["cap_veh"] remoteExec ["fnc_BE_XP", 2]};
				};
			};*/
		};
		case "HR": {
				_result = true;
				_return = BE_current_FIA_HR_Cap;


		};
		case "camp": {
			if (BE_current_FIA_Camp_Cap > (count (["camp", "FIA"] call AS_location_fnc_TS))) then {
				_result = true;
			};
		};
		case "RB": {
			if (BE_current_FIA_RB_Cap > (count (["roadblock", "FIA"] call AS_location_fnc_TS))) then {
				_result = true;
			};
		};
		case "WP": {
			if (BE_current_FIA_WP_Cap > (count (["watchpost", "FIA"] call AS_location_fnc_TS))) then {
				_result = true;
			};
		};

		default {
			diag_log format ["Error in BE module permission - param 1:%1; param 2: %2", _category, _value];
		};
	};

	[_result, _return] select (_return > -1);
};

publicVariable "fnc_BE_permission";

fnc_BE_checkVehicle = {
	params ["_vehicle", "_type"];

	private _result = false;
	private _typeOfVehicle = typeOf _vehicle;

	if (_type == "in") then {
		if (_vehicle getVariable ["BE_mil_veh", false]) then {
			_result = true;
		};
	};

	if (_type == "out") then {
		if (_typeOfVehicle in BE_mil_vehicles) then {
			_vehicle setVariable ["BE_mil_veh", true, true];
		};
	};

	_result
};

publicVariable "fnc_BE_checkVehicle";

fnc_BE_broadcast = {
	params ["_type", "_reqs", "_data", "_bool", "_str", "_boolStr"];
	private _pI = [];

	[] call fnc_BE_refresh;

	if (_type == "progress") then {

		call {
			if (BE_currentStage == 0) exitWith {
				_reqs = BE_reqs_0;
			};
			if (BE_currentStage == 1) exitWith {
				_reqs = BE_reqs_1;
			};
			if (BE_currentStage == 2) exitWith {
				_reqs = BE_reqs_2;
			};
		};

		{
			_data = call _x;
			_bool = _data select 0;
			_str = _data select 1;

			_boolStr = ["not satisfied", "satisfied"] select _bool, true;
			_pI pushBack (format ["Requirement: %1 \nStatus: %2", _str, _boolStr]);
		} forEach _reqs;
	};

	if (_type == "restrictions") then {
		_pI pushBackUnique (format ["Current FIA skill cap: %1", BE_current_FIA_Skill_Cap]);
		_pI pushBackUnique (format ["Current FIA garage size: %1", BE_current_FIA_GarageCap]);
		_pI pushBackUnique (format ["Current personal garage size: %1", BE_current_Pers_GarageCap]);
		_pI pushBackUnique (format ["Currently restricted vehicles: %1", BE_current_Vehicle_Restriction]);
		_pI pushBackUnique (format ["Current FIA manpower cap: %1", BE_current_FIA_HR_Cap]);
		_pI pushBackUnique (format ["Current FIA camp cap: %1", BE_current_FIA_Camp_Cap]);
		_pI pushBackUnique (format ["Current FIA roadblock cap: %1", BE_current_FIA_RB_Cap]);
		_pI pushBackUnique (format ["Current FIA watchpost cap: %1", BE_current_FIA_WP_Cap]);
	};

	[petros,"BE",_pI] remoteExec ["AS_fnc_localCommunication",AS_commander];
};

fnc_BE_C_TER = {
	private _types = ['airfield'];
	private _str = "At least 1 airport under your control";
	call {
		if (BE_currentStage == 1) exitWith {
			_types pushBack "base";
			_str = "At least 1 base/airport under your control";
		};
		if (BE_currentStage == 0) exitWith {
			_types append ["outpost", "outpostAA"];
			_str = "At least 1 outpost/base/airport under your control";
		};
	};

	[(count ([_types, "FIA"] call AS_location_fnc_TS) > 0), _str]
};

fnc_BE_C_MTN = {
	[(count (["hillAA", "FIA"] call AS_location_fnc_TS) > 0), "Have cleared at least 1 CSAT hilltop"]
};

fnc_BE_C_HR = {
	private _minVal = 150;
	call {
		if (BE_currentStage == 1) exitWith {
			_minVal = 100;
		};
		if (BE_currentStage == 0) exitWith {
			_minVal = 50;
		};
	};
	private _str = format ["Have at least %1 HR", _minVal];

	[AS_P("hr") >= _minVal, _str]
};

fnc_BE_C_VEH = {
	private _type = BE_class_MBT;
	private _minVal = 1;
	private _result = 0;
	private _str = "Captured at least 1 MBT in garage";

	call {
		if (BE_currentStage == 1) exitWith {
			_type = BE_class_APC;
			_minVal = 2;
			_str = "Captured at least 2 APCs in garage";
		};
		if (BE_currentStage == 0) exitWith {
			_type = BE_class_MRAP;
			_minVal = 2;
			_str = "Captured at least 2 MRAPs in garage";
		};
	};

	{
		if (_x in _type) then {_result = _result + 1};
	} forEach AS_P("vehiclesInGarage");

	[(_result >= _minVal), _str]
};

BE_reqs_0 = [fnc_BE_C_TER, fnc_BE_C_HR, fnc_BE_C_MTN, fnc_BE_C_VEH];
BE_reqs_1 = [fnc_BE_C_TER, fnc_BE_C_HR, fnc_BE_C_MTN, fnc_BE_C_VEH];
BE_reqs_2 = [fnc_BE_C_TER, fnc_BE_C_HR, fnc_BE_C_MTN, fnc_BE_C_VEH];
publicVariable "BE_reqs_0"; //TODO: check these, for necessity and for JIPs
publicVariable "BE_reqs_1";
publicVariable "BE_reqs_2";
