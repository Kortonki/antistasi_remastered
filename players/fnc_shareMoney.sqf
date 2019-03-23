#include "../macros.hpp"
AS_SERVER_ONLY("players_fnc_shareMoney");

params ["_money"];
private _players = (allPlayers - entities "HeadlessClient_F");
if (count _players < 1) exitWith {diag_log "[AS] fnc_shareMoney: No players online, no money shared"};

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

private _moneyLeft = _money; //This is what is left of the share = pot
{
    private _count = count _x; //This is the number of players with the same rank
    private _share = 0;
    if (_count > 0) then {
      private _sameRank = _x;
      //private _share = _shares select _forEachindex;
      //Add to the rank spesific share. Allways take half of what is left
      {
        _share = floor(_share + (_moneyLeft/2)); //with floor the rounding always happens to same "direction"
        _moneyLeft = _moneyLeft - floor(_moneyLeft/2); //the pot is deducted from actual sum taken
      } foreach _sameRank;
      //Share the money inside ranks
      {
        private _playerIncome = floor(_share/_count);
        //Put player incomes into array
        _playerIncomes pushback [_x, _playerIncome];
        if (_x == AS_commander) then {_commanderIndex = (count _playerIncomes) - 1};

      } foreach _sameRank;
      _moneyLeft = floor(_moneyLeft + _share mod (floor (_share/_count))); //Leftovers from rounding are sent back to the pot -> to commander or FIA later
    };
    //_shares pushback _share; //Now the order of shares is same as the order of ranks: no need to reverse
} foreach _list;

//Give the rest to the commander. If no commander, money stays at FIA
if (!(isNull AS_commander)) then {
  private _commanderMoney = ((_playerIncomes select _commanderIndex) select 1) + _moneyLeft;
  _moneyLeft = 0;
  (_playerIncomes select _commanderIndex) set [1, _commanderMoney];
};

//TODO: Consider giving half of the moneyLeft to highest scoring player between updates

//Actuate the money transfers

{
    [_x select 0, "money", _x select 1] call AS_players_fnc_change;
} foreach _playerIncomes;

[_playerIncomes] spawn AS_players_fnc_IncomeChart;

[0, -(_money)+_moneyLeft] spawn AS_fnc_changeFIAmoney; //If no commander, deduct less from FIA
