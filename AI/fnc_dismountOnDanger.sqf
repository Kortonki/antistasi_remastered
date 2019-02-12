private ["_grupo","_modo"];

_grupo = _this select 0;
_veh = _this select 1;
private _modo = "SAFE";
private _modoD = "SAFE";

while {{alive _x} count units _grupo > 0} do
	{
	sleep 3;
	_modo = behaviour leader _grupo;
	if (isPlayer (driver _veh) or isNull(driver _veh)) then {
	_modoD = "SAFE";
		}	else {
	_modoD = behaviour driver _veh;
		};

	if (_modo == "DANGER" or _modoD == "DANGER") then
		{
		{[_x] orderGetIn false; [_x] allowGetIn false} forEach units _grupo;
		}
	else
		{
		{[_x] orderGetIn true; [_x] allowGetIn true} forEach units _grupo;
		};
	};
