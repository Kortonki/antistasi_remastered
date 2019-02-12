params ["_destination", ["_magazineRemains",[]]];

{
  _destination addmagazineAmmoCargo [_x select 0, 1, _x select 1]; //Add remains of mags
} foreach _magazineRemains;
