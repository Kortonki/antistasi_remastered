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

//ARSENAL INIT
[[[],[]],[[],[]],[[],[]],[[],[]]] call AS_fnc_setArsenal;

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


AS_Pset("hr",_startHr + count (allPlayers - (entities "HeadlessClient_F"))); //initial HR value
AS_Pset("hr_cum", 0); //Cumulative hr buildup for resource updates
AS_Pset("resourcesFIA",_startMoney + (50 * count (allPlayers - (entities "HeadlessClient_F")))); //Initial FIA money pool value
AS_Pset("fuelFIA", _startFuel); //Initial FIA fuel reserves

//AAF money

private _AAFmoney = 2000 * (count ([["base","airfield","outpost","resource","factory","powerplant","seaport"],"AAF"] call AS_location_fnc_TS));

AS_Pset("resourcesAAF",_AAFmoney); //Initial AAF resources
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
AS_Pset("civPerc",0.01); //initial % civ spawn rate
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

// This sets whether the CSAT can attack or not. The FIA has an option to block
// attacks by jamming radio signals (close to flags with towers)
AS_Sset("blockCSAT", false);

// list of vehicles (objects) that can no longer be used while undercover
AS_Sset("reportedVehs", []);

AS_Sset("AS_vehicleOrientation", 0);

//Counter for spawned AAF vehicles

{
	private _name = format ["spawned_%1", _x];
	AS_Sset(_name, 0);
} foreach (call AS_AAFarsenal_fnc_all);

//Set some vehicles
{
	private _max = _x call AS_AAFarsenal_fnc_max;
	private _amount =  round((0.75+(random 0.25))*_max);
	[_x, "count", _amount] call AS_AAFarsenal_fnc_set;
} foreach ["cars_transport", "cars_armed", "trucks", "boats", "static_mg", "static_at", "static_aa", "static_mortar", "apcs"];


AS_AAF_attackLock = nil;



// The max skill that AAF or FIA can have (BE_module).
AS_maxSkill = 20;
publicVariable "AS_maxSkill";

//Percentage how much FIA funds are given to players each update
AS_players_share = 5;

lockArsenal = false;

// BE_modul handles all the permissions e.g. to build roadblocks, skill, etc.
#include "..\Scripts\BE_modul.sqf"

[] call AS_stats_fnc_initialize;

AS_active_messages = [];















































AS_aphorisms = [
["If you know the enemy and know yourself you need not fear the results of a hundred battles.","Sun Tzu"],
["A good commander is benevolent and unconcerned with fame.","Sun Tzu"],
["Quickness is the essence of the war.","Sun Tzu"],
["Let your plans be dark and impenetrable as night, and when you move, fall like a thunderbolt.","Sun Tzu"],
["He will win who knows when to fight and when not to fight.","Sun Tzu"],
["A clever General avoids an army when its spirit is keen, but attacks when it is sluggish and inclined to return. This is the art of studying moods. Disciplined and calm, he awaits the appearance of disorder and hubbub amongst the enemy - This is the art of retaining self-possession.","Sun Tzu"],
["Move only if there is a real advantage to be gained","Sun Tzu"],

["A single death is a tragedy; a million deaths is a statistic.","Joseph Stalin"],
["At the end of the game, the king and the pawn go back in the same box.","Italian Proverb"],
["Experience is a hard teacher because she gives the test first, the lesson afterward","Vernon Law"],
["Mankind must put an end to war, or war will put an end to mankind.","John Fitzgerald Kennedy"],
["Men are at war with each other because each man is at war with himself.","Francis Meehan"],
["I am the one who knocks!","Walter White"],
["The object of war is not to die for your country but to make the other bastard die for his","General G. C. Patton"],
["War isn't about who's right, its about who's left.","Anders Russell"],
["Much good work is lost for the lack of a little more.","Edward Harriman"],
["Stay out of the road, if you want to grow old.","Pink Floyd"],
["War is a series of disasters which result in a winner","Georges Clemenceau"],

["You have to remember something: Everybody pities the weak; jealousy you have to earn.","Arnold Schwarzenegger"],
["The mind is the limit. As long as the mind can envision the fact that you can do something, you can do it, as long as you really believe 100 percent.","Arnold Schwarzenegger"],
["The more knowledge you have, the more you’re free to rely on your instincts.","Arnold Schwarzenegger"],

["Sitten joukkueen pitää ottaa se pää pois perseestä ja lattaa ne taistelija toimimaan. Täällä nyt vaan nukutaan kokoaika","Blahh"],
["Hei nyt ekanakin tehdään sillätavalla että, menkää vittuun siitä","Tonto"]


];

AS_Pset("aphorisms", AS_aphorisms);
