//Safe delete: if unit is in a vehicle, the vehicle doesn't get deleted uncontrollably
params ["_unit"];

if (!(isNull objectParent _unit)) then {
  objectParent _unit deletevehicleCrew _unit; //This to make sure the vehicle unit is mounted on is not deleted
} else {
deleteVehicle _unit;
};
