
// sagonisi and hill12 are excluded for an unknown reason.
// todo: document why these are excluded.
//the last element is EXCLUDED cities from the map
[200,300,[]] call AS_location_fnc_addCities;

// These have to be names in the map. Be careful on putting names that are also cities (consider excludeing them above)
private _hillsAA = [];
// 1st param is the min size of the hill, used e.g. to detect when it is cleared. The marker is re-sized to be of this size.
// 2nd param is list of excluded hills. Magos is excluded because there is a base there.
// 3rd param is a list of hill names that are spawned with AA. (i.e. type "hillAA")
[50, [], _hillsAA] call AS_location_fnc_addHills;

// These have to be marker names.
seaMarkers = [];
{_x setMarkerAlpha 0} forEach seaMarkers;

// you can modify AS_antenasTypes

AS_antenasTypes = ["Land_TTowerBig_1_F","Land_TTowerBig_2_F", "Land_Com_tower_ep1", "Land_Telek1", "Land_Vysilac_vez",
"Land_TTowerBig_1_ruins_F","Land_TTowerBig_2_ruins_F", "Land_Telek1_ruins", "Land_Com_tower_ruins_EP1"];
AS_antenasPos_alive = [[3061.42,15606.4,0],[8928.65,14476.6,0],[951.382,10956.3,-3.8147e-006],[8306.09,9300.39,-9.53674e-007],[13656.5,10723.2,-1.90735e-006],[5276.82,6160.9,9.53674e-007],[13520.3,5436.57,-9.53674e-007],[9458,1749.92,0]];

AS_bankPositions = [];//same as RT for Bank buildings, select the biggest buildings in your island, and make a DB with their positions.
/*
private _center = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");
private _buildings = nearestObjects [_center,AS_antenasTypes, 16000];
private _positions = [];
{_positions pushBack (getPos _x)} forEach _buildings;
copytoclipboard str _positions;
*/

AS_small_bunker_type = "Land_BagBunker_Small_F";
AS_big_bunker_type = "Land_BagBunker_Large_F";
AS_sandbag_type_round = "Land_BagFence_Round_F";
AS_camonet_type = "CamoNet_BLUFOR_big_F";
AS_h_barrier_type = "Land_HBarrier_5_F";
