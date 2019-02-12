// the maximum number of vehicles of a given category.
switch _this do {
    case "planes": {4*(count (["airfield","AAF"] call AS_location_fnc_TS))};
    case "helis_armed": {4*(count (["airfield","AAF"] call AS_location_fnc_TS))};
    case "helis_transport": {8*(count (["airfield","AAF"] call AS_location_fnc_TS))};
    case "tanks": {4*(count (["base","AAF"] call AS_location_fnc_TS))};
    case "boats": {4*(count (["seaport","AAF"] call AS_location_fnc_TS))};
    case "apcs":  {4*(count (["base","AAF"] call AS_location_fnc_TS))};
    case "cars_armed":  {8*(count (["base","AAF"] call AS_location_fnc_TS)) + 2*(count (["outpost","AAF"] call AS_location_fnc_TS))};
    case "cars_transport":  {3+8*(count (["base","AAF"] call AS_location_fnc_TS)) + 2*(count (["outpost","AAF"] call AS_location_fnc_TS))};
    case "trucks": {3 + 4*(count (["base","AAF"] call AS_location_fnc_TS)) + (count (["outpost","AAF"] call AS_location_fnc_TS))};
}