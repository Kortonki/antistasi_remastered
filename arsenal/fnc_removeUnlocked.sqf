params ["_cargo_w", "_cargo_m", "_cargo_i", "_cargo_b"];

//Remove unlocked items
for "_i" from 0 to (count (_cargo_w select 0) - 1) do {
  private _name = (_cargo_w select 0) select _i;
	if (_name in unlockedWeapons) then {
		(_cargo_w select 0) deleteAt _i;
    (_cargo_w select 1) deleteAt _i;
	};
};

for "_i" from 0 to (count (_cargo_m select 0) - 1) do {
  private _name = (_cargo_m select 0) select _i;
	if (_name in unlockedMagazines) then {
		(_cargo_m select 0) deleteAt _i;
    (_cargo_m select 1) deleteAt _i;
	};
};

for "_i" from 0 to (count (_cargo_i select 0) - 1) do {
  private _name = (_cargo_i select 0) select _i;
	if (_name in unlockedItems) then {
		(_cargo_i select 0) deleteAt _i;
    (_cargo_i select 1) deleteAt _i;
	};
};

for "_i" from 0 to (count (_cargo_b select 0) - 1) do {
  private _name = (_cargo_b select 0) select _i;
	if (_name in unlockedBackpacks) then {
		(_cargo_b select 0) deleteAt _i;
    (_cargo_b select 1) deleteAt _i;
	};
};

[_cargo_w, _cargo_m, _cargo_i, _cargo_b]
