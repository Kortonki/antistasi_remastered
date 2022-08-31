
params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];

if (_weapon == "Put") then {

    if (captive _unit and {[_unit] call AS_fnc_detected}) then {
      _unit setCaptive false;
    };

    //MINE STUFF starts here
    if (_magazine in AS_allMinesMags) then {

      ("FIA" call AS_fnc_getFactionSide) revealMine _projectile;

      // See if there is already a minefield in range
      private _position = getpos _unit;
      private _mineFields = ["minefield", "FIA"] call AS_location_fnc_TS;
      private _closest = "";
      {
        if ( (_x call AS_location_fnc_position) distance2D _unit < 100) then {
          _closest = _x;
        };
      } foreach _mineFields;

      private _mineVehicle = _magazine call AS_fnc_mineVehicle;
      private _minePos = getPos _projectile;
      private _mineDir = getDir _projectile;

      private _mineData = [_mineVehicle, _minePos, _mineDir];

      if (_closest != "") then {

        [_closest, _mineData, _projectile] remoteExec  ["AS_fnc_addToMinefield", 2];

      } else {

        [_position, "FIA", [_mineData]] remoteExec ["AS_fnc_addMinefield", 2];

        [_projectile] spawn {
          params ["_projectile"];

          private _closest = "";
          private _mineFields = [];

          while {_closest isEqualto ""} do {
            sleep AS_spawnLoopTime;

            _mineFields = ["minefield", "FIA"] call AS_location_fnc_TS;

            {
              if ( (_x call AS_location_fnc_position) distance2D _projectile < 100) then {
                _closest = _x;
              };
            } foreach _mineFields;

          };

          waitUntil {sleep AS_spawnLoopTime; _closest call AS_spawn_fnc_exists};
          waitUntil {sleep AS_spawnLoopTime; ([_closest, "state_index"] call AS_spawn_fnc_get) == 1}; // Mines would have spawned by now
          [_projectile] remoteExec ["deleteVehicle", _projectile]; // Delete, the mine will already appear again with the minefield spawning. This to avoid duplicates
        };
      };


    };
};
