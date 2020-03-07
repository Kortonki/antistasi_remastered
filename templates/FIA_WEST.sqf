private _dict = createSimpleObject ["Static", [0, 0, 0]];
[_dict, "side", str west] call DICT_fnc_set;
[_dict, "roles", ["anti_state"]] call DICT_fnc_set;
[_dict, "name", "FIA"] call DICT_fnc_set;
[_dict, "flag", "Flag_FIA_F"] call DICT_fnc_set;

[_dict, "vests", ["V_BandollierB_oli"]] call DICT_fnc_set;

[_dict, "googles", [
	"G_Balaclava_blk",
	"G_Balaclava_combat",
	"G_Balaclava_lowprofile",
	"G_Balaclava_oli",
	"G_Bandanna_beast",
	"G_Tactical_Black",
	"G_Aviator",
	"G_Shades_Black"]
] call DICT_fnc_set;

[_dict, "uniforms", [
	"U_IG_Guerilla1_1",
	"U_IG_Guerilla2_1",
	"U_IG_Guerilla2_2",
	"U_IG_Guerilla2_3",
	"U_IG_Guerilla3_1",
	"U_IG_Guerilla3_2",
	"U_IG_leader",
	"U_BG_Guerilla1_1",
	"U_BG_Guerilla2_2",
	"U_BG_Guerilla2_3",
	"U_BG_Guerilla3_1",
	"U_BG_Guerilla3_2",
	"U_BG_leader",
	"U_OG_Guerilla1_1",
	"U_OG_Guerilla2_1",
	"U_OG_Guerilla2_2",
	"U_OG_Guerilla2_3",
	"U_OG_Guerilla3_1",
	"U_OG_Guerilla3_2",
	"U_OG_leader"]
] call DICT_fnc_set;

[_dict, "helmets", [
	"H_Booniehat_khk", "H_Booniehat_oli", "H_Booniehat_grn",
	"H_Booniehat_dirty", "H_Cap_oli", "H_Cap_blk", "H_MilCap_rucamo",
	"H_MilCap_gry", "H_BandMask_blk",
	"H_Bandanna_khk", "H_Bandanna_gry",
	"H_Bandanna_camo", "H_Shemag_khk", "H_Shemag_tan",
	"H_Shemag_olive", "H_ShemagOpen_tan", "H_Beret_grn", "H_Beret_grn_SF",
	"H_Watchcap_camo", "H_TurbanO_blk", "H_Hat_camo", "H_Hat_tan",
	"H_Beret_blk", "H_Beret_red",
	"H_Beret_02", "H_Watchcap_khk"]
] call DICT_fnc_set;

[_dict, "unlockedWeapons", [
	"hgun_PDW2000_F",
	"hgun_ACPC2_F",
	"Binocular"]
] call DICT_fnc_set;

[_dict, "unlockedMagazines", [
	"30Rnd_9x21_Mag",
	"9Rnd_45ACP_Mag"
	]
] call DICT_fnc_set;

[_dict, "unlockedBackpacks", ["B_TacticalPack_blk"]] call DICT_fnc_set;

[_dict, "addWeapons", []] call DICT_fnc_set;
[_dict, "addMagazines", []] call DICT_fnc_set;
[_dict, "addBackpacks", []] call DICT_fnc_set;
//Starting items

[_dict, "addItems", [

["Medikit", 2],
["ToolKit", 2],
["adv_aceSplint_splint", 10],
["ACE_salineIV_250", 8],
["ACE_epinephrine", 10],
["ACE_morphine", 10],
["ACE_packingBandage", 20]

]] call DICT_fnc_set;

[_dict, "soldier", "B_G_Soldier_F"] call DICT_fnc_set;
[_dict, "crew", "B_G_Soldier_lite_F"] call DICT_fnc_set;
[_dict, "survivor", "B_G_Survivor_F"] call DICT_fnc_set;
[_dict, "engineer", "B_G_engineer_F"] call DICT_fnc_set;
[_dict, "medic", "B_G_medic_F"] call DICT_fnc_set;

//These are used for AAF convoy missions
[_dict, "vans", [
"C_IDAP_Truck_02_F"
]] call DICT_fnc_set;

[_dict, "squad", [
	"Squad Leader", "Medic", "AT Specialist", "Autorifleman", "Grenadier", "Rifleman", "Rifleman", "Rifleman"
]] call DICT_fnc_set;
[_dict, "team", ["Squad Leader", "Autorifleman", "Grenadier", "Rifleman"]] call DICT_fnc_set;
[_dict, "team_at", ["Squad Leader", "AT Specialist", "AT Specialist"]] call DICT_fnc_set;
[_dict, "team_aa", ["Squad Leader", "AA Specialist", "AA Specialist"]] call DICT_fnc_set;
[_dict, "team_sniper", ["Rifleman", "Sniper"]] call DICT_fnc_set;
[_dict, "team_patrol", ["Rifleman", "Grenadier"]] call DICT_fnc_set;
[_dict, "team_crew", ["AT Specialist", "Crew"]] call DICT_fnc_set;

[_dict, "squads", ["squad", "team", "team_at","team_aa", "team_sniper", "team_patrol", "mobile_aa", "mobile_at", "mobile_mortar"]] call DICT_fnc_set;
[_dict, "squad_names", ["Squad", "Team", "AT Team","AA Team", "Sniper Team", "Patrol", "Mobile AA", "Mobile AT", "Mobile Mortar"]] call DICT_fnc_set;

[_dict, "squads_custom", ["mobile_aa", "mobile_at", "mobile_mortar"]] call DICT_fnc_set;
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

//first one should be the most used one, latter for special occasions
[_dict, "static_aa", ["B_static_AA_F"]] call DICT_fnc_set;
[_dict, "static_at", ["B_static_AT_F"]] call DICT_fnc_set; //first one is used by squads
[_dict, "static_mg", ["B_HMG_01_high_F"]] call DICT_fnc_set;
[_dict, "static_mortar", ["B_G_Mortar_01_F"]] call DICT_fnc_set; //first one is used by squads

// To modders: this is additional equipment that you want to find in crates but that isnt equipped on units above: if side FIA, these are buyable by irishman
[_dict, "additionalWeapons", []] call DICT_fnc_set;
[_dict, "additionalMagazines", []] call DICT_fnc_set;
[_dict, "additionalItems", []] call DICT_fnc_set;
[_dict, "additionalBackpacks", []] call DICT_fnc_set;
[_dict, "additionalLaunchers", []] call DICT_fnc_set;



//No special medical equipment for extra difficulty (need to hoard morphine etc.)

unlockedItems = unlockedItems - [
"Medikit",
"ACE_bloodIV_250",
"ACE_bloodIV_500",
"ACE_bloodIV",
"ACE_epinephrine",
"ACE_morphine",
"ACE_plasmaIV_250",
"ACE_plasmaIV_500",
"ACE_plasmaIV",
"ACE_packingBandage",
"ACE_elasticBandage",
"ACE_quikclot",
"ACE_salineIV_250",
"ACE_salineIV_500",
"ACE_salineIV",
"ACE_atropine",
"ACE_adenosine",
"ACE_personalAidKit",
"ACE_surgicalKit",
"adv_aceSplint_splint"
];

[_dict, "addBackpacks", [
["TFAR_anprc155", 8]
]] call DICT_fnc_set;

// FIA minefield uses first of this list
[_dict, "land_vehicles", ["C_Offroad_01_F","C_Van_01_transport_F","B_G_Quadbike_01_F","B_G_Offroad_01_armed_F", "B_G_Offroad_01_F"]] call DICT_fnc_set;
[_dict, "water_vehicles", ["B_G_Boat_Transport_01_F"]] call DICT_fnc_set;
// First helicopter of this list is undercover
[_dict, "air_vehicles", ["C_Heli_Light_01_civil_F"]] call DICT_fnc_set;

[_dict, "cars_armed", ["B_G_Offroad_01_armed_F", "B_G_Offroad_01_AT_F"]] call DICT_fnc_set;
//This is new addition: used to evaluate threat
[_dict, "cars_aa", []] call DICT_fnc_set;
[_dict, "cars_at", ["B_G_Offroad_01_AT_F"]] call DICT_fnc_set;


// costs of **land vehicle**. Every vehicle in `"land_vehicles"` must be here.
private _costs = createSimpleObject ["Static", [0, 0, 0]];
[_dict, "costs", _costs] call DICT_fnc_set;
[_costs, "C_Offroad_01_F", 300] call DICT_fnc_set;
[_costs, "B_G_Offroad_01_F", 300] call DICT_fnc_set;
[_costs, "C_Van_01_box_F", 300] call DICT_fnc_set;  // defined on "vans"
[_costs, "C_Van_01_transport_F", 600] call DICT_fnc_set;
[_costs, "B_G_Quadbike_01_F", 50] call DICT_fnc_set;
[_costs, "B_G_Offroad_01_armed_F", 600] call DICT_fnc_set;
[_costs, "B_G_Offroad_01_AT_F", 1200] call DICT_fnc_set;
[_costs, "B_G_Van_01_transport_F", 400] call DICT_fnc_set;

_dict
