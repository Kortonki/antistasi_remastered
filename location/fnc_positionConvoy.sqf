private _convoyMarker = format ["%1_convoy", _this];
//If there's a convoy start marker for the location, use it instead
//These are not saved as locations to dictionary to be able to update legacy saves to use better spawning for convoys
//Use invisible markers in the editor with "_convoy" after the marker name to set convoy spawn positions
if (!((getMarkerpos _convoyMarker) isEqualto [0,0,0])) exitWith {
  (getMarkerpos _convoyMarker)
};

[_this,"position"] call AS_location_fnc_get
