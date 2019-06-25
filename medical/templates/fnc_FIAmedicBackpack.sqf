private _return = [];
private _availableItems = getItemCargo caja;
private _itemList = _availableItems select 0;
private _countList = _availableItems select 1;


if hasACEmedical then {
    if (ace_medical_level == 1) then {
        // order matters: items will be add sequentially until bag is full.

        _return = [["ACE_tourniquet", 5], ["ACE_fieldDressing", 30], ["ACE_morphine", 20], ["ACE_epinephrine", 10], ["ACE_bloodIV", 1],  ["ACE_bloodIV_250", 4],  ["ACE_bloodIV_500", 4]];
    } else {

        _return = [["ACE_tourniquet", 5], ["ACE_fieldDressing", 20], ["ACE_morphine", 20], ["ACE_epinephrine", 10], ["ACE_packingBandage", 10], ["ACE_quikclot", 10],["ACE_elasticBandage", 10],["ACE_adenosine", 10]];

        if (hasACEsplint) then {_return pushBack ["adv_aceSplint_splint", 5]};

        //Check whether there's saline or blood. Prioritize blood.
        private _bloods = [];
        private _fluids = [];
        {
            if (_x find "blood") then {_bloods pushback _x};
            if (_x find "saline") then {_fluids pushback _x};
        } foreach (_itemList + unlockedItems);

          {
            _return pushBack [_x, 2];
          } foreach _bloods;

        if (count _bloods < 4) then {
          {
          _return pushBack [_x, 2];
            if (_foreachindex > 3) exitWith {}; //Don't take too much fluids
          } foreach _fluids;
        };



    };

} else {
    _return = [["Medikit", 1], ["FirstAidKit", 10]];
};

//CHECK for availability

{
    private _item = _x select 0;
    if (_item in _itemList) then {
      private _index1 = _itemList find _item;
      (_return select _foreachindex) set [1, (_countList select _index1)]; //Take all of available
    } else {
      if !(_item in unlockedItems) then {
        (_return select _foreachindex) set [1, 0];
      };
    };

} foreach _return;

//TODO optimise here to delete "empty" arrays (amount is 0) afterwards

_return
