//Checks that weapon/mag/item/back amount doesn't change in the arsenal. Used to check that arsenal has synced
//with the clients

//Call this function to wait for it's completion

{
  private _a = 0;
  private _b = 1;
  private _time = diag_tickTime + 5; //5 second timeout for the loop

  while {_a != _b or diag_Ticktime > _time} do {

    _a = count ((([caja, true] call AS_fnc_getBoxArsenal) select _x) select 1);
    sleep 0.2;
    _b = count ((([caja, true] call AS_fnc_getBoxArsenal) select _x) select 1);
  };

  if (_a != _b) then {["[AS] WaitArsenalSync timed out"] remoteExec ["diag_log", 2];};

} foreach [0,1,2,3]; //weapons/mags/items/backpacks
