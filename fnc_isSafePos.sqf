if (count _this < 3) exitWith {false};

private _pos = _this;

private _house = 16;
private _wall = 7;
private _tree = 3;
private _entities = 6;

private _margin = 4; //Experiment: Extra margin from object edge, to consider spawned object size too


//Comment this out for the time being - performance ?
/*
private _house = [["House"], 20];
private _wall = [["Wall", "Fence"], 7];

private _objSizeSearch = {
  private _classes = _this select 0;
  private _classSize = _this select 1;

  {
    private _boundingBox = 0 boundingBoxReal _x;
    private _xSize = abs (((_boundingBox select 0) select 0) - ((_boundingBox select 1) select 0));
    private _ySize = abs (((_boundingBox select 0) select 1) - ((_boundingBox select 1) select 1));
    private _flatSize = sqrt (_xSize^2 + _ySize^2);

    if ((_flatSize/2)+_margin  > _classSize) then {_classSize = (_flatSize/2)+_margin};

  } foreach (nearestObjects [_pos, _classes, _classSize*2, true]);
  _classSize
};



_house set [1, _house call _objSizeSearch];
_wall set [1, _wall call _objSizeSearch];
*/
(count (_pos nearentities [["Car", "Air", "Tank", "Building"], _entities]) == 0 and
{count(nearestTerrainObjects [_pos, ["Tree", "Hide"], _tree + _margin, true]) == 0 and
{count(nearestTerrainObjects [_pos, ["Fence", "Wall"], _wall + _margin, true]) == 0 and
{count(nearestTerrainObjects [_pos, ["House"], _house + _margin, true]) == 0 and
{count(nearestObjects [_pos, ["Fence", "Wall"], _wall + _margin, true]) == 0 and
{count(nearestObjects [_pos, ["House"], _house + _margin, true]) == 0 and
{_pos call AS_location_fnc_notBlacklistArea
}}}}}})
