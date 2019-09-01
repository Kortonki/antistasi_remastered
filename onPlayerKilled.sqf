//params ["_old"];
//[_old] spawn AS_fnc_respawnPlayer;
hint "The hit was so violent that you died instantly...";

["deathP"] remoteExec ["fnc_be_XP", 2];

{
		player setUnitTrait [_x, false];

} foreach ([player, "traits"] call AS_players_fnc_get);

[player, "traits", [], false, true] remoteExec ["AS_players_fnc_change"];

removeAllActions player;

if (isMultiplayer) then {[player, "score", -10] remoteExec ["AS_players_fnc_change", 2];};


//Commented out because of possible double respawning in onPlayerRespawn.sqf
