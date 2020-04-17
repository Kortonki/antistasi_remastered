#include "../macros.hpp"

params ["_itemArray"];

private _text = "";

if (count (_itemArray select 0) == 0) exitWith {
  if (random 10 <= 1) then {
    if (random 10 <= 2 and {count (AS_P("aphorisms")) > 0}) then {
      private _aphorisms = AS_P("aphorisms");
      private _aphorism = selectrandom _aphorisms;
      _aphorisms = _aphorisms - [_aphorism];
      AS_Pset("aphorisms", _aphorisms);
      ["con_bas"] remoteExec ["fnc_BE_XP", 2];
      ("After taking a closer look, you find a piece of paper lying there. It says:\n\n""" + (_aphorism select 0) + """\n\n  - " + (_aphorism select 1) + "\n\nSuddenly a gust of wind rips the piece from your grasp and is forever lost. All you can do is to scold yourself for your sloppiness. Hopefully the person who had written the note didn't do it in vain and you managed to gain some wisdom.")
    } else {
      "A giant pile of absolutely nothing"
    };
  } else {
    "Nothing"
  };
};

private _intend = "";

{
  private _name = _x;
  private _count = (_itemArray select 1) select _forEachIndex;

  call {
    //Extra spacing when item type changes
    if (_name in ["Weapon", "Magazine", "Explosive", "Item", "Medical item", "Bag", "Partial magazine"]) exitWith {

      if (_count > 1) then {_name = _name + "s"};
      _intend = "";
      _text = format ["%1\n\n%2%3 %4:\n", _text, _intend, _count, toUpper _name];
      _intend = "  ";
    };

    if (_count > 1)  then {
      _name = _name + "s";
    };

    _text = format ["%1\n%2%3 %4", _text, _intend, _count, _name];

  };

} foreach (_itemArray select 0);

_text
