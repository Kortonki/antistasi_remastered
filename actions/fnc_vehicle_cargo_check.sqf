params ["_vehicle", "_player", "_id", ["_args", []], ["_polled", false]];

if (_vehicle == caja) then {

  if (!_polled) exitWith {
    [_player, "inventory", _vehicle] remoteExec ["AS_fnc_pollServerArsenal", 2];
  };
  private _text = "ARSENAL INVENTORY:\n";
  private _arsenal = _args;
  private _itemArray = _arsenal call AS_fnc_countArsenal;
  [_itemArray, _text, true] call AS_fnc_displayCargo_hint;

} else {
  private _arsenal = [_vehicle, false, true] call AS_fnc_getBoxArsenal;
  private _itemArray = _arsenal call AS_fnc_countArsenal;
  private _text ="CONTAINER CARGO:\n";
  [_itemArray, _text, true] call AS_fnc_displayCargo_hint;

};
