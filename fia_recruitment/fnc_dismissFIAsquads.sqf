private ["_groups","_salir"];

//TODO: Where to dismiss if FIA_HQ moving is in progress?

_groups = _this select 0;

_salir = false; //Variable for invalid groups

{
if ((groupID _x == "MineF") or (groupID _x == "Watch") or (isPlayer(leader _x))) then {_salir = true};
} forEach _groups;

if (_salir) exitWith {hint "You cannot dismiss player led, Watchpost, Roadblocks or Minefield building squads"};

{
	if (leader _x call AS_fnc_getSide == "NATO") exitwith {_salir = true};
} forEach _groups;

if (_salir) exitWith {hint format ["You cannot dismiss %1 groups", (["NATO", "name"] call AS_fnc_getEntity)]};

if (!(isNil "AS_HQ_moving")) exitWith {hint format "You can't dismiss groups while HQ is not in place"};

_pos = getMarkerPos "FIA_HQ";

{
	AS_commander sideChat format ["Petros, I'm sending %1 back to base", _x];
	AS_commander hcRemoveGroup _x;
	_x setVariable ["isHCgroup", false, true];
	private _wp = _x addWaypoint [_pos, 50];
	_wp setWaypointType "MOVE";
	_x setCurrentWaypoint _wp;
	sleep 3;
	[_x, _pos] spawn AS_fnc_dismissFIAsquad;
} forEach _groups;
