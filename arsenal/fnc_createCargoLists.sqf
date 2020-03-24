//This function is to create -1 amount lists for cargos that are non-existant in arsenal but player has picked them nevertheless
//Used for checking if player has non-existant items from arsenal

params ["_cargoList1", "_cargoList2"];

{
	private _index = (_cargoList1 select 0) find _x;
	if (_index == -1) then {
		(_cargoList1 select 0) pushback _x;
		(_cargoList1 select 1) pushback -((_cargoList2 select 1) select _forEachIndex);
	};
} foreach (_cargoList2 select 0);

_cargoList1
