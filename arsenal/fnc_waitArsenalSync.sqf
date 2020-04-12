//Checks that weapon/mag/item/back amount doesn't change in the arsenal. Used to check that arsenal has synced
//with the clients

//Call this function to wait for it's completion
/*
{
  private _a = 0;
  private _b = 1;
  private _t = diag_tickTime + 5; //5 second timeout for the loop

  while {_a != _b or diag_Ticktime > _t} do {

    _a = count ((([caja, true] call AS_fnc_getBoxArsenal) select _x) select 1);
    sleep 0.1; //Experiment here what is enough
    _b = count ((([caja, true] call AS_fnc_getBoxArsenal) select _x) select 1);
  };

  if (_a != _b) then {["[AS] WaitArsenalSync timed out."] remoteExec ["diag_log", 2];};

} foreach [0,1,2,3]; //weapons/mags/items/backpacks*/

//WEAPONS
private _a = 0;
private _b = 1;

private _t = diag_tickTime + 5; //5 second timeout for the loop

while {_a != _b or diag_Ticktime > _t} do {

    _a = count (weaponCargo caja);
    sleep 0.1; //Experiment here what is enough
    _b = count (weaponCargo caja);
  };

if (_a != _b) then {["[AS] WaitArsenalSync timed out at weapon count."] remoteExec ["diag_log", 2];};

//MAGS
_a = 0;
_b = 1;

_t = diag_tickTime + 5; //5 second timeout for the loop

while {_a != _b or diag_Ticktime > _t} do {

    _a = count (magazineCargo caja);
    sleep 0.1; //Experiment here what is enough
    _b = count (magazineCargo caja);
  };

if (_a != _b) then {["[AS] WaitArsenalSync timed out at magazine count."] remoteExec ["diag_log", 2];};


//ITEMS
_a = 0;
_b = 1;

_t = diag_tickTime + 5; //5 second timeout for the loop

while {_a != _b or diag_Ticktime > _t} do {

    _a = count (itemCargo caja);
    sleep 0.1; //Experiment here what is enough
    _b = count (itemCargo caja);
  };

if (_a != _b) then {["[AS] WaitArsenalSync timed out at item count."] remoteExec ["diag_log", 2];};

//BACKPACKS
  _a = 0;
  _b = 1;

  _t = diag_tickTime + 5; //5 second timeout for the loop

  while {_a != _b or diag_Ticktime > _t} do {

      _a = count (backpackCargo caja);
      sleep 0.1; //Experiment here what is enough
      _b = count (backpackCargo caja);
    };

if (_a != _b) then {["[AS] WaitArsenalSync timed out at backpack count."] remoteExec ["diag_log", 2];};
