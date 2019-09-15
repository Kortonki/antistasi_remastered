params ["_unit"];

if (_unit call AS_fnc_isDog) exitWith {};

_unit setVariable ["surrendered",true, true];

waitUntil {sleep 2; !(_unit call AS_medical_fnc_isUnconscious)};

sleep 2;

if (not(alive _unit)) exitWith {}; //Instadeath after surrender -> no effect

private _side = _unit call AS_fnc_getSide;
call {
	if (_side == "AAF") exitWith {
		[[_unit,"interrogate"],"AS_fnc_addAction"] call BIS_fnc_MP;
		[[_unit,"offerToJoin"],"AS_fnc_addAction"] call BIS_fnc_MP;
		[0,10] remoteExec ["AS_fnc_changeFIAmoney",2];
		[-2,0,getPos _unit] remoteExec ["AS_fnc_changeCitySupport",2];
		[-(typeOf _unit call AS_fnc_getCost)] remoteExec ["AS_fnc_changeAAFmoney",2];
	};
	if (_side == "CSAT") exitWith {
		[-2,2,getPos _unit] remoteExec ["AS_fnc_changeCitySupport",2];
		[1,0] remoteExec ["AS_fnc_changeForeignSupport",2];
	};
};



//_unit allowDamage false; //Unnecessary?
[_unit] orderGetin false;
_unit stop true;
_unit disableAI "MOVE";
_unit disableAI "AUTOTARGET";
_unit disableAI "TARGET";

//_unit disableAI "FSM";
_unit setUnitPos "UP";

// create box and add all content to it.
private _box = "Box_IND_Wps_F" createVehicle position _unit;
private _cargoArray = [_unit] call AS_fnc_getUnitArsenal;
[_box, _cargoArray select 0, _cargoArray select 1, _cargoArray select 2, _cargoArray select 3, false, true] call AS_fnc_populateBox;
[_box, _cargoArray select 4] call AS_fnc_addMagazineRemains;

_unit call AS_fnc_emptyUnit;

[_unit, true] remoteExecCall ["setCaptive", _unit];

if (alive _unit) then
	{
	waitUntil {sleep 2; !(_unit call AS_medical_fnc_isUnconscious)};
	[_unit, true] remoteExecCall ["setCaptive", _unit];
	_unit setUnitPos "UP";

	//_unit disableAI "ANIM";
	//_unit switchMove ""; //removed this for freezing issuses
	//_unit playMoveNow "AmovPercMstpSnonWnonDnon_AmovPercMstpSsurWnonDnon";
	_unit playActionNow "Surrender";
	_unit disableAI "MOVE";
	sleep 2;
	};
_unit setSpeaker "NoVoice";
_unit addEventHandler ["HandleDamage", {
	_unit = _this select 0;
	_unit enableAI "MOVE";
	//if (!simulationEnabled _unit) then {_unit enableSimulationGlobal true};
}];
if (_unit getVariable ["OPFORSpawn",false]) then {_unit setVariable ["OPFORSpawn",nil,true]};
[_unit] remoteExec ["AS_fnc_activateCleanup",2];
[_box] remoteExec ["AS_fnc_activateCleanup",2];
//_unit allowDamage true;  //unnecessary?
//_unit enableSimulationGlobal false;
