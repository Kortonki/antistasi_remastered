private _dict = ([AS_entities, "FIA_WEST"] call DICT_fnc_get) call DICT_fnc_copy;
[_dict, "side", str west] call DICT_fnc_set;
[_dict, "name", "Livonia Resistance Army (RHS and 3CB)"] call DICT_fnc_set;
[_dict, "shortname", "LRA"] call DICT_fnc_set;
[_dict, "flag", "Flag_Enoch_F"] call DICT_fnc_set;

[_dict, "civs", "3CB_CIV_CW"] call DICT_fnc_set;

[_dict, "soldier", "UK3CB_CCM_B_RIF_1"] call DICT_fnc_set;
[_dict, "crew", "UK3CB_CCM_B_RIF_2"] call DICT_fnc_set;
[_dict, "survivor", "UK3CB_CCM_B_RIF_LITE"] call DICT_fnc_set;
[_dict, "engineer", "UK3CB_CCM_B_ENG"] call DICT_fnc_set;
[_dict, "medic", "UK3CB_CCM_B_MD"] call DICT_fnc_set;


private _config = configfile >> "CfgGroups" >> "West" >> "UK3CB_CCM_B" >> "Infantry";
private _FIAsoldiers = _config call AS_fnc_getAllUnits;

// List of all FIA 3CB equipment
private _result = [_FIAsoldiers] call AS_fnc_listUniqueEquipment;

private _uniforms = _result select 4;
_uniforms append [
"rhsgref_uniform_ttsko_mountain",
"U_BG_Guerrilla2_2",
"U_BG_Guerrilla_6_1",
"U_I_E_Uniform_01_shortsleeve_F",
"U_I_E_Uniform_01_officer_F"
];

[_dict, "uniforms", _uniforms] call DICT_fnc_set;

[_dict, "unlockedWeapons", [
	"rhs_weap_Izh18",
	"rhs_weap_makarov_pm",
	"rhs_weap_m38",
	"sgun_HunterShotgun_01_sawedoff_F",
	"Binocular"
	]] call DICT_fnc_set;

[_dict, "unlockedMagazines", [
	"rhsgref_1Rnd_00Buck",
	"2Rnd_12Gauge_Pellets",
	"rhsgref_1Rnd_Slug",
	"rhs_mag_9x18_8_57N181S",
	"rhs_mag_rdg2_white",
	"IEDUrbanBig_Remote_Mag",
	"IEDLandBig_Remote_Mag",
	"IEDUrbanSmall_Remote_Mag",
	"IEDLandSmall_Remote_Mag"
	]] call DICT_fnc_set;

[_dict, "unlockedBackpacks", ["B_FieldPack_green_F", "B_Bergen_mcamo_F"]] call DICT_fnc_set;

unlockeditems pushback "Chemlight_blue";

//No special medical equipment for extra difficulty (need to hoard morphine etc.)

[_dict, "addWeapons", [
["rhs_weap_mg42", 2]
]] call DICT_fnc_set;

[_dict, "addMagazines", [
[	"rhsgref_5Rnd_762x54_m38", 400],
["rhs_charge_tnt_x2_mag", 20],
["rhs_grenade_nbhgr39_mag", 12],
["rhs_ec400_sand_mag", 2],
["rhs_ec200_sand_mag", 2],
["rhs_ec75_sand_mag", 2],

["rhsgref_296Rnd_792x57_SmE_belt", 4]
]] call DICT_fnc_set;


//first one should be the most used one, latter for special occasions
[_dict, "static_aa", ["rhsgref_cdf_b_ZU23"]] call DICT_fnc_set;
[_dict, "static_at", ["rhsgref_cdf_SPG9"]] call DICT_fnc_set; //first one is used by squads
[_dict, "static_mg", ["rhsgref_cdf_DSHKM"]] call DICT_fnc_set;
[_dict, "static_mortar", ["rhsgref_cdf_reg_M252"]] call DICT_fnc_set;	//first one is used by squads

[_dict, "squads_custom_cost", {
	params ["_squadType"];
	private _cost = 0;
	private _costHR = 0;
	if (_squadType == "mobile_aa") then {
		_costHR = 3;
		_cost = _costHR*("Crew" call AS_fnc_getCost) +
			    (["rhsgref_cdf_b_gaz66_zu23"] call AS_fnc_getFIAvehiclePrice);
	} else {
		_costHR = 2;
		private _piece = call {
			if (_squadType == "mobile_at") exitWith {"rhsgref_cdf_b_reg_uaz_spg9"};
			if (_squadType == "mobile_mortar") exitWith {(["FIA", "static_mortar"] call AS_fnc_getEntity) select 0};
		};
		if (_squadType == "mobile_mortar") then {
		_cost = _costHR*("Crew" call AS_fnc_getCost) +
				(["B_G_Van_01_transport_F"] call AS_fnc_getFIAvehiclePrice) +
				(_piece call AS_fnc_getFIAvehiclePrice);
			} else {
				_cost = _costHR*("Crew" call AS_fnc_getCost) +
				(_piece call AS_fnc_getFIAvehiclePrice);
			};
	};
	[_costHR, _cost]
}] call DICT_fnc_set;

[_dict, "squads_custom_init", {
	params ["_squadType", "_position"];
	private _pos = _position findEmptyPosition [1,30,"B_G_Van_01_transport_F"];
	private _group = createGroup ("FIA" call AS_fnc_getFactionSide);
	private _driver = ["Crew", _pos, _group] call AS_fnc_spawnFIAUnit;
	private _operator = ["Crew", _pos, _group] call AS_fnc_spawnFIAUnit;

	_group setVariable ["staticAutoT", false, true];
	private _pieceType = call {
		if (_squadType == "mobile_aa") exitWith {"rhsgref_cdf_b_gaz66_zu23"};
		if (_squadType == "mobile_at") exitWith {"rhsgref_cdf_b_reg_uaz_spg9"};
		if (_squadType == "mobile_mortar") exitWith {(["FIA", "static_mortar"] call AS_fnc_getEntity) select 0};
	};

	private _piece = _pieceType createVehicle (_position findEmptyPosition [1,30,_pieceType]);

	_driver moveinDriver _piece;
	_operator moveInGunner _piece;
	if (_squadType == "mobile_aa") then {
		private _commander = ["Crew", _pos, _group] call AS_fnc_spawnFIAUnit;
		_commander moveinCommander _piece;
	};

	if (_squadType == "mobile_mortar") then {
		private _truck = "B_G_Van_01_transport_F" createVehicle _pos;
		[_truck, "FIA"] call AS_fnc_initVehicle;
		_driver moveInDriver _truck;
		_piece setVariable ["attachPoint", [0,-1.5,0.2]];
		[_operator,_truck,_piece] spawn AS_fnc_activateMortarCrewOnTruck;
	};
	[_piece, "FIA"] call AS_fnc_initVehicle;
	_group
}] call DICT_fnc_set;


// To modders: this is additional equipment that you want to find in crates but that isnt equipped on units above
[_dict, "additionalWeapons", []] call DICT_fnc_set;
[_dict, "additionalMagazines", []] call DICT_fnc_set;
[_dict, "additionalItems", []] call DICT_fnc_set;
[_dict, "additionalBackpacks", []] call DICT_fnc_set;
[_dict, "additionalLaunchers", []] call DICT_fnc_set;
[_dict, "additionalBinoculars", []] call DICT_fnc_set;

// FIA minefield uses first of this list
[_dict, "land_vehicles", [
	"UK3CB_CHC_C_Tractor_Old",
	"UK3CB_C_Hilux_Closed",
	"UK3CB_C_Hilux_Open",
	"UK3CB_C_LandRover_Open",
	"rhsgref_cdf_b_reg_uaz_open",
	"UK3CB_CHC_C_V3S_Open",
	"UK3CB_CHC_C_V3S_Closed",
	"UK3CB_CHC_C_V3S_Reammo",
	"UK3CB_CHC_C_V3S_Repair",
	"UK3CB_CHC_C_V3S_Refuel",
	"rhsgref_cdf_b_reg_uaz_dshkm",
	"rhsgref_cdf_b_reg_uaz_spg9",
	"rhsgref_cdf_b_gaz66",
	"rhsgref_cdf_b_gaz66o",
	"rhsgref_cdf_b_gaz66_zu23"

]] call DICT_fnc_set;

[_dict, "water_vehicles", ["B_G_Boat_Transport_01_F"]] call DICT_fnc_set;
// First helicopter of this list is undercover
[_dict, "air_vehicles", []] call DICT_fnc_set;

[_dict, "cars_armed", ["rhsgref_cdf_b_reg_uaz_dshkm","rhsgref_cdf_b_reg_uaz_spg9","rhsgref_cdf_b_gaz66_zu23"]] call DICT_fnc_set;
//This is new addition: used to evaluate threat
[_dict, "cars_aa", ["rhsgref_cdf_b_gaz66_zu23"]] call DICT_fnc_set;
[_dict, "cars_at", ["rhsgref_cdf_b_reg_uaz_spg9"]] call DICT_fnc_set;

// costs of **land vehicle**. Every vehicle in `"land_vehicles"` must be here.
//private _costs = createSimpleObject ["Static", [0, 0, 0]];
private _costs = [_dict, "costs"] call DICT_fnc_get;
//[_dict, "costs"] call DICT_fnc_del; // delete old Don't delete: doesnät hurt if there's additional, but missing for eg. mobile HC squads returns error
//[_dict, "costs", _costs] call DICT_fnc_set;


[_costs, "UK3CB_CHC_C_Tractor_Old", 50] call DICT_fnc_set;
[_costs, "UK3CB_C_Hilux_Closed", 300] call DICT_fnc_set;
[_costs, "UK3CB_C_Hilux_Open", 300] call DICT_fnc_set;
[_costs, "UK3CB_C_LandRover_Open", 400] call DICT_fnc_set;
[_costs, "rhsgref_cdf_b_reg_uaz_open", 300] call DICT_fnc_set;
[_costs, "UK3CB_CHC_C_V3S_Open", 500] call DICT_fnc_set;
[_costs, "UK3CB_CHC_C_V3S_Closed",500] call DICT_fnc_set;
[_costs, "UK3CB_CHC_C_V3S_Reammo", 600] call DICT_fnc_set;
[_costs, "UK3CB_CHC_C_V3S_Refuel", 600] call DICT_fnc_set;
[_costs, "UK3CB_CHC_C_V3S_Repair", 600] call DICT_fnc_set;
[_costs, "rhsgref_cdf_b_gaz66", 400] call DICT_fnc_set;
[_costs, "rhsgref_cdf_b_gaz66o", 400] call DICT_fnc_set;
[_costs, "C_Van_01_fuel_F", 400] call DICT_fnc_set;


[_costs, "rhsgref_cdf_b_reg_uaz_dshkm", 600] call DICT_fnc_set;
[_costs, "rhsgref_cdf_b_reg_uaz_spg9", 900] call DICT_fnc_set;
[_costs, "rhsgref_cdf_b_gaz66_zu23", 1600] call DICT_fnc_set;

//Static costs. Will override the one from initSides.sqf

[_costs, "rhsgref_cdf_b_ZU23", 1200] call DICT_fnc_set;
[_costs, "rhsgref_cdf_SPG9", 600] call DICT_fnc_set;
[_costs, "rhsgref_cdf_DSHKM", 300] call DICT_fnc_set;
[_costs, "rhsgref_cdf_reg_M252", 600] call DICT_fnc_set;

_dict
