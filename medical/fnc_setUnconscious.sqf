params ["_unit", "_unconscious"];
if not hasACEMedical then {
    if _unconscious then {
        if ((vehicle _unit) isKindOf "StaticWeapon") then {
            moveOut _unit;
        };

      //  private _anim = [_unit] call AS_medicalfnc_getDeathAnim;
       //_unit switchMove ""; experiment this
       _unit playActionNow "Unconscious";
        //_unit disableAI "ALL";
        [_unit, "ALL"] remoteExecCall ["disableAI", _unit];
        [_unit, true] remoteExecCall ["stop", _unit];
      //  _unit playMoveNow _anim;
//      _unit playMove "AinjPpneMstpSnonWrflDnon_rolltoback";
//    _unit switchMove "AinjPpneMstpSnonWnonDnon";

    } else {
  //      _unit playMove "AinjPpneMstpSnonWnonDnon_rolltofront";
        sleep (5 + random 15);
        _unit playMoveNow "AmovPpneMstpSrasWrflDnon_healed";
        //_unit enableAI "ALL";
        [_unit, "ALL"] remoteExecCall ["enableAI", _unit];
        [_unit, false] remoteExecCall ["stop", _unit];

    };
    _unit setVariable ["AS_medical_isUnconscious", _unconscious, true];
} else {
    [_unit, _unconscious, 10, true] call ACE_medical_fnc_setUnconscious;
};
