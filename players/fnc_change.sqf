#include "../macros.hpp"
AS_SERVER_ONLY("players_fnc_change");
//TODO more universal way to clear data
params ["_player", "_attribute", "_difference", ["_notify", true], ["_clearTraits", false]];
private _id = getPlayerUID _player;

private _old_amount = [_player, _attribute] call AS_players_fnc_get;
if (_attribute == "money") then {
    // must be a positive value
    _difference = (-_old_amount) max _difference;
};

[AS_container, "players", _id, _attribute, _old_amount + _difference] call DICT_fnc_setGlobal;

if (_attribute == "traits") then {
    if (_clearTraits) then {
    [AS_container, "players", _id, _attribute, []] call DICT_fnc_setGlobal;
  };
};

if (_notify and {_attribute == "money"}) then {
    private _texto = format ["<br/><br/><br/><br/><br/><br/>Money %1 €", _difference];
	[_player, "income", _texto] remoteExec ["AS_fnc_localCommunication", _player];
};
