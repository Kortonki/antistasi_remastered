#include "../macros.hpp"
// create container to store spawns
call AS_spawn_fnc_initialize;

call AS_mission_fnc_initialize;

// reguarly checks for players and stores their profiles
call AS_players_fnc_initialize;

call AS_AAFarsenal_fnc_initialize;

call AS_database_fnc_init;

// Names of camps used when the camp is spawned.
campNames = ["Spaulding","Wagstaff","Firefly","Loophole","Quale","Driftwood","Flywheel","Grunion","Kornblow","Chicolini","Pinky",
			"Fieramosca","Bulldozer","Bambino","Pedersoli"];

// todo: improve this.
expCrate = "Box_Syndicate_Wps_F"; // dealer's crate

AS_commander = objNull;
publicVariable "AS_commander";

///////////////////////// PERSISTENTS /////////////////////////

// AS_Pset(a,b) is a macro to `(AS_persistent setVariable (a,b,true))`.
// P from persistent as these variables are saved persistently.

// List of locations that are being patrolled.
AS_Pset("patrollingLocations", []);
AS_Pset("patrollingPositions", []);

// These are default values for the start.

private _startHr = paramsArray select 0;
private _startMoney = paramsArray select 1;
private _startFuel = paramsArray select 2;
private _startNS = paramsArray select 3;
private _upFreq = paramsArray select 4;

//TODO improve randomising so expected is at default but max values are possible

if (_startHr == -1) then {_startHr = round(50*((random 1)^2.32))};
if (_startMoney == -1) then {_startMoney = round(10000*((random 1)^3.32))};
if (_startFuel == -1) then {_startFuel = round(10000*((random 1)^3.32))};
if (_startNS == -1) then {_startNS = round(100*((random 1)^4.322))};


AS_Pset("hr",_startHr); //initial HR value
AS_Pset("hr_cum", 0); //Cumulative hr buildup for resource updates
AS_Pset("resourcesFIA",_startMoney); //Initial FIA money pool value
AS_Pset("fuelFIA", _startFuel); //Initial FIA fuel reserves
AS_Pset("ammoFIA", 0); //Initial FIA fuel reserves

AS_Pset("resourcesAAF",10000); //Initial AAF resources
AS_Pset("skillFIA",0); //Initial skill level of FIA
AS_Pset("skillAAF",4); //Initial skill level of AAF
AS_Pset("NATOsupport",_startNS); //Initial NATO support
AS_Pset("CSATsupport",5); //Initial CSAT support

AS_Pset("secondsForAAFattack",2*_upFreq);  // The time for the attack script to be run
private _nextAttack = [date select 0, date select 1, date select 2, date select 3, (date select 4) + (2*_upFreq/60)];
_nextAttack = datetoNumber _nextAttack;
AS_Pset("nextAttack", _nextAttack);




AS_Pset("destroyedLocations", []); // Locations that are destroyed (can be repaired)
AS_Pset("knownLocations", []); //FIA locations discovered by the AAF
AS_Pset("vehicles", []);  // list of vehicles that are saved in the map

// list of positions where closest building is destroyed.
// The buildings that belong to this are in `AS_destroyable_buildings`.
AS_Pset("destroyedBuildings", []);

AS_Pset("vehiclesInGarage", []);

// These are game options that are saved.
AS_Pset("civPerc",0.05); //initial % civ spawn rate
AS_Pset("spawnDistance",1200); //initial spawn distance. Less than 1Km makes parked vehicles spawn in your nose while you approach.
AS_Pset("minimumFPS",15); //initial minimum FPS. This value can be changed in a menu.
AS_Pset("cleantime",60*60); // time to delete dead bodies and vehicles.
AS_Pset("minAISkill",0.3); // The minimum skill of the AAF/FIA AI (at lowest skill level)
AS_Pset("maxAISkill",0.9); // The maximum skill of the AAF/FIA AI (at highest skill level)

// Weather PERSISTENTS
/* these are defaulted in changeWeather for legacy saves
AS_Pset("overcast", 0);
AS_Pset("rain", 0);
AS_Pset("windDir", 0);
AS_Pset("windSpeed", 0);
AS_Pset("gusts", 0);
AS_Pset("lightnings", 0);
AS_Pset("waves", 0);
AS_Pset("fog", 0);
*/
[] call AS_weather_fnc_init;
[] spawn AS_weather_fnc_randomWeather;

AS_Pset("clear", false); //This to signal weather module to not keep default clear weather
//TODO: Parameter option to disable weather changes

AS_spawnLoopTime = 2; // seconds between each check of spawn/despawn locations (expensive loop).
publicVariable "AS_spawnLoopTime";

private _nextUpdate = [date select 0, date select 1, date select 2, date select 3, (date select 4)];
_nextUpdate = datetoNumber _nextUpdate;
AS_Pset("upFreq", _upFreq);
AS_Pset("nextUpdate", _nextUpdate);

// AS_Sset(a,b) is a macro to `(server setVariable (a,b,true))`.
// S of [s]hared. These variables are not saved persistently.
AS_Sset("revealFromRadio",false);

// number of patrols currently spawned.
AS_Sset("AAFpatrols", 0);

// Used to make a transfer to `caja` atomic
AS_Sset("lockTransfer", false);
AS_Sset("lockArsenal", false);

// This sets whether the CSAT can attack or not. The FIA has an option to block
// attacks by jamming radio signals (close to flags with towers)
AS_Sset("blockCSAT", false);

// list of vehicles (objects) that can no longer be used while undercover
AS_Sset("reportedVehs", []);

AS_Sset("AS_vehicleOrientation", 0);

AS_AAF_attackLock = nil;



// The max skill that AAF or FIA can have (BE_module).
AS_maxSkill = 20;
publicVariable "AS_maxSkill";

//Percentage how much FIA funds are given to players each update
AS_players_share = 5;

// BE_modul handles all the permissions e.g. to build roadblocks, skill, etc.
#include "..\Scripts\BE_modul.sqf"
