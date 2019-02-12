params ["_target", "_caller", "_actionId", "_arguments"];


//Shut down radio if it's on
if (_target getVariable ["radio", false]) exitWith {_target setVariable ["radio", false, true]};

//In other case, switch it on
_target setVariable ["radio", true, true];

private _dummy = createSimpleObject ["Static", (position _target)];
_dummy attachto [_target, [0,0,0], "ridic"]; //TODO tweak this with bounding box to play at cabin

/*private _soundPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;

private _soundFile = selectRandom AS_MusicFiles;

private _soundToPlay = _soundPath + "music\" + _soundFile;*/ //Commented playsound version out

private _soundToPlay = selectRandom AS_MusicFiles;

[_dummy, _soundToPlay] remoteExec ["Say3D", [0,-2] select isDedicated];
[[_soundToPlay, _dummy], {
  params ["_soundToPlay", "_dummy"];
  _dummy Say3D [_soundToPlay, 100, 1, true];}]
remoteExec ["call", [0, -2] select isDedicated];

waitUntil {sleep 0.2; !(_target getVariable ["radio", false])};

deleteVehicle _dummy;
