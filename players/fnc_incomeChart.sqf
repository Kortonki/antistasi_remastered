#include "../macros.hpp"
AS_SERVER_ONLY("players_fnc_incomeChart");

//_Playerincomes format: [player, income]
params [["_playerIncomes",[]]];

private _count = count _playerIncomes;

private _list = [_playerIncomes, [], {_x select 1}, "DESCEND"] call BIS_fnc_sortBy;

private _text = "<t size='1.2'>FIA Earners TOP 5:</t><br/><br/>";

for "_i" from 0 to ((_count - 1) min 4) do {
  private _player = ((_list select _i) select 0);
  private _income = ((_list select _i) select 1);
  private _rank = AS_rank_abbreviations select (AS_ranks find ([_player, "rank"] call AS_players_fnc_get));
  if (_i == 0) then {
    _text = _text + (format ["<t size='1.0'>%1 %2: %3 €</t><br/>", _rank, name _player, _income]);
  } else {
    _text = _text + (format ["<t size='0.8'>%1 %2: %3 €</t><br/>", _rank, name _player, _income]);
  };
};

[petros, "income", _text] remoteExec ["AS_fnc_localCommunication", [0,-2] select isDedicated];
