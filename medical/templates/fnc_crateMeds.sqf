params [["_amount", 1], ["_ignoreUnlocked", false]];

private _unlocked = [];
private _items = [[],[]];
//This is so NATO drop doesn't contain unloced items
if (_ignoreUnlocked) then {
  _unlocked = unlockedItems;
};

if hasACEmedical then {

		private _medicalItems = AS_aceBasicMedical;

		if ((!(isnil "ace_medical_level") and {ace_medical_level == 2}) or (isnil "ace_medical_level")) then {_medicalItems append AS_aceAdvMedical}; //Nil checked for new ace medical where there's no med. level (investigate)

		if (hasACEsplint) then {_medicalItems pushBack "ACE_splint"};

		{

					//Table of medical equipment amounts (Natosupp / 10 * _coeff)
          //TODO remove random items, better would be weighted randomisation for basic stuff. Now amount is random depending on support

					private _coeff = [_x] call {
            private _item = _this select 0;
						if (_item == "ACE_fieldDressing") exitWith {20};
						if (_item == "ACE_quikclot") exitWith {10};
						if (_item == "ACE_tourniquet") exitWith {10};
						if (_item == "ACE_morphine") exitWith {4};
						if (_item == "ACE_epinephrine") exitWith {2};
						if (_item == "ACE_adenosine") exitWith {2};
            if (_item == "ACE_atropine") exitWith {2};
						if (_item == "ACE_personalAidKit") exitWith {0.5};
						if (_item == "ACE_surgicalKit") exitWith {0.5};
						if (_item == "ACE_splint") exitWith {2};
						if ((_item find "saline") > -1) exitWith {2};
            if ((_item find "plasma") > -1) exitWith {1};
						if ((_item find "blood") > -1) exitWith {0.5};
						if ((_item find "Bandage") > -1) exitWith {10};

						1
					};

					(_items select 0) pushBack _x;
					(_items select 1) pushBack (round ((random _amount)*_coeff));


		} foreach (_medicalItems - _unlocked);

} else {

	(_items select 0) pushBack "FirstAidKit";
	(_items select 1) pushBack (floor ((random _amount)*10));

	(_items select 0) pushBack "Medikit";
	(_items select 1) pushBack (floor (random _amount));

};

_items
