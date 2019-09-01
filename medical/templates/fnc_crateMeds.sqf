params [["_amount", 1], ["_ignoreUnlocked", false]];

private _unlocked = [];
private _items = [[],[]];
//This is so NATO drop doesn't contain unloced items
if (_ignoreUnlocked) then {
  _unlocked = unlockedItems;
};

if hasACEmedical then {

		private _medicalItems = AS_aceBasicMedical;

		if (ace_medical_level == 2) then {_medicalItems append AS_aceAdvMedical};

		if (hasACEsplint) then {_medicalItems pushBack "adv_aceSplint_splint"};

		{
			if (random 5 < _amount) then {

					//Table of medical equipment amounts (Natosupp / 10 * _coeff)

					private _coeff = [_x] call {
            private _item = _this select 0;
						if (_item isEqualTo "ACE_fieldDressing") exitWith {20};
						if (_item isEqualTo "ACE_quikclot") exitWith {10};
						if (_item isEqualTo "ACE_tourniquet") exitWith {10};
						if (_item isEqualTo "ACE_morphine") exitWith {6};
						if (_item isEqualTo "ACE_epinephrine") exitWith {3};
						if (_item isEqualTo "ACE_adenosine") exitWith {3};
						if (_item isEqualTo "ACE_personalAidKit") exitWith {1};
						if (_item isEqualTo "ACE_surgicalKit") exitWith {1};
						if (_item isEqualTo "adv_aceSplint_splint") exitWith {4};
						if ((_item find "saline") > -1) exitWith {2};
						if ((_item find "blood") > -1) exitWith {1};
						if ((_item find "Bandage") > -1) exitWith {10};

						1
					};

					(_items select 0) pushBack _x;
					(_items select 1) pushBack _amount*_coeff;
				};

		} foreach (_medicalItems - _unlocked);

} else {

	(_items select 0) pushBack "FirstAidKit";
	(_items select 1) pushBack _amount*10;

	(_items select 0) pushBack "Medikit";
	(_items select 1) pushBack _amount;

};

_items
