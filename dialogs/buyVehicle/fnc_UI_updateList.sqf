// updates the left list and right text field
disableSerialization;
private _cbo = ((findDisplay 1602) displayCtrl 0);
lbCLear _cbo;

private _buyable = (["FIA", "land_vehicles"] call AS_fnc_getEntity) + (["FIA", "air_vehicles"] call AS_fnc_getEntity) + (["FIA", "water_vehicles"] call AS_fnc_getEntity);
_buyable append (["FIA", "static_mg"] call AS_fnc_getEntity);
_buyable append (["FIA", "static_at"] call AS_fnc_getEntity);
_buyable append (["FIA", "static_aa"] call AS_fnc_getEntity);
_buyable append (["FIA", "static_mortar"] call AS_fnc_getEntity);

{
    _cbo lbAdd (getText(configFile >> "cfgVehicles" >> _x >> "displayName"));
    private _picture = (getText(configFile >> "cfgVehicles" >> _x >> "picture"));
    _cbo lbSetPicture[(lbSize _cbo)-1, _picture];

    _cbo lbSetData[(lbSize _cbo)-1, _x];
} forEach _buyable;

_cbo lbSetCurSel 0;
call AS_fnc_UI_buyVehicle_updateVehicleData;
