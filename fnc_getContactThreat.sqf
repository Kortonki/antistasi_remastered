//Group leader makes the judgement of enemy composition

params ["_leader"];

private _threatEval_Land = 0;
private _threatEval_Air = 0;

//private _FIAside = "FIA" call AS_fnc_getFactionSide;


//uses bis_fnc_enemytargets, because might be more optimised. nearTargets version commented

{

  //private _type = _x select 1;
  //private _unit = _x select 4;
  private _unit = _x;
  private _vehicle = vehicle _x;
  private _type = typeof _vehicle;
  private _exit = false;

  //TODO: optimise this, if it's not a vehicle no infantry checks etc. CHECK what enemyTarget is, a unit or the vehicle itself?

  call {

  //ORDER MATTERS: more spesific conditions are first because AA vehicles can also be Tanks

  //AA Vehicle ThreatEval

  if (_type in (["CSAT", "self_aa"] call AS_fnc_getEntity)) exitWith {
    _threatEval_Land = _threatEval_Land + 2;
    _threatEval_Air = _threatEval_Air + 10;
  };

  //TANK Threat

  if (_vehicle isKindof "Tank" or _type in BE_class_MBT) exitWith {
    _threatEval_Land = _threatEval_Land + 10;
    _threatEval_Air = _threatEval_Air + 4; // this changed to 4 from 2: tanks are more dangerous than apcs
  };


  //APC Threat
  if (_vehicle isKindOf "APC_Wheeled_01_base_F" or _vehicle isKindof "APC_Tracked_01_base_F" or
    _vehicle isKindOf "APC_Wheeled_02_base_F" or _vehicle isKindof "APC_Tracked_02_base_F" or
    _type in BE_class_APC) exitWith {
    _threatEval_Land = _threatEval_Land + 5;
    _threatEval_Air = _threatEval_Air + 2;
  };

  //MRAP Threat

  if (_type in (["FIA", "cars_aa"] call AS_fnc_getEntity)) exitWith {
    _threatEval_Land = _threatEval_Land + 2;
    _threatEval_Air = _threatEval_Air + 8;
  };

  if (_type in (["FIA", "cars_at"] call AS_fnc_getEntity)) exitWith {
    _threatEval_Land = _threatEval_Land + 4;
  };

  if (_type in (BE_class_MRAP + (["FIA", "cars_armed"] call AS_fnc_getEntity))) exitWith {
    _threatEval_Land = _threatEval_Land + 2;
    _threatEval_Air = _threatEval_Air + 2;
  };



  //STATICs threat

  if (_vehicle in AS_allATStatics) exitWith {_threatEval_Land = _threatEval_Land + 2;};
  if (_vehicle in AS_allAAStatics) exitWith {_threatEval_Air = _threatEval_Air + 7;};
  if (_vehicle in AS_allMGStatics) exitWith {
      _threatEval_Land = _threatEval_Land + 1;
      _threatEval_Air = _threatEval_Air + 1;
    };
  if (_vehicle in AS_allMortarStatics) exitWith {_threatEval_Land = _threatEval_Land + 1;};

  //Helicopter threat
  //TODO: attack helos + tweak BE_module to include NATO stuff?

  if (_vehicle in BE_class_Heli or _vehicle isKindof "Helicopter") exitWith {

    call {

        if (_vehicle in AS_allAttackHelis) exitWith {
        _threatEval_Air = _threatEval_Air + 5;
        _threatEval_Land = _threatEval_Land + 15; //attack helos are more dangerous than tanks

        };
        if (_vehicle in AS_allArmedHelis) exitWith {
        _threatEval_Air = _threatEval_Air + 2;
        _threatEval_Land = _threatEval_Land + 2;
        };
    };
  };

  //Plane threat. All planes are assumed armed as they're from template file

  if (_vehicle in AS_allPlanes) exitWith {
    _threatEval_Air = _threatEval_Air + 15;
    _threatEval_Land = _threatEval_Land + 5;
  };

    //Enemy inf carrying multiple "threatening" weapons: AT first and foremost, then AA, then MG
    //TODO: investigate possibility to do via units weapons arrayintersect AS_weapons?
    {
      if (_unit hasWeapon _x) exitWith {
        if (_x in (AS_weapons select 10)) then {_threatEval_Land = _threatEval_Land + 2;};
        if (_x in (AS_weapons Select 8)) then {_threatEval_Air = _threatEval_Air + 2;};
        if (_x in (AS_weapons select 6)) then {_threatEval_Air = _threatEval_Air + 0.5;};
      };
    } foreach ((AS_weapons select 10) + (AS_weapons select 8) + (AS_weapons select 6));

  };

//Baseline threat for every unit
_threatEval_Air = _threatEval_Air + 0.1;
_threatEval_Land = _threatEval_Land + 0.1;

}  foreach (_leader call bis_fnc_enemytargets);

//foreach  ((_leader nearTargets 1000) select {_x select 2 == _FIAside});


//Return array

[_threatEval_Land, _threatEval_Air]
