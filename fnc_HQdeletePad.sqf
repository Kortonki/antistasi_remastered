#include "macros.hpp"
AS_SERVER_ONLY("fnc_hq_deletePad.sqf");

if not(isNil "vehiclePad") then {
    AS_permanent_HQplacements = AS_permanent_HQplacements - [vehiclePad];
    deleteVehicle vehiclePad;
    publicVariable "vehiclePad";

};
AS_Sset("AS_vehicleOrientation", 0);
