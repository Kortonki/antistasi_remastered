params ["_cargoList1", "_cargoList2", ["_add", true]];

//Try running merging only on server to avoid arsenal desyncinc delete/duplication
//this need a remoteExec back to the client
//if (!isServer) exitWith {([_cargoList1, _cargoList2, _add] remoteExecCall ["AS_fnc_mergeCargoLists", 2])};

private _fnc_add = {
    params ["_cargo1", "_cargo2"];
    {
		private _amount2 = (_cargo2 select 1 select _forEachIndex);
        private _index = (_cargo1 select 0) find _x;
        if (_index != -1) then {
			private _amount1 = (_cargo1 select 1 select _index);
            (_cargo1 select 1) set [_index, _amount1 + _amount2];
        } else {
            (_cargo1 select 0) pushBack _x;
            (_cargo1 select 1) pushBack _amount2;
        };
    } forEach (_cargo2 select 0);
};

private _fnc_remove = {
    params ["_cargo1", "_cargo2"];
    {
		private _amount2 = (_cargo2 select 1 select _forEachIndex);
        private _index = (_cargo1 select 0) find _x;
        if (_index != -1) then {
			private _amount1 = (_cargo1 select 1 select _index);
			(_cargo1 select 1) set [_index, _amount1 - _amount2];

        } else { //Nonexistant are created for the returning list
          (_cargo1 select 0) pushback _x;
          (_cargo1 select 1) pushback -(_amount2);
        };
    } forEach (_cargo2 select 0);
};


private _fnc = _fnc_add;
if not _add then {
	_fnc = _fnc_remove;
};

[_cargoList1, _cargoList2] call _fnc;
_cargoList1
