if ((count weaponCargo caja > 0) or
    (count magazineCargo caja > 0) or
    (count itemCargo caja > 0) or
    (count backpackCargo caja > 0)) exitWith {
        hint "The Ammobox must be empty to move the HQ";
};

if (not(alive petros) or (petros call AS_medical_fnc_isUnconscious)) exitWith {
  hint "Petros must be alive and conscious";
};

[] remoteExec ["AS_fnc_HQmove", 2];
closeDialog 0;
