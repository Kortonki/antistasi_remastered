params ["_vehClass", "_locationType"];

round(((_vehClass call AS_AAFarsenal_fnc_countAvailable) / (_vehClass call AS_AAFarsenal_fnc_max)) * ([_vehClass, _locationType] call AS_location_fnc_vehicles))
