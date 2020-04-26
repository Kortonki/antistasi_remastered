params ["_killer"];

if (!(["FIRSTBLOOD_date"] call AS_stats_fnc_exists) and {_killer call AS_fnc_getSide == "FIA"}) then {
	["FIRSTBLOOD_date", date] call AS_stats_fnc_set;
	["FIRSTBLOOD_side", _killer call AS_fnc_getSide] call AS_stats_fnc_set;

	private _msg = format [localize "STR_msg_firstblood_AAF_FIA",

	worldName,
	["AAF", "name"] call AS_fnc_getEntity,
	["FIA", "name"] call AS_fnc_getEntity,
	["CSAT", "name"] call AS_fnc_getEntity,
	["AAF", "shortname"] call AS_fnc_getEntity,
	["CSAT", "shortname"] call AS_fnc_getEntity,
	["NATO", "shortname"] call AS_fnc_getEntity,
	["FIA", "shortname"] call AS_fnc_getEntity
	];

	[_msg, 30, ""] remoteExec ["AS_fnc_globalMessage", 2];

	[0, 20] remoteExec ["AS_fnc_changeForeignSupport", 2];
};

//NATO killing AAF triggers CSAT attacks, save the date for the record
if (_killer call AS_fnc_getSide == "NATO" and {!(["NATO_killAAF_date"] call AS_stats_fnc_exists)}) then {
	["NATO_killAAF_date", date] call AS_stats_fnc_set;
};
