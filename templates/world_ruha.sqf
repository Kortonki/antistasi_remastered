
// sagonisi and hill12 are excluded for an unknown reason.
// todo: document why these are excluded.
//the last element is EXCLUDED cities from the map
[200,300, 300,["Joutkallio","Korpi","Kivimäki","Kortesoja", "Kumuri", "Mäkelä","Martikkalankylä","Virpimäki","Huhtamäki", "Hipinmäki", "Metsälä office", "Järvelä", "Länsikylä sawmill", "Tervasmäki", "Varjo Hotel"]] call AS_location_fnc_addCities;

// These have to be names in the map. Be careful on putting names that are also cities (consider excludeing them above)
private _hillsAA = ["Joutkallio", "Korpi"];
// 1st param is the min size of the hill, used e.g. to detect when it is cleared. The marker is re-sized to be of this size.
// 2nd param is list of excluded hills. Magos is excluded because there is a base there.
// 3rd param is a list of hill names that are spawned with AA. (i.e. type "hillAA")
[50, [], _hillsAA] call AS_location_fnc_addHills;

// These have to be marker names.
seaMarkers = [];
{_x setMarkerAlpha 0} forEach seaMarkers;

// you can modify AS_antenasTypes

AS_antenasPos_alive = [[5554.12,2674.38,1.7778],[976.455,4991.78,1.31231],[3849.34,7631.38,1.79234],[7729.12,6573.82,1.11914]];

AS_bankPositions = [[6123.48,6921.61,2.25169]];//same as RT for Bank buildings, select the biggest buildings in your island, and make a DB with their positions.
/*
private _center = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");
private _buildings = nearestObjects [_center,AS_antenasTypes, 16000];
private _positions = [];
{_positions pushBack (getPos _x)} forEach _buildings;
copytoclipboard str _positions;
*/

AS_small_bunker_type = "Land_BagBunker_01_small_green_F";
AS_big_bunker_type = "Land_BagBunker_01_large_green_F";
AS_sandbag_type_round = "Land_BagFence_01_round_green_F";
AS_camonet_type = "CamoNet_BLUFOR_big_F";
AS_h_barrier_type = "Land_HBarrier_01_line_5_green_F";

AS_RadioCoverage = 3500;
