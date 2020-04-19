//new function to tell how much stuff is in the arsenal

params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b", ["_magRemains", []]];

private _itemArray = [[],[]];

private _fnc_addToArray = {
  params ["_name", "_amount2"];

  private _names = (_itemArray select 0);
  private _amounts = (_itemArray select 1);
  private _index = _names find _name;

  if (_index != -1) then {
    private _amount1 = _amounts select _index;
    _amounts set [_index, _amount1 + _amount2];
  } else {
    _names pushback _name;
    _amounts pushback _amount2;
  };

};

//WEAPONS

private _fnc_weapon_category = {
  params ["_class"];

  //This is a common name used for mags and weapons: For weapons 's' will be added if plural
  private _name = "";
  switch (_class) do {
    case 0 : {_name = "Assault rifle"};
    case 1 : {_name = "Bomb launcher"};
    case 2 : {_name = "Cannon"};
    case 3 : {_name = "Grenade launcher"};
    case 4 : {_name = "Pistol"};
    case 5 : {_name = "Launcher"};
    case 6 : {_name = "Machine gun"};
    case 7 : {_name = "Mine"};
    case 8 : {_name = "Missile launcher"};
    case 9 : {_name = "Mortar"};
    case 10 : {_name = "Rocket launcher"};
    case 11 : {_name = "Shotgun"};
    case 12 : {_name = "Throwable"};
    case 13 : {_name = "Rifle"};
    case 14 : {_name = "Submachinegun"};
    case 15 : {_name = "Sniper rifle"};
  };

  _name

};

{
  private _name = _x;
  private _count = (_cargo_w select 1) select _foreachIndex;
  call {

    if (_count <= 0) exitWIth {};

    //Put binoculars to item array to be shown later
    if (_name in AS_allBinoculars) exitWith {
      //["Binocular", _count] call _fnc_addToArray;
      (_cargo_i select 0) pushback _name;
      (_cargo_i select 1) pushback _count;

    };

    ["Weapon", _count] call _fnc_addtoArray;

    {
      if (_name in _x) exitWith {
        private _category = [_forEachIndex] call _fnc_weapon_category;
        if (_category != "") then {
          [_category, _count] call _fnc_addToArray;
        };
      };
    } foreach AS_weapons;

  };

} foreach (_cargo_w select 0);

//MAGAZINES
private _fnc_magazineType = {
  params ["_magazine"];
  //Picks up first weapon to match with the mag and its category

  private _category = "Miscellaneous";
  private _exit = false;

  {
    private _type = _x;
    private _typeIndex = _forEachIndex;
    {
      private _weapon = _x;

      if (_magazine in (getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines"))) exitWith {
         _category = [_typeIndex] call _fnc_weapon_category;
         _exit = true;
      };
    } foreach _type;
    if _exit exitWith {};
  } foreach AS_weapons;

_category
};


{
  private _name = _x;
  private _count = (_cargo_m select 1) select _foreachIndex;
  call {

    if (_count <= 0) exitWIth {};

    if (_name in AS_allThrowGrenades) exitWith {
      ["Hand grenade", _count] call _fnc_addToArray;
    };

    if (_name in AS_allThrowSmokes) exitWith {
      ["Smoke shell", _count] call _fnc_addToArray;
    };

    if (_name in AS_allGrenades) exitWith {
      ["Rifle grenade", _count] call _fnc_addToArray;
    };

    if (_name in AS_allMinesMags) exitWith {
      ["Explosive", _count] call _fnc_addToArray;
      if (_name in (call AS_fnc_allATmines)) then {
        ["AT mine", _count] call _fnc_addToArray;
      };
      if (_name in (call AS_fnc_allAPmines)) then {
        ["AP mine", _count] call _fnc_addToArray;
      };
    };

    //This moved to below so handgrenades are picked before as_allmagazine picks them
    if (_name in AS_allMagazines) exitWith {
      ["Magazine", _count] call _fnc_addToArray;
      //TODO here a way to distinguish between mags. Consider if classed by usable weapons or caliber
      private _category = [_name] call _fnc_magazineType;
      private _ammotype = ["magazine", "ammo"] select (_category in ["Rocket launcher", "Missile launcher", "Bomb launcher"]);
      [format ["%1 %2", _category, _ammotype], _count] call _fnc_addToArray;
    };

  };
} foreach (_cargo_m select 0);

//ITEMS

//First sort out the items so medical items are last: The list looks sensible

private _delIndex = [];

for "_i" from 0 to (count (_cargo_i select 0)) - 1 do {
  private _name = (_cargo_i select 0) select _i;
  private _count = (_cargo_i select 1) select _i;
  if (_name in AS_allMedicalItems) then {

    _delIndex pushback _i;

    //(_cargo_i select 0) set [_i, objnull]; //Changed to set to nil to not fudge for loop count
  //  (_cargo_i select 1) set [_i, objnull];

    (_cargo_i select 0) pushback _name;
    (_cargo_i select 1) pushback _count;
  };
};

{
  (_cargo_i select 0) deleteAt _x;
  (_cargo_i select 1) deleteAt _x;
} foreach _delIndex;

{
  private _name = _x;
  private _count = (_cargo_i select 1) select _foreachIndex;

  call {
    if (_count <= 0) exitWIth {};

    ["Item", _count] call _fnc_addToArray;

    if (_name in AS_allVests) exitWith {
      ["Vest", _count] call _fnc_addToArray;
    };

    if (_name in AS_allHelmets) exitWith {
      ["Helmet", _count] call _fnc_addToArray;
    };

    if (_name in AS_allOptics) exitWith {
      ["Optic", _count] call _fnc_addToArray;
    };

    if (_name in AS_allBinoculars) exitWith {
      ["Binocular", _count] call _fnc_addToArray;
    };

    if (_name in AS_allNVGs) exitWith {
      ["NVG", _count] call _fnc_addToArray;
    };


    if (_name in AS_allMedicalItems) exitWith {
      ["Medical item", _count] call _fnc_addToArray;
      if (!hasACEmedical) then {
        if (_name == "FirstAidKit") then {
          ["First aid kit", _count] call _fnc_addToArray;
        } else {
          ["Medikit", _count] call _fnc_addToArray;
        };
      } else {
        call {
          if (_name in ["ACE_fieldDressing", "ACE_quikclot", "ACE_elasticBandage", "ACE_packingBandage"]) exitWith {
            ["Bandage", _count] call _fnc_addToArray;
          };

          if (_name in ["ACE_adenosine", "ACE_atropine"]) exitWith {
            ["Other autoinjector", _count] call _fnc_addToArray;
          };
          if (_name == "ACE_morphine") exitWith {
            ["Morphine autoinjector", _count] call _fnc_addToArray;
          };
          if (_name == "ACE_epinephrine") exitWith {
            ["Epinephrine autoinjector", _count] call _fnc_addToArray;
          };

          if (_name find "blood" != -1 or _name find "saline" != -1 or _name find "plasma" != -1) exitWith {
            ["IV bag", _count] call _fnc_addToArray;
          };
          if (_name == "ACE_personalAidKit") exitWith {
            ["Personal aid kit", _count] call _fnc_addToArray;
          };
          if (_name == "ACE_surgicalKit") exitWith {
            ["Surgical kit", _count] call _fnc_addToArray;
          };
          if (_name == "ACE_splint") exitWith {
            ["Splint", _count] call _fnc_addToArray;
          };
        };
      };
    };

    ["Miscellaneous item", _count] call _fnc_addToArray;

  };

} foreach (_cargo_i select 0);

//Backpacks

{
  private _name = _x;
  private _count = (_cargo_b select 1) select _foreachIndex;

  call {

    if (_count <= 0) exitWIth {};

    ["Bag", _count] call _fnc_addToArray;

    if (_name isKindof "UAV_06_backpack_base_F") exitWith {
      ["UAV bag", _count] call _fnc_addToArray;
    };

    if (_name isKindOf "Weapon_Bag_Base") exitWith {
      ["Static backpack", _count] call _fnc_addToArray;
    };

    ["Backpack", _count] call _fnc_addToArray;

  };

} foreach (_cargo_b select 0);

{
  private _name = _x select 0;
  private _count = 1;
  ["Partial magazine", _count] call _fnc_addToArray;

  private _category = [_name] call _fnc_magazineType;
  [format ["Partial %1 magazine", _category], _count] call _fnc_addToArray;


} foreach _magRemains;

_itemArray
