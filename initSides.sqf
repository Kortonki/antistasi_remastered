//These variables don't need to be broadcasted - inited for all clients (init_commonvariables)

// Define all helis of CSAT and NATO
{
	private _side = _x;
	private _vehicles = [];
	private _categories = ["helis_transport", "helis_attack", "helis_armed"];
	if (_side == "AAF") then {
		_categories = ["helis_transport", "helis_armed"];
	};
	{
		_vehicles append ([_side, _x] call AS_fnc_getEntity);

	} forEach _categories;
	[AS_entities, _side call AS_fnc_getFaction, "helis", _vehicles] call DICT_fnc_set;
} forEach ["CSAT", "NATO", "AAF"];

//Following isa computed list for AI target threat estimation
//NOTE: Assuming FIA is set to not be able to buy any armed helicopters, so their armed and attack helos are allways captured
{
	private _type = _x;
	private _helos = [];
	{
		if (not(isNil{[_x, _type] call AS_fnc_getEntity})) then {
			{
				_helos pushBackUnique _x;
			} foreach ([_x, _type] call AS_fnc_getEntity);
		};
	} foreach ["CSAT", "AAF", "NATO"];

	if (_type == "helis_armed") then {
		AS_allArmedHelis = +_helos;
	};

	if (_type == "helis_attack") then {
		AS_allAttackHelis = +_helos;
	};

	if (_type == "planes") then {
		AS_allPlanes = +_helos;
	};

} foreach ["helis_armed", "helis_attack", "planes"];



// compute lists of statics
{
	private _statics = [];
	private _type = _x;
	{
		if not ((_type == "static_mg_low") and (_x == "FIA")) then {
			// FIA does use "static_mg_low".
				if (not(isNil{[_x, _type] call AS_fnc_getEntity})) then {
					{
						_statics pushBackUnique _x;
					} foreach ([_x, _type] call AS_fnc_getEntity);
				};
		};
	} forEach ["CSAT", "NATO", "AAF", "FIA"];

	if (_type == "static_at") then {
		AS_allATstatics = +_statics;
	};
	if (_type == "static_aa") then {
		AS_allAAstatics = +_statics;
	};
	if (_type in ["static_mg", "static_mg_low"]) then {
		AS_allMGstatics = +_statics;
	};
	if (_type == "static_mortar") then {
		AS_allMortarStatics = +_statics;
	};
} forEach ["static_aa", "static_at", "static_mg", "static_mg_low", "static_mortar"];
AS_allStatics = AS_allATstatics + AS_allAAstatics + AS_allMGstatics + AS_allMortarStatics;

// set of all NATO vehicles
private _vehicles = [];
{
	_vehicles append (["NATO", _x] call AS_fnc_getEntity);
} forEach [
"tanks", "trucks", "cars_transport", "cars_armed", "apcs",
"self_aa", "artillery1", "artillery2", "other_vehicles",
"helis_transport", "helis_attack", "helis_armed", "planes"];
[AS_entities, "NATO" call AS_fnc_getFaction, "vehicles", _vehicles] call DICT_fnc_set;

// Stores cost of AAF and FIA units
if not isNil "AS_data_allCosts" then {
	AS_data_allCosts call DICT_fnc_del;
};
AS_data_allCosts = createSimpleObject ["Static", [0, 0, 0]];


// sets the costs of AAF units based on their relative cost
call {
	private _result = [];
	{
		_result pushBackUnique [_x,(getNumber (configfile >> "cfgVehicles" >> _x >> "cost"))]
	} forEach (((["AAF", "cfgGroups"] call AS_fnc_getEntity) call AS_fnc_getAllUnits) + [["AAF", "officer"] call AS_fnc_getEntity] + [["AAF", "traitor"] call AS_fnc_getEntity] + [["AAF", "gunner"] call AS_fnc_getEntity] + [["AAF", "crew"] call AS_fnc_getEntity] + [["AAF", "pilot"] call AS_fnc_getEntity]);

	// sort by cost
	_result = [_result, [], {_x select 1}, "DESC"] call BIS_fnc_sortBy;

	// assign cost based on relative cost: cheapest is 10, most expensive 30
	private _min = (_result select (count _result - 1)) select 1;
	private _max = (_result select 0) select 1;
	if (_max == _min) then {
		_min = 0;  // if all equal, all cost most expensive
	};
	{
		private _cost = _x select 1;
		_cost = 10 + 20 * (_cost - _min)/(_max - _min);
		AS_data_allCosts setVariable [_x select 0, _cost];
	} forEach _result;
};

////////////////// FIA stuff //////////////////

AS_allFIAUnitTypes = [
	"Rifleman",
	"Grenadier",
	"Medic",
	"Autorifleman",
	"Squad Leader",
	"AT Specialist",
	"Sniper",
	"Engineer",
	"AA Specialist",
	"Explosives Specialist",
	"Crew",
	"Survivor"
];

// cost of water and air vehicles
{
	AS_data_allCosts setVariable [_x, 6000];
} forEach (["FIA", "air_vehicles"] call AS_fnc_getEntity);

{
	AS_data_allCosts setVariable [_x, 50];
} forEach (["FIA", "water_vehicles"] call AS_fnc_getEntity);

// cost of statics
{AS_data_allCosts setVariable [_x, 300];} foreach (["FIA", "static_mg"] call AS_fnc_getEntity);
{AS_data_allCosts setVariable [_x, 1200];} foreach (["FIA", "static_at"] call AS_fnc_getEntity);
{AS_data_allCosts setVariable [_x, 1200];} foreach (["FIA", "static_aa"] call AS_fnc_getEntity);
{AS_data_allCosts setVariable [_x, 1200];} foreach (["FIA", "static_mortar"] call AS_fnc_getEntity);

// costs of land vehicles
private _costs = ["FIA", "costs"] call AS_fnc_getEntity;
{
	AS_data_allCosts setVariable [_x, [_costs, _x] call DICT_fnc_get];
} forEach allVariables _costs;

// cost of units
AS_data_allCosts setVariable ["Crew", 50];
AS_data_allCosts setVariable ["Rifleman", 50];
AS_data_allCosts setVariable ["Grenadier", 50];
AS_data_allCosts setVariable ["Autorifleman", 50];
AS_data_allCosts setVariable ["Medic", 250];
AS_data_allCosts setVariable ["Squad Leader", 100];
AS_data_allCosts setVariable ["Engineer", 250];
AS_data_allCosts setVariable ["Explosives Specialist", 150];
AS_data_allCosts setVariable ["AT Specialist", 50];
AS_data_allCosts setVariable ["AA Specialist", 50];
AS_data_allCosts setVariable ["Sniper", 50];

AS_allFIARecruitableSoldiers = AS_allFIAUnitTypes - ["Survivor"];

// set of all FIA vehicles
private _vehicles = [];
{
	_vehicles append (["FIA", _x] call AS_fnc_getEntity);
} forEach ["land_vehicles", "air_vehicles", "water_vehicles"];
[AS_entities, "FIA" call AS_fnc_getFaction, "vehicles", _vehicles] call DICT_fnc_set;

civHeli = ["FIA", "air_vehicles"] call AS_fnc_getEntity;
