#include "../macros.hpp"
AS_SERVER_ONLY("fnc_collectDroppedEquipment");
params ["_position", "_size", "_box"]; //_box appears to be caja for all the calls
{
    ([_x, true] call AS_fnc_getBoxArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", "_remains"];
    [_box, _cargo_w, _cargo_m, _cargo_i, _cargo_b, true] call AS_fnc_populateBox;
    [cajaVeh, _remains] call AS_fnc_addMagazineRemains;
    [_x] RemoteExecCall ["deleteVehicle", _x];
} forEach nearestObjects [_position, ["WeaponHolderSimulated", "WeaponHolder"], _size];

{
    if not (alive _x) then {
        ([_x, true] call AS_fnc_getUnitArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", "_remains"];
        [_box, _cargo_w, _cargo_m, _cargo_i, _cargo_b, true] call AS_fnc_populateBox;
        [cajaVeh, _remains] call AS_fnc_addMagazineRemains;
        _x call AS_fnc_emptyUnit;
    };
} forEach (_position nearObjects ["Man", _size]);
