#include "macros.hpp"
AS_SERVER_ONLY("fnc_HQdeployPad.sqf");
// _obj is the paint
params ["_obj"];



private _pos = position _obj;
if ((_pos distance fuego) > 100) exitWith {
    [petros,"hint","Too far from HQ."] remoteExec ["AS_fnc_localCommunication",AS_commander];
    deleteVehicle _obj;
};

call AS_fnc_HQdeletePad;

AS_Sset("AS_vehicleOrientation", [_caller, _obj] call BIS_fnc_dirTo);
vehiclePad = createVehicle ["Land_JumpTarget_F", _pos, [], 0, "CAN_COLLIDE"];
publicVariable "vehiclePad";
AS_permanent_HQplacements pushBack vehiclePad;

deleteVehicle _obj;
