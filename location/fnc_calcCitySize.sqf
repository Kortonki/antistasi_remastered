params [["_min", 50], ["_max", 1000], ["_position", [0,0,0]], ["_increasePercentage", 0.1]];

private _size = _min;
private _houseCount = count (nearestTerrainobjects [_position, ["HOUSE"], _size, false, true]);
private _newHouseCount = count (nearestTerrainobjects [_position, ["HOUSE"], _size + 50, false, true]); //to trigger the while loop

while {_size < _max and {_newHouseCount >= (_houseCount*(1+_increasePercentage))}} do {
  _size = (_size + 50) min _max;
  _housecount = count (nearestTerrainobjects [_position, ["HOUSE"], _size, false, true]);
  _newHouseCount = count (nearestTerrainobjects [_position, ["HOUSE"], _size + 50, false, true]);
};

_size
