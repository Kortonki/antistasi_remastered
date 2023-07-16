params ["_killer"];

if (!(["AAF_killFIA_date"] call AS_stats_fnc_exists) and {_killer call AS_fnc_getSide == "AAF"}) then {
  ["AAF_killFIA_date", date] call AS_stats_fnc_set;
};

if (!(["CSAT_killFIA_date"] call AS_stats_fnc_exists) and {_killer call AS_fnc_getSide == "CSAT"}) then {
  ["CSAT_killFIA_date", date] call AS_stats_fnc_set;
};

if (!(["FIRSTBLOOD_date"] call AS_stats_fnc_exists) and {_killer call AS_fnc_getSide in ["AAF", "CSAT"]}) then {
  ["FIRSTBLOOD_date", date] call AS_stats_fnc_set;
  ["FIRSTBLOOD_side", _killer call AS_fnc_getSide] call AS_stats_fnc_set;


  private _msg = format [localize "STR_msg_firstblood_FIA_AAFCSAT",

  worldName,
  ["AAF", "name"] call AS_fnc_getEntity,
  ["FIA", "name"] call AS_fnc_getEntity,
  [_killer call AS_fnc_getSide, "name"] call AS_fnc_getEntity,
  ["FIA", "shortname"] call AS_fnc_getEntity,
  ["NATO", "name"] call AS_fnc_getEntity
  ];

  [_msg, 30, "", true] remoteExec ["AS_fnc_globalMessage", 2];

  [20, 0] remoteExec ["AS_fnc_changeForeignSupport", 2];
};
