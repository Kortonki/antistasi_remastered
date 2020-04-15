disableSerialization;
private _id = lbCurSel 0;
private _squadName = lbData [0, _id];

if (_squadName != "") then {
   if (player != AS_commander) exitWith {hint "Only the commander has access to this function"};
   if (!([player] call AS_fnc_hasRadio)) exitWith {hint "You need a radio in your inventory to be able to give orders to other squads"};
    [_squadName] remoteExec ["AS_fnc_recruitFIAsquad", 2];
} else {
    hint "no squad selected";
};
