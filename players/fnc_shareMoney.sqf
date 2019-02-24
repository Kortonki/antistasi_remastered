#include "../macros.hpp"
AS_SERVER_ONLY("players_fnc_shareMoney");

params ["_money"];
private _players = (allPlayers - entities "HeadlessClient_F");
if (count _players < 1) exitWith {diag_log "[AS]: No players online, no money shared"};

private _list  = [];

//Make an array of all players grouped by their ranks

{
    private _curr_index = (AS_ranks find _x);
    private _sameRank = [];

    //Check rest of the players for the same rank and put them into same subarray
    {
        _sameRank pushback _x;
        _players = _players - [_x];
    } foreach (_players select {(AS_ranks find ([_x, "rank"] call AS_players_fnc_get)) == _curr_index});

    //Put that array into the final array ordered privates first, colones last

    _list pushBack _sameRank;

} foreach AS_ranks;

//Now the array is colonels first;
//if more than on in that rank, "steal" share from lower rank and share the total 50% + 25% / 2 -> 37,5%
//What is left over is given to the commander
reverse _list;

//This is for presentation purposes
private _playerIncomes = [];
private _commanderIndex = 0;

private _moneyLeft = _money; //This is what is left of the share
{
    private _count = count _x; //This is the number of players with the same rank
    private _share = 0;
    if (_count > 0) then {
      private _sameRank = _x;
      //private _share = _shares select _forEachindex;
      //Add to the rank spesific share. Allways take half of what is left
      {
        _share = round(_share + (_moneyLeft/2));
        _moneyLeft = _moneyLeft - _share;
      } foreach _sameRank;
      //Share the money inside ranks
      {
        private _playerIncome = round(_share/_count);
        [_x, "money", _playerIncome] call AS_players_fnc_change;
        //TODO: this is for presentation
        _playerIncomes pushback [_x, _playerIncome];
        if (_x == AS_commander) then {_commanderIndex = (count _playerIncomes) - 1};

      } foreach _sameRank;
    };
    //_shares pushback _share; //Now the order of shares is same as the order of ranks: no need to reverse
} foreach _list;

//Give the rest to the commander

[AS_commander, "money", _moneyLeft] call AS_players_fnc_change;
private _commanderMoney = ((_playerIncomes select _commanderIndex) select 1) + _moneyLeft;
(_playerIncomes select _commanderIndex) set [1, _commanderMoney];

[_playerIncomes] spawn AS_players_fnc_IncomeChart;

[0, -(_money)] spawn AS_fnc_changeFIAmoney;
