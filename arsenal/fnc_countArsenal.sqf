//new function to tell how much stuff is in the arsenal

(call AS_fnc_getArsenal) params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b"];


private _helmets = 0;
private _vests = 0;
//Weapon clases
private _weapons = 0;

private _pistols = 0;
private _smgs = 0;
private _assaultRifles = 0;
private _sinperRifles = 0;
private _rocketLaunchers = 0;
private _missileLaunchers = 0;

//magazines
private _pistolMags = 0;
private _smgMags = 0;
private _assaultRifleMags = 0;
private _sniperRifleMags = 0;
private _rocketLauncherMags = 0;
private _missileLauncherMags = 0;

private _ATmines = 0;
private _APmines = 0;
private _explosives = 0;

private _medicalItems = 0;

private _faks = 0;
private _medikits = 0;

private _miscItems = 0;

{

} foreach _cargo_w;
