if ([position player, nil] call AS_fnc_enemiesNearby) exitWith {
	Hint "You cannot recruit units with enemies nearby";
};

disableSerialization;

createDialog "AS_RecruitUnit";

[] call AS_fnc_UI_recruitUnit_updateList;
