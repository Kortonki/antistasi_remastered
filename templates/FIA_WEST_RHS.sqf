private _dict = ([AS_entities, "FIA_WEST"] call DICT_fnc_get) call DICT_fnc_copy;
[_dict, "side", str west] call DICT_fnc_set;
[_dict, "name", "FIA (RHS)"] call DICT_fnc_set;
[_dict, "flag", "Flag_Blue_F"] call DICT_fnc_set;

[_dict, "soldier", "B_G_Soldier_F"] call DICT_fnc_set;
[_dict, "crew", "B_G_Soldier_lite_F"] call DICT_fnc_set;
[_dict, "survivor", "B_G_Survivor_F"] call DICT_fnc_set;
[_dict, "engineer", "B_G_engineer_F"] call DICT_fnc_set;
[_dict, "medic", "B_G_medic_F"] call DICT_fnc_set;

[_dict, "uniforms", [
	"rhsgref_uniform_ttsko_mountain",
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

[_dict, "unlockedWeapons", [
	"rhs_weap_m38",
	"rhs_weap_makarov_pm",
	"Binocular"
	]] call DICT_fnc_set;

[_dict, "unlockedMagazines", [
	"rhs_mag_9x18_8_57N181S",
	"rhs_mag_rdg2_white"
	]] call DICT_fnc_set;

[_dict, "unlockedBackpacks", ["rhs_assault_umbts"]] call DICT_fnc_set;

//These are used for AAF convoy missions
[_dict, "vans", [
"C_IDAP_Truck_02_F"
]] call DICT_fnc_set;

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

[_dict, "addWeapons", []] call DICT_fnc_set;

[_dict, "addMagazines", [
[	"rhsgref_5Rnd_762x54_m38", 400]
]] call DICT_fnc_set;

[_dict, "addBackpacks", [
["TFAR_anprc155", 8]
]] call DICT_fnc_set;
[_dict, "addItems", [

["Medikit", 1],
["ToolKit", 1],
["adv_aceSplint_splint", 4],
["ACE_salineIV_250", 4],
["ACE_epinephrine", 5],
["ACE_morphine", 5],
["ACE_packingBandage", 10]


]] call DICT_fnc_set;


//first one should be the most used one, latter for special occasions
[_dict, "static_aa", ["rhsgref_cdf_b_ZU23"]] call DICT_fnc_set;
[_dict, "static_at", ["RHS_TOW_TriPod_D"]] call DICT_fnc_set; //first one is used by squads
[_dict, "static_mg", ["RHS_M2StaticMG_D"]] call DICT_fnc_set;
[_dict, "static_mortar", ["RHS_M252_D"]] call DICT_fnc_set;	//first one is used by squads

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
			if (_squadType == "mobile_at") exitWith {(["FIA", "static_at"] call AS_fnc_getEntity) select 0};
			if (_squadType == "mobile_mortar") exitWith {(["FIA", "static_mortar"] call AS_fnc_getEntity) select 0};
		};
		_cost = _costHR*("Crew" call AS_fnc_getCost) +
				(["B_G_Van_01_transport_F"] call AS_fnc_getFIAvehiclePrice) +
				(_piece call AS_fnc_getFIAvehiclePrice);
	};
	[_costHR, _cost]
}] call DICT_fnc_set;

[_dict, "squads_custom_init", {
	params ["_squadType", "_position"];
	private _grupo = grpNull;

	if (_squadType == "mobile_aa") then {
		private _pos = _position findEmptyPosition [1,30,"rhsgref_cdf_b_gaz66_zu23"];
		private _vehicle = [_pos, 0, "rhsgref_cdf_b_gaz66_zu23", ("FIA" call AS_fnc_getFactionSide)] call bis_fnc_spawnvehicle;
		private _veh = _vehicle select 0;
		private _vehCrew = _vehicle select 1;
		{deleteVehicle _x} forEach crew _veh;
		_grupo = _vehicle select 2;
		[_veh, "FIA"] call AS_fnc_initVehicle;
		private _driv = _grupo createUnit [["FIA", "crew"] call AS_fnc_getEntity, _pos, [],0, "NONE"];
		_driv moveInDriver _veh;
		private _gun = _grupo createUnit [["FIA", "crew"] call AS_fnc_getEntity, _pos, [],0, "NONE"];
		_gun moveInGunner _veh;
		private _com = _grupo createUnit [["FIA", "crew"] call AS_fnc_getEntity, _pos, [],0, "NONE"];
		_com moveInCommander _veh;
	} else {
		private _pos = _position findEmptyPosition [1,30,"B_G_Van_01_transport_F"];
		private _vehicleData = [_pos, 0,"B_G_Van_01_transport_F", ("FIA" call AS_fnc_getFactionSide)] call bis_fnc_spawnvehicle;
		private _camion = _vehicleData select 0;
		_grupo = _vehicleData select 2;
		_grupo setVariable ["staticAutoT",false,true];

		private _pieceType = call {
			if (_squadType == "mobile_at") exitWith {(["FIA", "static_at"] call AS_fnc_getEntity) select 0};
			if (_squadType == "mobile_mortar") exitWith {(["FIA", "static_mortar"] call AS_fnc_getEntity) select 0};
		};

		private _piece = _pieceType createVehicle (_position findEmptyPosition [1,30,"B_G_Van_01_transport_F"]);
		private _morty = _grupo createUnit [["FIA", "crew"] call AS_fnc_getEntity, _position findEmptyPosition [1,30,"B_G_Van_01_transport_F"], [], 0, "NONE"];

		if (_squadType == "mobile_mortar") then {
			_morty moveInGunner _piece;
			_piece setVariable ["attachPoint", [0,-1.5,0.54]];
			[_morty,_camion,_piece] spawn AS_fnc_activateMortarCrewOnTruck;
		} else {
			_piece attachTo [_camion,[0,-2.4,-0.6]];
			_piece setDir (getDir _camion + 180);
			_morty moveInGunner _piece;
		};
		[_camion, "FIA"] call AS_fnc_initVehicle;
		[_piece, "FIA"] call AS_fnc_initVehicle;
	};
	_grupo
}] call DICT_fnc_set;

// To modders: this is additional equipment that you want to find in crates but that isnt equipped on units above
[_dict, "additionalWeapons", []] call DICT_fnc_set;
[_dict, "additionalMagazines", []] call DICT_fnc_set;
[_dict, "additionalItems", []] call DICT_fnc_set;
[_dict, "additionalBackpacks", []] call DICT_fnc_set;
[_dict, "additionalLaunchers", []] call DICT_fnc_set;

// FIA minefield uses first of this list
[_dict, "land_vehicles", [
	"rhsgref_cdf_b_reg_uaz_open",
	"RHS_Ural_Civ_01",
	"rhsgref_cdf_b_ural",
	"B_G_Quadbike_01_F",
	"C_Offroad_01_F",
	"C_Offroad_02_unarmed_F",
	"C_Van_02_transport_F",
	"C_Van_02_vehicle_F",
	"C_Van_02_service_F",
	"C_Van_01_fuel_F",
	"rhsgref_cdf_b_reg_uaz_dshkm",
	"rhsgref_cdf_b_reg_uaz_spg9",
	"rhsgref_cdf_b_gaz66_zu23"

]] call DICT_fnc_set;

[_dict, "water_vehicles", ["B_G_Boat_Transport_01_F"]] call DICT_fnc_set;
// First helicopter of this list is undercover
[_dict, "air_vehicles", ["rhs_Mi8amt_civilian","C_Heli_Light_01_civil_F"]] call DICT_fnc_set;

[_dict, "cars_armed", ["rhsgref_cdf_b_reg_uaz_dshkm","rhsgref_cdf_b_reg_uaz_spg9","rhsgref_cdf_b_gaz66_zu23"]] call DICT_fnc_set;

// costs of **land vehicle**. Every vehicle in `"land_vehicles"` must be here.
private _costs = createSimpleObject ["Static", [0, 0, 0]];
[_dict, "costs"] call DICT_fnc_del; // delete old
[_dict, "costs", _costs] call DICT_fnc_set;


[_costs, "rhsgref_cdf_b_reg_uaz_open", 300] call DICT_fnc_set;
[_costs, "RHS_Ural_Civ_01", 600] call DICT_fnc_set;
[_costs, "rhsgref_cdf_b_ural",600] call DICT_fnc_set;
[_costs, "B_G_Quadbike_01_F", 50] call DICT_fnc_set;
[_costs, "C_Offroad_01_F", 300] call DICT_fnc_set;
[_costs, "C_Offroad_02_unarmed_F", 300] call DICT_fnc_set;
[_costs, "C_Van_02_transport_F", 300] call DICT_fnc_set;
[_costs, "C_Van_02_vehicle_F", 300] call DICT_fnc_set;
[_costs, "C_Van_02_service_F", 1000] call DICT_fnc_set;
[_costs, "C_Van_01_fuel_F", 400] call DICT_fnc_set;


[_costs, "rhsgref_cdf_b_reg_uaz_dshkm", 700] call DICT_fnc_set;
[_costs, "rhsgref_cdf_b_reg_uaz_spg9", 1500] call DICT_fnc_set;
[_costs, "rhsgref_cdf_b_gaz66_zu23", 1600] call DICT_fnc_set;

[_costs, "rhs_Mi8amt_civilian", 8000] call DICT_fnc_set;
[_costs, "C_Heli_Light_01_civil_F", 3000] call DICT_fnc_set;  // used in custom vehicles

_dict
