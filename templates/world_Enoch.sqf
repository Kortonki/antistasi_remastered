
// sagonisi and hill12 are excluded for an unknown reason.
// todo: document why these are excluded.
//the last element is EXCLUDED cities from the map
//Params
// 0: exclude below this size
// 1: minimun radius for a city
// 2: exclude these cities
[290,290, 1000, []] call AS_location_fnc_addCities; //This is 200 so Polana is recognized (as a town)

// These have to be names in the map. Be careful on putting names that are also cities (consider excludeing them above)
private _hillsAA = [];
// 1st param is the min size of the hill, used e.g. to detect when it is cleared. The marker is re-sized to be of this size.
// 2nd param is list of excluded hills. Magos is excluded because there is a base there.
// 3rd param is a list of hill names that are spawned with AA. (i.e. type "hillAA")
[50, ["Skala", "Damborg", "Swarog", "Rodzanika", "Kopa", "Piorun", "Sowa"], _hillsAA] call AS_location_fnc_addHills;

// These have to be marker names.
seaMarkers = [];
{_x setMarkerAlpha 0} forEach seaMarkers;

// you can modify AS_antenasTypes


AS_antenasPos_alive = [[2382.54,11479.9,0], [7866.52,10102.7,0], [7775.75,10081.1,0], [3831.21,1827.58,0], [8895.02,2049.55,0]];

AS_bankPositions = [[1730.61,7320.9,0]];//same as RT for Bank buildings, select the biggest buildings in your island, and make a DB with their positions.
/*
private _center = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");
private _buildings = nearestObjects [_center,AS_antenasTypes, 16000];
private _positions = [];
{_positions pushBack (getPos _x)} forEach _buildings;
copytoclipboard str _positions;
*/
