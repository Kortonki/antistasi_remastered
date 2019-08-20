#include "../macros.hpp"
params ["_newCommander"];
//Workaround to choosecommander dialog bug
if (!isServer) exitWith {[_newCommander] remoteExec ["AS_fnc_setCommander", 2]};

AS_SERVER_ONLY("AS_fnc_setCommander");



private _hadCommander = not isNull AS_commander;
private _hcGroups = allGroups select {_x getVariable ["isHCgroup", false]};
if _hadCommander then {
    {
        AS_commander hcRemoveGroup _x;
    } forEach _hcGroups;

    AS_commander synchronizeObjectsRemove [HC_comandante];
    HC_comandante synchronizeObjectsRemove [AS_commander];
};

AS_commander = _newCommander;
publicVariable "AS_commander";
[group AS_commander, AS_commander] remoteExec ["selectLeader", AS_commander];

AS_commander synchronizeObjectsAdd [HC_comandante];
HC_comandante synchronizeObjectsAdd [AS_commander];

[HC_comandante] execVM '\A3\modules_f\HC\data\scripts\hc.sqf';

{
    AS_commander hcSetGroup [_x];
} forEach _hcGroups;
