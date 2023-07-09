// Updates location's public marker, creating a new marker if needed.
#include "../macros.hpp"
AS_SERVER_ONLY("AS_location_fnc_updateMarker");
params ["_location"];
private _type = (_location call AS_location_fnc_type);
private _position = (_location call AS_location_fnc_position);
private _side = (_location call AS_location_fnc_side);

private _mrkName = format ["Dum%1", _location];
private _markerType = "";
private _locationName = "";
switch (_type) do {
    case "fia_hq": {_markerType = "hd_flag"; _locationName = format ["%1 HQ", ["FIA", "shortname"] call AS_fnc_getEntity]};
    case "city": {_markerType = "mil_flag"; _locationName = ""};
    case "powerplant": {_markerType = "loc_power"; _locationName = "Power Plant"};
    case "airfield": {
        _locationName = "Airfield";
        if (_side == "FIA") then {
            _markerType = "flag_NATO";
        } else {
            _markerType = "flag_AAF";
        };
    };
    case "base": {
        _locationName = "Military Base";
        if (_side == "FIA") then {
            _markerType = "flag_NATO";
        } else {
            _markerType = "flag_AAF";
        };
    };
    case "powerplant": {_markerType = "loc_power"; _locationName = "Base"};
    case "resource": {_markerType = "mil_marker"; _locationName = "Resource"};
    case "factory": {_markerType = "mil_marker"; _locationName = "Factory"};
    case "outpost": {_markerType = "loc_ruin"; _locationName = "Outpost"};
    case "outpostAA": {_markerType = "loc_ruin"; _locationName = "Outpost AA"};
    case "roadblock": {_markerType = "loc_ruin"; _locationName = "Roadblock"};
    case "watchpost": {_markerType = "loc_ruin"; _locationName = "Watchpost"};
    case "camp": {_markerType = "hd_flag"; _locationName = ([_location,"name"] call AS_location_fnc_get)};
    case "seaport": {_markerType = "b_naval"; _locationName = "Sea Port"};
    case "hill": {_markerType = "loc_ruin"; _locationName = "Hill"};
    case "hillAA": {_markerType = "loc_ruin"; _locationName = "AA"};
    case "minefield": {_markerType = "hd_warning"; _locationName = "Minefield"};
    default {diag_log format ["[AS] Error: location_updateMarker with undefined type '%1'", _type]};
};

private _mrk = "";
// checks if marker exists
if (getMarkerColor _mrkName == "") then {
    _mrk = createMarker [_mrkName, _position];
    _mrk setMarkerShape "ICON";
} else {
    _mrk = _mrkName;
};
_mrk setMarkerPos _position;
_mrk setMarkerType _markerType;
_mrk setMarkerAlpha 1;

if (_side == "FIA") then {
    if (_type != "minefield") then {
        _mrk setMarkerText format ["%1: %2", _locationName, count (_location call AS_location_fnc_garrison)];
    } else {
        _mrk setMarkerText format ["%1: %2", _locationName, count ([_location,"mines"] call AS_location_fnc_get)];
    };
    _mrk setMarkerColor "ColorBLUFOR";
};
if (_side == "NATO") then {
    _mrk setMarkerText ("BLUFOR " + _locationName);
    _mrk setMarkerColor "ColorBLUFOR";
};
if (_side == "AAF") then {
    // roadblocks are hidden
    if  (_type in ["resource", "factory"]) then {
      _mrk setMarkerText format ["%1", _locationName];
    } else {
      _mrk setMarkerText "";
    };
    if (_type == "roadblock") then {
        _mrk setMarkerAlpha 0;
    };
    if (_type == "minefield") then {
        if (!([_location,"found"] call AS_location_fnc_get)) then {
            _mrk setMarkerAlpha 0;
        };
    };
    _mrk setMarkerColor "ColorGUER";
    // AAF does not show names
};

if (_side == "CSAT") then {
  _mrk setMarkerColor "ColorEAST";

  if (_type == "hillAA") then {
    _mrk setMarkerText format ["%1", _locationName];
  };

  if (_type == "hill") then {
    _mrk setMarkerText format ["%1", _locationName];
  };

};

if (_side == "Neutral") then {
  _mrk setMarkerColor "ColorGrey";

};
