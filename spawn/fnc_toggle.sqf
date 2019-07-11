#include "../macros.hpp"
AS_SERVER_ONLY("AS_spawn_fnc_toggle.sqf");
params ["_on"];

if isNil "AS_spawning" then {
	AS_spawning = false;
};

if (not AS_spawning and _on) then {
	AS_spawning = true;
	diag_log "[AS] Server: spawn loop started.";

	[] spawn {
		private _timer = time +10;
		while {AS_spawning} do {
			call AS_spawn_fnc_update;
			sleep AS_spawnLoopTime;
			if (diag_fps < 5 and {time > _timer}) then {
				diag_log format ["[AS] Server FPS low: %1", diag_fps];
				_timer = time + 10;
			};
		};
	};
};

if (AS_spawning and not _on) then {
	AS_spawning = false;
	diag_log "[AS] Server: spawn loop stopped.";
};
