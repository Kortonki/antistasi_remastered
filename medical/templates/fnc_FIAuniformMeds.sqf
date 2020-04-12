private _return = [];
private _availableItems = getItemCargo caja;
private _itemList = _availableItems select 0;
private _countList = _availableItems select 1;

if hasACEmedical then {
    if (!(isnil "ace_medical_level") and {ace_medical_level == 1}) then {
        _return = [["ACE_tourniquet", 1], ["ACE_fieldDressing", 8], ["ACE_morphine", 2], ["ACE_epinephrine", 1]];
    } else {

        _return = [["ACE_tourniquet", 1], ["ACE_fieldDressing", 6],["ACE_packingBandage", 1], ["ACE_quikclot", 2], ["ACE_morphine", 2], ["ACE_epinephrine", 1]];

    };

} else {
    _return = [["FirstAidKit", 3]];
};

//TODO: optimise array operations
{
    private _item = _x select 0;
    if (_item in _itemList) then {
      private _index1 = _itemList find _item;
      private _amount = (((_countList select _index1) - 10) max 0) min (_x select 1); //Leave minimum of 10 of each item to the players
      (_return select _foreachindex) set [1, _amount]; //Take all of available
    } else {
      if !(_item in unlockedItems) then {
        (_return select _foreachindex) set [1, 0];
      };
    };

} foreach _return;

_return
