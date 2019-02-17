params ["_mission"];
([_mission, "resources"] call AS_spawn_fnc_get) params ["_task", "_groups", "_vehicles", "_markers"];

//Here wait until mission success operations have finished on the server
private _fin = [_mission, _task,_groups,_vehicles,_markers] spawn {
  params ["_mission", "_task", "_groups", "_vehicles", "_markers"];
  waitUntil {sleep 0.1; (_mission call AS_mission_fnc_status) == "completed"};
  {AS_commander hcRemoveGroup _x} forEach _groups;
  [_groups, _vehicles, _markers] call AS_fnc_cleanResources;

  [_task] call BIS_fnc_deleteTask;
  //_mission call AS_mission_fnc_remove; // This is possibly unnecessary
};
