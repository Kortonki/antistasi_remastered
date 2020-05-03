params ["_unit", "_medic"];
if (alive _unit) then {
  _medic groupChat (format ["I'm ready with %1", (name _unit)]);
} else {
  _medic groupChat "He's dead already";
};
if not hasACEmedical then {
    _unit setVariable ["AS_medical_assignedMedic", nil];
    _medic setVariable ["AS_medical_assignedPatient", nil];
} else {

    _unit setVariable ["ace_medical_ai_assignedMedic", objNull];
    _unit forcespeed -1; //This to override forcespeed 0 in ace medicala
    _unit setVariable ["treatmentpos", nil];

    [[_medic, _unit], {
      params ["_medic", "_unit"];
      private _healQueue = _medic getVariable ["ace_medical_ai_healQueue", []];
      _healQueue = _healQueue - [_unit];
      _medic setVariable ["ace_medical_ai_healQueue", _healQueue];
      _medic forcespeed -1; //This to override forcespeed 0 in ace medical
      _medic switchmove "";
      _medic dofollow (leader _medic);
      }]

      remoteExec ["call", _medic]; //Do it where medic is local
};
