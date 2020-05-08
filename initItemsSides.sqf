//////////////////// AAF ////////////////////
private _AAFsoldiers = (["AAF", "cfgGroups"] call AS_fnc_getEntity) call AS_fnc_getAllUnits;

// List of all AAF equipment
private _result = [_AAFsoldiers] call AS_fnc_listUniqueEquipment;
AAFWeapons = _result select 0;
AAFWeapons append (["AAF", "additionalWeapons"] call AS_fnc_getEntity);
AAFMagazines = _result select 1;
AAFMagazines append (["AAF", "additionalMagazines"] call AS_fnc_getEntity);
AAFItems = _result select 2;
AAFItems append (["AAF", "additionalItems"] call AS_fnc_getEntity);
AAFBackpacks = _result select 3;
AAFBackpacks append (["AAF", "additionalBackpacks"] call AS_fnc_getEntity);
AAFBinoculars = _result select 5;
AAFBinoculars append (["AAF", "additionalBinoculars"] call AS_fnc_getEntity);

AAFLaunchers = AAFWeapons arrayIntersect ((AS_weapons select 8) + (AS_weapons select 10));
AAFLaunchers append (["AAF", "additionalLaunchers"] call AS_fnc_getEntity);

// Assign other items
AAFVests = AAFItems arrayIntersect AS_allVests;
AAFHelmets = AAFItems arrayIntersect AS_allHelmets;

AAFThrowGrenades = AAFMagazines arrayIntersect AS_allThrowGrenades;
AAFMagazines = AAFMagazines - AAFThrowGrenades;

//////////////////// NATO ////////////////////
private _NATOsoldiers = (["NATO", "cfgGroups"] call AS_fnc_getEntity) call AS_fnc_getAllUnits;

// List of all NATO equipment
_result = [_NATOsoldiers] call AS_fnc_listUniqueEquipment;
NATOWeapons = _result select 0;
NATOWeapons append (["NATO", "additionalWeapons"] call AS_fnc_getEntity);
NATOMagazines = _result select 1;
NATOMagazines append (["NATO", "additionalMagazines"] call AS_fnc_getEntity);
NATOItems = _result select 2;
NATOItems append (["NATO", "additionalItems"] call AS_fnc_getEntity);
NATOBackpacks = _result select 3;
NATOBackpacks append (["NATO", "additionalBackpacks"] call AS_fnc_getEntity);
NATOBinoculars = _result select 5;
NATOBinoculars append (["NATO", "additionalBinoculars"] call AS_fnc_getEntity);

NATOLaunchers = NATOWeapons arrayIntersect ((AS_weapons select 8) + (AS_weapons select 10));
NATOLaunchers append (["NATO", "additionalLaunchers"] call AS_fnc_getEntity);

NATOVests = NATOItems arrayIntersect AS_allVests;
NATOHelmets = NATOItems arrayIntersect AS_allHelmets;

NATOThrowGrenades = NATOMagazines arrayIntersect AS_allThrowGrenades;
NATOMagazines = NATOMagazines - NATOThrowGrenades;

//////////////////// CSAT ////////////////////
private _CSATsoldiers = (["CSAT", "cfgGroups"] call AS_fnc_getEntity) call AS_fnc_getAllUnits;

// List of all CSAT equipment
_result = [_CSATsoldiers] call AS_fnc_listUniqueEquipment;
CSATWeapons = _result select 0;
CSATWeapons append (["CSAT", "additionalWeapons"] call AS_fnc_getEntity);
CSATMagazines = _result select 1;
CSATMagazines append (["CSAT", "additionalMagazines"] call AS_fnc_getEntity);
CSATItems = _result select 2;
CSATItems append (["CSAT", "additionalItems"] call AS_fnc_getEntity);
CSATBackpacks = _result select 3;
CSATBackpacks append (["CSAT", "additionalBackpacks"] call AS_fnc_getEntity);
CSATBinoculars = _result select 5;
CSATBinoculars append (["CSAT", "additionalBinoculars"] call AS_fnc_getEntity);

CSATLaunchers = CSATWeapons arrayIntersect ((AS_weapons select 8) + (AS_weapons select 10));
CSATLaunchers append (["CSAT", "additionalLaunchers"] call AS_fnc_getEntity);

CSATVests = CSATItems arrayIntersect AS_allVests;
CSATHelmets = CSATItems arrayIntersect AS_allHelmets;

CSATThrowGrenades = CSATMagazines arrayIntersect AS_allThrowGrenades;
CSATMagazines = CSATMagazines - CSATThrowGrenades;

//////////////////// CIV ////////////////////////

private _CIVunits = ["CIV", "units"] call AS_fnc_getEntity;
_result = [_CIVunits] call AS_fnc_listUniqueEquipment;
CIVUniforms = _result select 4;

unlockedWeapons = ["FIA", "unlockedWeapons"] call AS_fnc_getEntity;
unlockedMagazines = ["FIA", "unlockedMagazines"] call AS_fnc_getEntity;
unlockedBackpacks = ["FIA", "unlockedBackpacks"] call AS_fnc_getEntity;
unlockedItems append (["FIA", "unlockedItems"] call AS_fnc_getEntity);

if hasTFAR then {
    unlockedItems = unlockedItems - ["ItemRadio"];
    //unlockedItems pushBack (["AAF", "tfar_radio"] call AS_fnc_getEntity);
    if not hasRHS then {
		unlockedItems pushBack "tf_microdagr";
    };
};

//////////////////// FIA ////////////////////////
unlockedItems = unlockedItems +
	CIVUniforms +
	(["FIA", "uniforms"] call AS_fnc_getEntity) +
	(["FIA", "helmets"] call AS_fnc_getEntity) +
	(["FIA", "vests"] call AS_fnc_getEntity) +
	(["FIA", "googles"] call AS_fnc_getEntity);
