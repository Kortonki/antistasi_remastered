params ["_unit", "_medic"];
if not hasACEmedical then {
    _unit setVariable ["AS_medical_assignedMedic", nil];
    _medic setVariable ["AS_medical_assignedPatient", nil];
} else {

    _unit setVariable ["ace_medical_ai_assignedMedic", objNull];
    _unit forcespeed -1; //This to override forcespeed 0 in ace medical

    [[_medic, _unit], {
      params ["_medic", "_unit"];
      private _healQueue = _medic getVariable ["ace_medical_ai_healQueue", []];
      _healQueue = _healQueue - [_unit];
      _medic setVariable ["ace_medical_ai_healQueue", _healQueue];
      _medic forcespeed -1; //This to override forcespeed 0 in ace medical
      _medic dofollow (leader _medic);
      }]

      remoteExec ["call", _medic]; //Do it where medic is local
};
