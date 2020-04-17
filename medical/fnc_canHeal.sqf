params ["_medic"];
if not hasACEmedical exitWith {
    "FirstAidKit" in (items _medic)
};
true // for ACE, ACE handles it. //TODO maybe check here if unit has bandages
