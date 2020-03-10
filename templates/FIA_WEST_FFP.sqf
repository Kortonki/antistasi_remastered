private _dict = ([AS_entities, "FIA_WEST"] call DICT_fnc_get) call DICT_fnc_copy;
[_dict, "side", str west] call DICT_fnc_set;
[_dict, "name", "FDF Summer (FFP)"] call DICT_fnc_set;
[_dict, "shortname", "FDF"] call DICT_fnc_set;
[_dict, "flag", "ffp_flagcarrier_finland"] call DICT_fnc_set;

[_dict, "soldier", "B_G_Soldier_F"] call DICT_fnc_set;
[_dict, "crew", "B_G_Soldier_lite_F"] call DICT_fnc_set;
[_dict, "survivor", "B_G_Survivor_F"] call DICT_fnc_set;
[_dict, "engineer", "B_G_engineer_F"] call DICT_fnc_set;
[_dict, "medic", "B_G_medic_F"] call DICT_fnc_set;

[_dict, "uniforms", [
	"ffp_m05w_uniform"
]
] call DICT_fnc_set;

[_dict, "vests", [
	"ffp_m05combatvest",
	"ffp_m05combatvest_radio",
	"ffp_m05combatvest_grenade",
	"ffp_m05flak"

]] call DICT_fnc_set;

[_dict, "helmets", [
	"H_Booniehat_khk", "H_Booniehat_oli", "H_Booniehat_grn",
	"H_Booniehat_dirty", "H_Cap_oli", "H_Cap_blk", "H_MilCap_rucamo",
	"H_MilCap_gry", "H_BandMask_blk",
	"H_Bandanna_khk", "H_Bandanna_gry",
	"H_Bandanna_camo", "H_Shemag_khk", "H_Shemag_tan",
	"H_Shemag_olive", "H_ShemagOpen_tan", "H_Beret_grn", "H_Beret_grn_SF",
	"H_Watchcap_camo", "H_TurbanO_blk", "H_Hat_camo", "H_Hat_tan",
	"H_Beret_blk", "H_Beret_red",
	"H_Beret_02", "H_Watchcap_khk",
	"ffp_m05w_helmet",
	"ffp_m05w_helmet_peltor",
	"ffp_m05w_helmet_glasses",
	"ffp_bmp2_crew_helmet"
	]] call DICT_fnc_set;


[_dict, "unlockedWeapons", [
	"ffp_rk62",
	"ffp_pist2008",
	"sgun_HunterShotgun_01_sawedoff_F",
	"Binocular"
	]] call DICT_fnc_set;

[_dict, "unlockedMagazines", [
	"ffp_30Rnd_762x39",
	"ffp_17rnd_9x9_mag",
	"2Rnd_12Gauge_Pellets",
	"ffp_smoke_white"

	]] call DICT_fnc_set;

//m05 backpack is problematic atm as it contains items by default
[_dict, "unlockedBackpacks", ["B_AssaultPack_rgr", "B_Carryall_oli"]] call DICT_fnc_set;

unlockeditems pushback "Chemlight_blue";

[_dict, "addWeapons", [
["ffp_rk95", 10],
["ffp_KVKK", 2],
["ffp_TKiv2000", 1],
["ffp_kes88", 10],
["ffp_apilas", 2]
]] call DICT_fnc_set;

[_dict, "addMagazines", [
["ffp_handgrenade_runko43", 100],
["ffp_5Rnd_TKiv2000_mag", 10]
]] call DICT_fnc_set;


[_dict, "addItems", [

["Medikit", 2],
["ToolKit", 2],
["adv_aceSplint_splint", 10],
["ACE_salineIV_250", 8],
["ACE_epinephrine", 10],
["ACE_morphine", 10],
["ACE_packingBandage", 20],
["ffp_pp09", 2],
["ffp_optic_TKiv2000",1]

]] call DICT_fnc_set;

//first one should be the most used one, latter for special occasions
[_dict, "static_aa", ["ffp_23itk61"]] call DICT_fnc_set;
[_dict, "static_at", ["ffp_pstohj83"]] call DICT_fnc_set; //first one is used by squads
[_dict, "static_mg", ["rhsgref_cdf_DSHKM"]] call DICT_fnc_set;
[_dict, "static_mortar", ["rhsgref_cdf_reg_M252"]] call DICT_fnc_set;	//first one is used by squads

[_dict, "squads_custom_cost", {
	params ["_squadType"];
	private _pieceType = call {
		if (_squadType == "mobile_aa") exitWith {(["FIA", "static_aa"] call AS_fnc_getEntity) select 0};
		if (_squadType == "mobile_at") exitWith {(["FIA", "static_at"] call AS_fnc_getEntity) select 0};
		if (_squadType == "mobile_mortar") exitWith {(["FIA", "static_mortar"] call AS_fnc_getEntity) select 0};
	};
	private _cost = 2*("Crew" call AS_fnc_getCost);
	private _costHR = 2;
	_cost = _cost + (_pieceType call AS_fnc_getFIAvehiclePrice) +
		(["B_G_Van_01_transport_F"] call AS_fnc_getFIAvehiclePrice);
	[_costHR, _cost]
}] call DICT_fnc_set;

[_dict, "squads_custom_init", {
	params ["_squadType", "_position"];
	private _pos = _position findEmptyPosition [1,30,"B_G_Van_01_transport_F"];
	private _truck = "B_G_Van_01_transport_F" createVehicle _pos;
	private _group = createGroup ("FIA" call AS_fnc_getFactionSide);
	private _driver = ["Crew", _pos, _group] call AS_fnc_spawnFIAUnit;
	private _operator = ["Crew", _pos, _group] call AS_fnc_spawnFIAUnit;

	_group setVariable ["staticAutoT", false, true];
	private _pieceType = call {
		if (_squadType == "mobile_aa") exitWith {(["FIA", "static_aa"] call AS_fnc_getEntity) select 0};
		if (_squadType == "mobile_at") exitWith {(["FIA", "static_at"] call AS_fnc_getEntity)  select 0};
		if (_squadType == "mobile_mortar") exitWith {(["FIA", "static_mortar"] call AS_fnc_getEntity) select 0};
	};

	private _piece = _pieceType createVehicle (_position findEmptyPosition [1,30,"B_G_Van_01_transport_F"]);

	_driver moveInDriver _truck;
	_operator moveInGunner _piece;
	if (_squadType == "mobile_mortar") then {
		_piece setVariable ["attachPoint", [0,-1.5,0.2]];
		[_operator,_truck,_piece] spawn AS_fnc_activateMortarCrewOnTruck;
	} else {
		_piece attachTo [_truck,[0,-1.5,0.2]];
		_piece setDir (getDir _truck + 180);
	};
	[_truck, "FIA"] call AS_fnc_initVehicle;
	[_piece, "FIA"] call AS_fnc_initVehicle;
	_group
}] call DICT_fnc_set;


// To modders: this is additional equipment that you want to find in crates but that isnt equipped on units above
[_dict, "additionalWeapons", []] call DICT_fnc_set;
[_dict, "additionalMagazines", []] call DICT_fnc_set;
[_dict, "additionalItems", []] call DICT_fnc_set;
[_dict, "additionalBackpacks", []] call DICT_fnc_set;
[_dict, "additionalLaunchers", []] call DICT_fnc_set;

// FIA minefield uses first of this list
[_dict, "land_vehicles", [
	"ffp_rg32m",
	"ffp_bv206",
	"RHS_Ural_Civ_01",
	"ffp_susi_sa420",
	"ffp_susi_sa420_covered",
	"ffp_susi_sa420_fuel",
	"ffp_susi_sa420_repair",
	"I_E_Quadbike_01_F",
	"B_G_Offroad_01_F",
	"C_Offroad_01_F",
	"C_Offroad_02_unarmed_F",
	"C_Van_02_transport_F",
	"C_Van_02_vehicle_F",
	"ffp_van_ambulance",
	"ffp_rg32m_gmg"


]] call DICT_fnc_set;

[_dict, "water_vehicles", ["B_G_Boat_Transport_01_F"]] call DICT_fnc_set;
// First helicopter of this list is undercover
[_dict, "air_vehicles", ["ffp_md500"]] call DICT_fnc_set;

[_dict, "cars_armed", [	"ffp_rg32m_gmg"]] call DICT_fnc_set;

// costs of **land vehicle**. Every vehicle in `"land_vehicles"` must be here.
//private _costs = createSimpleObject ["Static", [0, 0, 0]];
private _costs = [_dict, "costs"] call DICT_fnc_get;
//[_dict, "costs"] call DICT_fnc_del; // delete old Don't delete: doesnät hurt if there's additional, but missing for eg. mobile HC squads returns error
//[_dict, "costs", _costs] call DICT_fnc_set;


[_costs, "ffp_bv206", 400] call DICT_fnc_set;
[_costs, "RHS_Ural_Civ_01", 600] call DICT_fnc_set;
[_costs, "ffp_rg32m", 300] call DICT_fnc_set;
[_costs, "ffp_susi_sa420", 600] call DICT_fnc_set;
[_costs, "ffp_susi_sa420_covered", 600] call DICT_fnc_set;
[_costs, "ffp_susi_sa420_fuel", 600] call DICT_fnc_set;
[_costs, "ffp_susi_sa420_repair", 600] call DICT_fnc_set;
[_costs, "I_E_Quadbike_01_F", 50] call DICT_fnc_set;
[_costs, "C_Offroad_01_F", 300] call DICT_fnc_set;
[_costs, "C_Offroad_02_unarmed_F", 300] call DICT_fnc_set;
[_costs, "C_Van_02_transport_F", 300] call DICT_fnc_set;
[_costs, "C_Van_02_vehicle_F", 300] call DICT_fnc_set;
[_costs, "C_Van_02_service_F", 1000] call DICT_fnc_set;
[_costs, "ffp_van_ambulance", 300] call DICT_fnc_set;


//Armed cars

[_costs, "ffp_rg32m_gmg", 600] call DICT_fnc_set;



//Static costs. Will override the one from initSides.sqf

[_costs, "ffp_23itk61", 1200] call DICT_fnc_set;
[_costs, "ffp_pstohj83", 1500] call DICT_fnc_set;
[_costs, "rhsgref_cdf_DSHKM", 300] call DICT_fnc_set;
[_costs, "rhsgref_cdf_reg_M252", 600] call DICT_fnc_set;

//Helos

[_costs, "ffp_md500", 3000] call DICT_fnc_set;  // used in custom vehicles

_dict
