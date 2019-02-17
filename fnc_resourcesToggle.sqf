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

			waitUntil {sleep AS_spawnLoopTime; private _date = dateToNumber date; _date > (AS_P("nextUpdate")) or _date > (AS_P("nextAttack"))};

			if (dateToNumber date > (AS_P("nextUpdate"))) then {
					[] call AS_fnc_resourcesUpdate;
				};
			if (dateToNumber date > (AS_P("nextAttack"))) then {
				private _noWaves = isNil {AS_S("waves_active")};
				private _AttackLock = isNil "AS_AAF_attackLock";
		    if (_attackLock and {_noWaves}) then {
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
