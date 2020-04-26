params ["_killer"];

//Story related tags

if (!(["AAF_killNATO_date"] call AS_stats_fnc_exists) and {_killer call AS_fnc_getSide == "AAF"}) then {
  ["AAF_killFIA_date", date] call AS_stats_fnc_set;
};

if (!(["CSAT_killNATO_date"] call AS_stats_fnc_exists) and {_killer call AS_fnc_getSide == "CSAT"}) then {
  ["CSAT_killFIA_date", date] call AS_stats_fnc_set;
};

if (!(["FIRSTBLOOD_date"] call AS_stats_fnc_exists) and {_killer call AS_fnc_getSide in ["AAF", "CSAT"]}) then {
  ["FIRSTBLOOD_date", date] call AS_stats_fnc_set;
  ["FIRSTBLOOD_side", _killer call AS_fnc_getSide] call AS_stats_fnc_set;
};
