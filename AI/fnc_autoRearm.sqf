private ["_unit","_Pweapon","_Sweapon","_magCount","_magazines","_findsAmmo","_distancia","_objects","_target","_body","_check","_timeOut","_arma","_armas","_rearming","_basePosible","_hmd","_casco"];

_unit = _this select 0;

if ((!alive _unit) or (isPlayer _unit) or (vehicle _unit != _unit) or (player != leader group player) or (captive _unit)) exitWith {};
if (_unit call AS_medical_fnc_isUnconscious) exitWith {};
private _ayudando = _unit getVariable "ayudando";
if (!(isNil "_ayudando")) exitWith {_unit groupChat "I cannot rearm right now. I'm healing a comrade"};
private _rearming = _unit getVariable ["rearming", false];
if (_rearming) exitWith {_unit groupChat "I am currently rearming"};

_unit setVariable ["rearming",true];

private _Pweapon = primaryWeapon _unit;
private _Sweapon = secondaryWeapon _unit;

private _findsAmmo = false;
private _arma = "";
private _armas = [];
private _distancia = 50;
private _objects = nearestObjects [_unit, ["ReammoBox_F","Air", "Car", "Ship", "Tank","WeaponHolderSimulated", "GroundWeaponHolder", "WeaponHolder"], 50];
//if (caja in _objects) then {_objects = _objects - [caja]}; //Why not rearm from arsenal box?
private _necesita = false;
private _bodies = [];
private _validWeapons = [];

{
	private _body = _x;
	if (_body distance2D _unit < _distancia) then
	{
		_busy = _body getVariable "busy";
		if (isNil "_busy") then
		{
			_bodies pushBack _body;
		};
	};
} forEach allDead;


	if ((_Pweapon in unlockedWeapons) or _Pweapon == "") then
		{
		_necesita = true;
		if (count _objects > 0) then
			{
			{
			_objeto = _x;
			if (_unit distance _objeto < _distancia) then
				{
				_busy = _objeto getVariable "busy";
				if ((count weaponCargo _objeto > 0) and (isNil "_busy")) then
					{
					_armas = weaponCargo _objeto;
					for "_i" from 0 to (count _armas - 1) do
						{
						_posible = _armas select _i;
						_basePosible = [_posible] call BIS_fnc_baseWeapon;
            _validWeapons = (AS_weapons select 0) + (AS_weapons select 5) + (AS_weapons select 3) + (AS_weapons select 6) + (AS_weapons select 15) + (AS_weapons select 13);
						if (_basePosible in _validWeapons) then
							{
							_target = _objeto;
							_findsAmmo = true;
							_distancia = _unit distance _objeto;
							_arma = _posible;
							};
						};
					};
				};
			} forEach _objects;
			};
		if ((_findsAmmo) and (_unit getVariable "rearming")) then
			{
			_unit stop false;
			if ((!alive _target) or (not(_target isKindOf "ReammoBox_F"))) then {_target setVariable ["busy",true]};
			_unit doMove (getPosATL _target);
			_unit groupChat "Picking a better weapon";
			_timeOut = time + 60;
			waitUntil {sleep 1; (!alive _unit) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
			if ((unitReady _unit) and (alive _unit) and (_unit distance _target > 3) and (_target isKindOf "ReammoBox_F") and (!isNull _target)) then {_unit setPos position _target};
			if (_unit distance _target < 3) then
				{
				_unit action ["TakeWeapon",_target,_arma];
				sleep 5;
				if (primaryWeapon _unit == _arma) then
					{
					_unit groupChat "I have a better weapon now";
					if (_target isKindOf "ReammoBox_F") then {_unit action ["rearm",_target]};
					}
				else
					{
					_unit groupChat "Couldn't take this weapon";
					};
				}
			else
				{
				_unit groupChat "Cannot take a better weapon";
				};
			_target setVariable ["busy",nil];
			_unit doFollow player;
			};
		_distancia = 51;
		_Pweapon = primaryWeapon _unit;
		sleep 3;
		};
	_findsAmmo = false;
	_magCount = 6; //6 mags + 1 in rifle for infantryman, if less than that then try to rearm
	if (_Pweapon in (AS_weapons select 6)) then {_magCount = 2}; //Machine gunners take less mags
	_magazines = getArray (configFile / "CfgWeapons" / _Pweapon / "magazines");
	if (_Pweapon != "" and {{_x in _magazines} count (magazines _unit) < _magCount}) then
		{
		_necesita = true;
		_findsAmmo = false;
		if (count _objects > 0) then
			{
			{
			_objeto = _x;
			if (({_x in _magazines} count magazineCargo _objeto) > 0) then
				{
				if (_unit distance _objeto < _distancia) then
					{
					_target = _objeto;
					_findsAmmo = true;
					_distancia = _unit distance _objeto;
					};
				};
			} forEach _objects;
			};
		{
		_body = _x;
		_busy = _body getVariable "busy";
		if (({_x in _magazines} count (magazines _body) > 0) and (isNil "_busy")) then
			{
			_target = _body;
			_findsAmmo = true;
			_distancia = _body distance _unit;
			};
		} forEach _bodies;
		};
	if ((_findsAmmo) and (_unit getVariable "rearming")) then
		{
		_unit stop false;
		if ((!alive _target) or (not(_target isKindOf "ReammoBox_F"))) then {_target setVariable ["busy",true]};
		_unit doMove (getPosATL _target);
		_unit groupChat "Rearming";
		_timeOut = time + 60;
		waitUntil {sleep 1; (!alive _unit) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
		if ((unitReady _unit) and (alive _unit) and (_unit distance _target > 3) and (_target isKindOf "ReammoBox_F") and (!isNull _target)) then {_unit setPos position _target};
		if (_unit distance _target < 3) then
			{
			_unit action ["rearm",_target];
			if ({_x in _magazines} count (magazines _unit) >= _magCount) then
				{
				_unit groupChat "Rearmed";
				}
			else
				{
				_unit groupChat "Partially Rearmed";
				};
			}
		else
			{
			_unit groupChat "Cannot rearm";
			};
		_target setVariable ["busy",nil];
		_unit doFollow player;
		}
	else
		{
		_unit groupChat "No source to rearm my primary weapon";
		};

_findsAmmo = false;
if ((_Sweapon == "") and (loadAbs _unit < 340)) then
	{
	if (count _objects > 0) then
		{
		{
		_objeto = _x;
		if (_unit distance _objeto < _distancia) then
			{
			_busy = _objeto getVariable "busy";
			if ((count weaponCargo _objeto > 0) and (isNil "_busy")) then
				{
				_armas = weaponCargo _objeto;
                _valid = (AS_weapons select 10) + (AS_weapons select 8) + (AS_weapons select 5);
				for "_i" from 0 to (count _armas - 1) do
					{
					_posible = _armas select _i;
					if (_posible in _valid) then
						{
						_target = _objeto;
						_findsAmmo = true;
						_distancia = _unit distance _objeto;
						_arma = _posible;
						};
					};
				};
			};
		} forEach _objects;
		};
	if ((_findsAmmo) and (_unit getVariable "rearming")) then
		{
		_unit stop false;
		if ((!alive _target) or (not(_target isKindOf "ReammoBox_F"))) then {_target setVariable ["busy",true]};
		_unit doMove (getPosATL _target);
		_unit groupChat "Picking a secondary weapon";
		_timeOut = time + 60;
		waitUntil {sleep 1; (!alive _unit) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
		if ((unitReady _unit) and (alive _unit) and (_unit distance _target > 3) and (_target isKindOf "ReammoBox_F") and (!isNull _target)) then {_unit setPos position _target};
		if (_unit distance _target < 3) then
			{
			_unit action ["TakeWeapon",_target,_arma];
			sleep 3;
			if (secondaryWeapon _unit == _arma) then
				{
				_unit groupChat "I have a secondary weapon now";
				if (_target isKindOf "ReammoBox_F") then {sleep 3;_unit action ["rearm",_target]};
				}
			else
				{
				_unit groupChat "Couldn't take this weapon";
				};
			}
		else
			{
			_unit groupChat "Cannot take a secondary weapon";
			};
		_target setVariable ["busy",nil];
		_unit doFollow player;
		};
	_Sweapon = secondaryWeapon _unit;
	_distancia = 51;
	sleep 3;
	};
_findsAmmo = false;
if (_Sweapon != "") then
	{
	_magazines = getArray (configFile / "CfgWeapons" / _Sweapon / "magazines");
	if ({_x in _magazines} count (magazines _unit) < 2) then
		{
		_necesita = true;
		_findsAmmo = false;
		_distancia = 50;
		if (count _objects > 0) then
			{
			{
			_objeto = _x;
			if ({_x in _magazines} count magazineCargo _objeto > 0) then
				{
				if (_unit distance _objeto < _distancia) then
					{
					_target = _objeto;
					_findsAmmo = true;
					_distancia = _unit distance _objeto;
					};
				};
			} forEach _objects;
			};
		{
		_body = _x;
		_busy = _body getVariable "busy";
		if (({_x in _magazines} count (magazines _body) > 0) and (isNil "_busy")) then
			{
			_target = _body;
			_findsAmmo = true;
			_distancia = _body distance _unit;
			};
		} forEach _bodies;
		};
	if ((_findsAmmo) and (_unit getVariable "rearming")) then
		{
		_unit stop false;
		if (!alive _target) then {_target setVariable ["busy",true]};
		_unit doMove (position _target);
		_unit groupChat "Rearming";
		_timeOut = time + 60;
		waitUntil {sleep 1; (!alive _unit) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
		if ((unitReady _unit) and (alive _unit) and (_unit distance _target > 3) and (_target isKindOf "ReammoBox_F") and (!isNull _target)) then {_unit setPos position _target};
		if (_unit distance _target < 3) then
			{
			if ((backpack _unit == "") and (backPack _target != "")) then
				{
				_unit addBackPackGlobal ((backpack _target) call BIS_fnc_basicBackpack);
				_unit action ["rearm",_target];
				sleep 3;
				{_unit addMagazine [_x,1]} forEach (magazineCargo (backpackContainer _target));
				removeBackpackGlobal _target;
				}
			else
				{
				_unit action ["rearm",_target];
				};

			if ({_x in _magazines} count (magazines _unit) >= 2) then
				{
				_unit groupChat "Rearmed";
				}
			else
				{
				_unit groupChat "Partially Rearmed";
				};
			}
		else
			{
			_unit groupChat "Cannot rearm";
			};
		_target setVariable ["busy",nil];
		}
	else
		{
		_unit groupChat "No source to rearm my secondary weapon.";
		};
	sleep 3;
	};
_findsAmmo = false;
if (not("ItemRadio" in assignedItems _unit)) then
	{
	_necesita = true;
	_findsAmmo = false;
	_distancia = 50;
	{
	_body = _x;
	_busy = _body getVariable "busy";
	if (("ItemRadio" in (assignedItems _body)) and (isNil "_busy")) then
		{
		_target = _body;
		_findsAmmo = true;
		_distancia = _body distance _unit;
		};
	} forEach _bodies;
	if ((_findsAmmo) and (_unit getVariable "rearming")) then
		{
		_unit stop false;
		_target setVariable ["busy",true];
		_unit doMove (getPosATL _target);
		_unit groupChat "Picking a Radio";
		_timeOut = time + 60;
		waitUntil {sleep 1; (!alive _unit) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
		if (_unit distance _target < 3) then
			{
			_unit action ["rearm",_target];
			_unit linkItem "ItemRadio";
			_target unlinkItem "ItemRadio";
			}
		else
			{
			_unit groupChat "Cannot pick the Radio";
			};
		_target setVariable ["busy",nil];
		_unit doFollow player;
		};
	};
_findsAmmo = false;
if (hmd _unit == "") then
	{
	_necesita = true;
	_findsAmmo = false;
	_distancia = 50;
	{
	_body = _x;
	_busy = _body getVariable "busy";
	if ((hmd _body != "") and (isNil "_busy")) then
		{
		_target = _body;
		_findsAmmo = true;
		_distancia = _body distance _unit;
		};
	} forEach _bodies;

	if ((_findsAmmo) and (_unit getVariable "rearming")) then
		{
		_findsAmmo = false;
		_distancia = 50;
		{
		_body = _x;
		_busy = _body getVariable "busy";
		if ((hmd _body != "") and (isNil "_busy")) then
			{
			_target = _body;
			_findsAmmo = true;
			_distancia = _body distance _unit;
			};
		} forEach _bodies;
		if (_findsAmmo) then
			{
			_unit stop false;
			_target setVariable ["busy",true];
			_hmd = hmd _target;
			_unit doMove (getPosATL _target);
			_unit groupChat "Picking NV Googles";
			_timeOut = time + 60;
			waitUntil {sleep 1; (!alive _unit) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
			if (_unit distance _target < 3) then
				{
				_unit action ["rearm",_target];
				_unit linkItem _hmd;
				_target unlinkItem _hmd;
				}
			else
				{
				_unit groupChat "Cannot pick those NV Googles";
				};
			_target setVariable ["busy",nil];
			_unit doFollow player;
			};
		};
	};
_findsAmmo = false;
if ((headgear _unit) == "") then
	{
	_necesita = true;
	_findsAmmo = false;
	_distancia = 50;
	{
	_body = _x;
	_busy = _body getVariable "busy";
	if (((headgear _body) != "") and {isNil "_busy"}) then
		{
		_target = _body;
		_findsAmmo = true;
		_distancia = _body distance _unit;
		};
	} forEach _bodies;
	if ((_findsAmmo) and (_unit getVariable "rearming")) then
		{
		_unit stop false;
		_target setVariable ["busy",true];
		_casco = headgear _target;
		_unit doMove (getPosATL _target);
		_unit groupChat "Picking a Helmet";
		_timeOut = time + 60;
		waitUntil {sleep 1; (!alive _unit) or (isNull _target) or (_unit distance _target < 3) or (_timeOut < time) or (unitReady _unit)};
		if (_unit distance _target < 3) then
			{
			_unit action ["rearm",_target];
			_unit addHeadgear _casco;
			removeHeadgear _target;
			}
		else
			{
			_unit groupChat "Cannot pick this Helmet";
			};
		_target setVariable ["busy",nil];
		_unit doFollow player;
		};
	};

if (!_necesita) then {_unit groupChat "No need to rearm"} else {_unit groupChat "Rearming Done"};
_unit setVariable ["rearming",false];
