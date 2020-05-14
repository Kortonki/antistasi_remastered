//Everything that needs to be checked for global messages etc. goes here. Nothing urgent, stuff that needs to be cheked every update

//AAF Casualty caps

if (!("AAF_100casualties_date" call AS_stats_fnc_exists) and {(["AAF", "casualties"] call AS_stats_fnc_get) >= 100}) then {
  ["AAF_100casualties_date", date] call AS_stats_fnc_set;

  private _msg = format [localize "STR_msg_AAF100casualties" , worldName,
    ["AAF", "shortname"] call AS_fnc_getEntity,
    ["FIA", "shortname"] call AS_fnc_getEntity,
    ["FIA", "casualties"] call AS_stats_fnc_get
    ];

    [_msg, 20, "AAFcasualties"] remoteExec ["AS_fnc_globalMessage", 2];
};

if (!("AAF_250casualties_date" call AS_stats_fnc_exists) and {(["AAF", "casualties"] call AS_stats_fnc_get) >= 250 and {(["FIA", "casualties"] call AS_stats_fnc_get) >= 250}}) then {
  ["AAF_250casualties_date", date] call AS_stats_fnc_set;

  private _msg = format [localize "STR_msg_AAF250casualties_FIAhigh" , worldName,
    ["AAF", "shortname"] call AS_fnc_getEntity,
    ["FIA", "shortname"] call AS_fnc_getEntity,
    ["FIA", "casualties"] call AS_stats_fnc_get,
    ["CSAT", "shortname"] call AS_fnc_getEntity
    ];

    [_msg, 20, "AAFcasualties"] remoteExec ["AS_fnc_globalMessage", 2];

    [0, -20] remoteExec ["AS_fnc_changeForeignSupport", 2];

};

if (!("AAF_250casualties_date" call AS_stats_fnc_exists) and {(["AAF", "casualties"] call AS_stats_fnc_get) >= 250 and {(["FIA", "casualties"] call AS_stats_fnc_get) < 250}}) then {
  ["AAF_250casualties_date", date] call AS_stats_fnc_set;

  private _msg = format [localize "STR_msg_AAF250casualties_FIAlow" , worldName,
    ["AAF", "shortname"] call AS_fnc_getEntity,
    ["FIA", "shortname"] call AS_fnc_getEntity,
    ["FIA", "casualties"] call AS_stats_fnc_get,
    ["CSAT", "shortname"] call AS_fnc_getEntity
    ];

    [_msg, 20, "AAFcasualties"] remoteExec ["AS_fnc_globalMessage", 2];

    [0, 20] remoteExec ["AS_fnc_changeForeignSupport", 2];

};

if (!("AAF_500casualties_date" call AS_stats_fnc_exists) and {(["AAF", "casualties"] call AS_stats_fnc_get) >= 500}) then {
  ["AAF_500casualties_date", date] call AS_stats_fnc_set;

  private _msg = format [localize "STR_msg_AAF100casualties" , worldName,
    ["AAF", "shortname"] call AS_fnc_getEntity,
    ["FIA", "shortname"] call AS_fnc_getEntity,
    ["FIA", "casualties"] call AS_stats_fnc_get
    ];

    [_msg, 20, "AAFcasualties"] remoteExec ["AS_fnc_globalMessage", 2];
};

if (!("AAF_1000casualties_date" call AS_stats_fnc_exists) and {(["AAF", "casualties"] call AS_stats_fnc_get) >= 1000}) then {
  ["AAF_1000casualties_date", date] call AS_stats_fnc_set;

  private _msg = format [localize "STR_msg_AAF100casualties" , worldName,
    ["AAF", "shortname"] call AS_fnc_getEntity,
    ["FIA", "shortname"] call AS_fnc_getEntity,
    ["FIA", "casualties"] call AS_stats_fnc_get,
    ["CSAT", "shortname"] call AS_fnc_getEntity
    ];


    [_msg, 20, "AAFcasualties"] remoteExec ["AS_fnc_globalMessage", 2];
};

//AAF new vehicles checks

if (!("AAF_firstHelis_date" call AS_stats_fnc_exists) and {"helis_transport" call AS_AAFarsenal_fnc_count > 0}) then {
  ["AAF_firstHelis_date", date] call AS_stats_fnc_set;

  private _msg = format [localize "STR_msg_AAFfirstHelis" , worldName,
    ["AAF", "shortname"] call AS_fnc_getEntity,
    ["FIA", "name"] call AS_fnc_getEntity
    ];


    [_msg, 20, "AAFfirstHelis"] remoteExec ["AS_fnc_globalMessage", 2];
};

if (!("AAF_firstArmedHelis_date" call AS_stats_fnc_exists) and {"helis_armed" call AS_AAFarsenal_fnc_count > 0}) then {
  ["AAF_firstArmedHelis_date", date] call AS_stats_fnc_set;

  private _msg = format [localize "STR_msg_AAFfirstArmedHelis" , worldName,
    ["AAF", "shortname"] call AS_fnc_getEntity,
    ["FIA", "shortname"] call AS_fnc_getEntity
    ];

    [_msg, 20, "AAFfirstHelisArmed"] remoteExec ["AS_fnc_globalMessage", 2];
};

if (!("AAF_firstTanks_date" call AS_stats_fnc_exists) and {"tanks" call AS_AAFarsenal_fnc_count > 0}) then {
  ["AAF_firstTanks_date", date] call AS_stats_fnc_set;

  private _msg = format [localize "STR_msg_AAFfirstTanks" , worldName,
    ["AAF", "shortname"] call AS_fnc_getEntity
    ];


    [_msg, 20, "AAFfirstTanks"] remoteExec ["AS_fnc_globalMessage", 2];
};

if (!("AAF_firstPlanes_date" call AS_stats_fnc_exists) and {"planes" call AS_AAFarsenal_fnc_count > 0}) then {
  ["AAF_firstPlanes_date", date] call AS_stats_fnc_set;

  private _msg = format [localize "STR_msg_AAFfirstPlanes" , worldName,
    ["AAF", "shortname"] call AS_fnc_getEntity,
    ["FIA", "shortname"] call AS_fnc_getEntity
    ];


    [_msg, 20, "AAFfirstPlanes"] remoteExec ["AS_fnc_globalMessage", 2];
};
