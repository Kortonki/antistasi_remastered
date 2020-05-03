params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b"];

AS_persistent setvariable ["arsenal_w", _cargo_w]; //No need to to broadcast arsenal: All inventory fiddling and arsenal calls are made in server
AS_persistent setvariable ["arsenal_m", _cargo_m];
AS_persistent setvariable ["arsenal_i", _cargo_i];
AS_persistent setvariable ["arsenal_b", _cargo_b];
lockArsenal = false;
