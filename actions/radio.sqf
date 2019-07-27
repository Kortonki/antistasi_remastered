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



private _sound = selectRandom AS_MusicFiles;

[[_sound, _dummy], {
  params ["_sound", "_dummy"];
  _dummy Say3D [_sound, 100, 1, true];}]
remoteExec ["call", [0, -2] select isDedicated];

  //_dummy Say3D [_soundToPlay, 100, 1, true];

private _length = getnumber(missionConfigFile >> "CfgSounds" >> _sound >> "duration");

private _time = 120;
if (!(isnil "_length")) then {
  _time = time + _length;
};

waitUntil {sleep 0.2; !(_target getVariable ["radio", false]) or (time > _time)};

_dummy setpos [0,0,0];
deleteVehicle _dummy;

//Loop if not shut off
if   ((_target getVariable ["radio", false])) then {
  _target setVariable ["radio", false, true];
  [_target, _caller, _actionId] execVM "actions\radio.sqf";
};
