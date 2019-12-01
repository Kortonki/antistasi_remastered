private _dict = ([AS_entities, "FIA_WEST"] call DICT_fnc_get) call DICT_fnc_copy;
[_dict, "side", str west] call DICT_fnc_set;
[_dict, "name", "FIN (RHS)"] call DICT_fnc_set;
[_dict, "flag", "Flag_Blue_F"] call DICT_fnc_set;

[_dict, "soldier", "B_G_Soldier_F"] call DICT_fnc_set;
[_dict, "crew", "B_G_Soldier_lite_F"] call DICT_fnc_set;
[_dict, "survivor", "B_G_Survivor_F"] call DICT_fnc_set;
[_dict, "engineer", "B_G_engineer_F"] call DICT_fnc_set;
[_dict, "medic", "B_G_medic_F"] call DICT_fnc_set;

[_dict, "uniforms", [
"fin_m05_uniform"
]
] call DICT_fnc_set;

[_dict, "unlockedWeapons", [
	"rhs_weap_m38",
	"fin_g17",
	"Binocular"
	]] call DICT_fnc_set;

[_dict, "unlockedMagazines", [
	"rhsgref_5Rnd_762x54_m38",
	"fin_17Rnd_glock_mag",
	"rhs_mag_rdg2_white"
	]] call DICT_fnc_set;

[_dict, "unlockedBackpacks", ["fin_m05_backpack_small"]] call DICT_fnc_set;

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

[_dict, "vans", [
"C_IDAP_Truck_02_F"
]] call DICT_fnc_set;

[_dict, "static_aa", ["rhsgref_cdf_b_ZU23"]] call DICT_fnc_set;
[_dict, "static_at", ["RHS_TOW_TriPod_D"]] call DICT_fnc_set;
[_dict, "static_mg", ["RHS_M2StaticMG_D"]] call DICT_fnc_set;
[_dict, "static_mortar", ["RHS_M252_D"]] call DICT_fnc_set;

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
private _costs = [_dict, "costs"] call DICT_fnc_get;


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
