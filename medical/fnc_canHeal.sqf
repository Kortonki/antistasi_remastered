params ["_medic", "_unit"];
if not hasACEmedical exitWith {
    "FirstAidKit" in (items _medic)
};
private _canHeal = call {

  if (_medic call AS_medical_fnc_isMedic) exitWith {true};

  //Medics can heal all, others can treat bleeding
  //TODO: here a sensible check whether unit has bandages left. Possibly already in ace medical
  //Everyone can CPR in case of cardiac arrest //REMOVED FOR NOW, CPR is going to need medic sooner or later and multiple medics not currently supported
  //these are things that must be addressed immediately, so other than medics apply
  if ([_unit] call ace_medical_blood_fnc_isBleeding) exitWith {true};
  false
};

if (!_canHeal) exitWith {false};

//Check triage if multiple in queue
//Locality with FIA might become an issue, player groups are different locality than FIA which is server
//Non-locals thus get into the end of the queue regardelss of priority as no queue is dedected. This might be a good feature, prioritize own, often player group
//TODO: possible rework on this, hewalqueeu broadcasting necessary?
private _healQueue = (_medic getVariable ["ace_medical_ai_healQueue",[]]);

if (count _healQueue > 0) exitWith {

  //Get medics highest priority and check if current is higher
  private _topTriage = -2;
  private _topUnit = objNull;
  {
    private _triage = (_x getvariable ["ace_medical_triageLevel", -1]);
    if (_triage > _topTriage) then {
      _topTriage = _triage; //Triage levels are synced between clients and server
      _topUnit = _x;
    };
  } foreach _healQueue;

  //Drop everything and rush to higher priority patient (THIS)
  if ((_unit getVariable ["ace_medical_triageLevel", -1]) > _topTriage) then {
    [_topUnit, _medic] remoteExec ["AS_medical_fnc_clearAssignedMedic", _topUnit];
    true
  } else {
    false
  };
};

//No queue just exit
true
