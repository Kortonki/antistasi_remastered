
// sagonisi and hill12 are excluded for an unknown reason.
// todo: document why these are excluded.
//the last element is EXCLUDED cities from the map
[200,300,["Joutkallio","Korpi","Kivimäki","Kortesoja","Mäkelä","Martikkalankylä","Virpimäki","Huhtamäki", "Hipinmäki"]] call AS_location_fnc_addCities;

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

AS_antenasTypes = ["Land_TTowerBig_1_F","Land_TTowerBig_2_F", "Land_Com_tower_ep1", "Land_Telek1", "Land_Vysilac_vez",
"Land_TTowerBig_1_ruins_F","Land_TTowerBig_2_ruins_F", "Land_Telek1_ruins", "Land_Com_tower_ruins_EP1"];
AS_antenasPos_alive = [[5554.12,2674.38,1.7778],[976.455,4991.78,1.31231],[3849.34,7631.38,1.79234],[7729.12,6573.82,1.11914]];

AS_bankPositions = [[6123.48,6921.61,2.25169]];//same as RT for Bank buildings, select the biggest buildings in your island, and make a DB with their positions.
/*
private _center = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");
private _buildings = nearestObjects [_center,AS_antenasTypes, 16000];
private _positions = [];
{_positions pushBack (getPos _x)} forEach _buildings;
copytoclipboard str _positions;
*/
