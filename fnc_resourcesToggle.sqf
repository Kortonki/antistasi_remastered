#include "macros.hpp"
AS_SERVER_ONLY("resourcesToogle.sqf");
params ["_on"];

if isNil "AS_resourcing" then {
	AS_resourcing = false;
};

if (not AS_resourcing and _on) then {
	AS_resourcing = true;
	diag_log "[AS] Server: resources loop started.";

	[] spawn {
		while {AS_resourcing} do {

			waitUntil {sleep AS_spawnLoopTime; private _date = dateToNumber date; _date >= (AS_P("nextUpdate")) or _date >= (AS_P("nextAttack"))};
			if (!(AS_resourcing)) exitWith {}; //This in case loop was stopped while waiting for Waituntil condition eg. when skipping time
			if (dateToNumber date >= (AS_P("nextUpdate"))) then {
					diag_log format ["[AS] ResourcesUpdate: Update started at %1", date];
					[] call AS_fnc_resourcesUpdate;
					diag_log format ["[AS] ResourcesUpdate: Update finished at %1", date];
				};
			if (dateToNumber date >= (AS_P("nextAttack"))) then {
				private _noWaves = isNil {AS_S("waves_active")};
				private _AttackLock = isNil "AS_AAF_attackLock";
				//This added to avoid duplicate attacks and for perfomance reason no more than 1 attack at a time
				private _attackMissions = {count (["defend_location", "defend_hq", "defend_city", "defend_camp"] call AS_mission_fnc_active_missions) != 0};
		    if (_attackLock and {_noWaves} and {!([] call _attackMissions)}) then {
		        private _script = [] spawn AS_movement_fnc_sendAAFattack;
		   	};
			};
		};
	};
};

if (AS_resourcing and not _on) then {
	AS_resourcing = false;
	diag_log "[AS] Server: resources loop stopped.";
};
