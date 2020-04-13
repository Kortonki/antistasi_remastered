params ["_arsenal", "_unit"];

_arsenal params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b"];

private _old_cargo = _unit getVariable "old_Cargo";

private _new_cargo = [_unit, true] call AS_fnc_getUnitArsenal;

// add all the old stuff and removes all the new stuff.
_cargo_w = [_cargo_w, _old_cargo select 0] call AS_fnc_mergeCargoLists;
_cargo_m = [_cargo_m, _old_cargo select 1] call AS_fnc_mergeCargoLists;
_cargo_i = [_cargo_i, _old_cargo select 2] call AS_fnc_mergeCargoLists;
_cargo_b = [_cargo_b, _old_cargo select 3] call AS_fnc_mergeCargoLists;

//[_old_cargo] remoteExec ["AS_fnc_addtoArsenal", 2];

//Deduct new cargo (after using arsenal) from arsenal
_cargo_w = [_cargo_w, _new_cargo select 0, false] call AS_fnc_mergeCargoLists;
_cargo_m = [_cargo_m, _new_cargo select 1, false] call AS_fnc_mergeCargoLists;
_cargo_i = [_cargo_i, _new_cargo select 2, false] call AS_fnc_mergeCargoLists;
_cargo_b = [_cargo_b, _new_cargo select 3, false] call AS_fnc_mergeCargoLists;

//TODO Remove non-existants (above function doesn't) by creating them and making their amount zero in _cargo's ->
//Doesn't effect populate function, loops won't run for 0s

_cargo_w = [_cargo_w, _new_cargo select 0] call AS_fnc_createCargoLists;
_cargo_m = [_cargo_m, _new_cargo select 1] call AS_fnc_createCargoLists;
_cargo_i = [_cargo_i, _new_cargo select 2] call AS_fnc_createCargoLists;
_cargo_b = [_cargo_b, _new_cargo select 3] call AS_fnc_createCargoLists;




// remove from unit items that are not available.
for "_i" from 0 to (count (_cargo_b select 0) - 1) do {
	private _name = (_cargo_b select 0) select _i;
	private _amount = (_cargo_b select 1) select _i;
	if (_amount <= 0) then {
		for "_j" from 0 to (-_amount - 1) do {
            _old_cargo = [backpackContainer _unit, false] call AS_fnc_getBoxArsenal;
            _cargo_w = [_cargo_w, _old_cargo select 0] call AS_fnc_mergeCargoLists;
            _cargo_m = [_cargo_m, _old_cargo select 1] call AS_fnc_mergeCargoLists;
            _cargo_i = [_cargo_i, _old_cargo select 2] call AS_fnc_mergeCargoLists;
            _cargo_b = [_cargo_b, _old_cargo select 3] call AS_fnc_mergeCargoLists;

            //[_old_cargo] remoteExecCall ["AS_fnc_addToArsenal", 2];
			removeBackpack _unit;
		};
	};
};

// Remove vests only. This is a container, so it has to be before all other stuff.
for "_i" from 0 to (count (_cargo_i select 0) - 1) do {
	private _name = (_cargo_i select 0) select _i;
	private _amount = (_cargo_i select 1) select _i;
	if (_amount < 0 and (_name in AS_allVests)) exitWith {  // exitWith because unit can only have one vest.
        private _old_cargo = [vestContainer _unit, false] call AS_fnc_getBoxArsenal;
        _cargo_w = [_cargo_w, _old_cargo select 0] call AS_fnc_mergeCargoLists;
        _cargo_m = [_cargo_m, _old_cargo select 1] call AS_fnc_mergeCargoLists;
        _cargo_i = [_cargo_i, _old_cargo select 2] call AS_fnc_mergeCargoLists;
        _cargo_b = [_cargo_b, _old_cargo select 3] call AS_fnc_mergeCargoLists;

        //[_old_cargo] remoteExecCall ["AS_fnc_addToArsenal", 2];
        removeVest _unit;
	};
};

// weapons may contain items and mags, so we need to remove them first
for "_i" from 0 to (count (_cargo_w select 0) - 1) do {
	private _name = (_cargo_w select 0) select _i;
	private _amount = (_cargo_w select 1) select _i;
	if (_amount < 0) then {
		for "_j" from 0 to (-_amount - 1) do {  // _amount == 0 means this does nothing, which is fine.
            private _items = [];
            private _mags = [];
            if (primaryWeapon _unit == _name) then {
                _items = primaryWeaponItems _unit;
                _mags = _mags + primaryWeaponMagazine _unit;
            };
            if (secondaryWeapon _unit == _name) then {
                _items = secondaryWeaponItems _unit;
                _mags = _mags + secondaryWeaponMagazine _unit;
            };
            if (handgunWeapon _unit == _name) then {
                _items = handgunItems _unit;
                _mags = _mags + handgunMagazine _unit;
            };
            // store the current mag
            _cargo_i = [_items, _cargo_i] call AS_fnc_listToCargoList;
            _cargo_m = [_mags, _cargo_m] call AS_fnc_listToCargoList;

          //  [[[],[]],_cargo_m,_cargo_i,[[],[]]] remoteExecCall ["AS_fnc_addToArsenal", 2];
			_unit removeWeaponGlobal _name;
		};
	};
};
private _magRemoved = 0;
for "_i" from 0 to (count (_cargo_m select 0) - 1) do {
	private _name = (_cargo_m select 0) select _i;
	private _amount = (_cargo_m select 1) select _i;
	if (_amount <= 0) then {
    private _loaded = false;
    private _magsize = (getNumber (configFile >> "cfgMagazines" >> _name >> "count"));
		for "_j" from 0 to (-_amount - 1) do {

      //Remove loaded mags first
      _loaded = false;
      {
          if (_x select 2 and {(_x select 1 == _magsize)}) exitWith { //added condition to not empty the same mag all over again. don't delete halfway mag that might be in players weapon
            switch (_x select 3) do {
              case 1 : {_unit setammo [primaryWeapon _unit, 0]};
              case 2 : {_unit setammo [handgunWeapon _unit, 0]};
              case 4 : {_unit setammo [secondaryWeapon _unit, 0]};
            };
            _loaded = true;
            _magRemoved = _magRemoved + 1;
          };


      }
      foreach magazinesAmmoFull _unit;

      if (!(_loaded)) then {
        _unit removeMagazineGlobal _name;
        _magRemoved = _magRemoved + 1;
      };
		};
	};
};

if (_magRemoved > 0) then {
  private _text = format ["%1 Magazines removed", _magRemoved];
  [petros, "hint", _text, 2] spawn AS_fnc_localCommunication;

};

for "_i" from 0 to (count (_cargo_i select 0) - 1) do {
	private _name = (_cargo_i select 0) select _i;
	private _amount = (_cargo_i select 1) select _i;
    if (_amount <= 0 and !(_name in AS_allVests)) then {
        call {
            if (_amount < 0 and (_name in AS_allHelmets)) exitWith {  // no need to remove the item from the player, so exitWith
                removeHeadgear _unit;
            };
            // todo: if in AS_allGoogles, exitWith removeGoogles
            if (_amount < 0 and (_name in (AS_allNVGs + AS_allBinoculars))) then {
                _unit unassignItem _name;
            };
            if (_amount < 0) then {
                for "_j" from 0 to (-_amount - 1) do {
                    _unit removeItem _name;
                };
            };
        };
    };
};

//private _final_cargo = [_unit, true] call AS_fnc_getUnitArsenal;

//[_final_cargo] remoteExecCall ["AS_fnc_removeFromArsenal", 2];

//Unnecessary fiddling commented out. It was unreliable to add / remove stuuff from arsenal
//when it can happen in any order using remoteExec(call) causing mags to appear from nowhere
//Now simplified with cargo tracked with only _cargo variables and then in the end resetting
//arsenal with it

//UPDATE arsenal with remaining

//Populate with new cargo, called so no simultaneous calcs
[caja, _cargo_w, _cargo_m, _cargo_i, _cargo_b, true, true] remoteExecCall ["AS_fnc_populateBox", 2];
_unit setVariable ["arsenalPoll", nil];
_unit setVariable ["old_Cargo", nil, false];
