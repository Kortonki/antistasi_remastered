params ["_medic", "_target"];
if (not hasACEMedical) then {
    _target setVariable ["AS_medical_assignedMedic", _medic];
    _medic setVariable ["AS_medical_assignedPatient", _target];
    [_medic, _target] spawn AS_medical_fnc_healAction;
} else {
    // for ACE, assign medic to unit
    _target setVariable ["ace_medical_ai_assignedMedic", _medic];
    _medic groupChat (format ["I'm going to heal %1", (name _target)]);

    //_medic setVariable ["ace_medical_ai_healQueue", _healQueue];
    [[_medic, _target], {
      params ["_medic", "_target"];
      private _healQueue = _medic getVariable ["ace_medical_ai_healQueue", []];
      _healQueue pushBack _target;
      _medic setVariable ["ace_medical_ai_healQueue", _healQueue];
      }]

      remoteExec ["call", _medic]; //Do it where medic is local
};
