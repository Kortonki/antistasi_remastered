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
    case "fia_hq": {_markerType = "hd_flag";
        if (!(isNil "AS_server_side_variables_initialized")) then {
          _locationName = format ["%1 HQ", ["FIA", "shortname"] call AS_fnc_getEntity];
        } else {
          _locationName = "FIA HQ";
        };
    };
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

        //Check if a markers is already near a mine. Do it this way instead of deleting, adding to avoid network traffic
        //Todo: Figure out a more optimized way
        //Markers attached to mines - problem is they're not shown on load game when mines not spawned. Maybe via location init?

        {
          private _pos = _x select 1;

          private _nearest = [allMapMarkers select {getMarkerType _x == "hd_dot"}, _pos] call BIS_Fnc_nearestPosition;

          if (_nearest distance2d _pos > 0.5)
          then {
            private _mrk2 = createMarkerLocal [format ["%1_%2", _location, call AS_fnc_uniqueID], _pos, 1];
            _mrk2 setMarkerSizeLocal [0.5, 0.5];
            _mrk2 setMarkerTypeLocal "hd_dot";
            //This will broadcast the marker to clients, the former are ok as local to optimise network traffic
            _mrk2 setMarkerColor "ColorBlue";
          };

        } foreach  ([_location, "mines"] call AS_location_fnc_get);

        //Marker deletion is at fnc_mineFieldCheck (Look for the nearest marker)


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

  if  (_type in ["resource", "factory"]) then {
    _mrk setMarkerText format ["%1", _locationName];
  } else {
    _mrk setMarkerText "";
  };

};
