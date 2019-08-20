private ["_center", "_objects"];
private _dict = [AS_compositions, "locations"] call DICT_fnc_get;

/*
Grab data:
Mission: AS_objects
World: Enoch
Anchor position: [5078.27, 2167.05]
Area size: 1000
Using orientation of objects: yes
*/

_center = [5078.27, 2167.05];


_objects = [
	["Land_Cargo_Patrol_V1_F",[41.8735,-72.6096,0],264.454,1,0,[0,0],"","",true,false],
	["Land_Cargo_Patrol_V1_F",[-103.562,37.2683,0],266.667,1,0,[0,0],"","",true,false],
	["Land_Cargo_Patrol_V1_F",[-189.78,-15.5461,0],90.365,1,0,[0,-0],"","",true,false],
	["Land_Cargo_Patrol_V1_F",[-257.769,-68.8052,0],134.38,1,0,[0,-0],"","",true,false]
];

[_dict, "AS_base", call DICT_fnc_create] call DICT_fnc_set;
[_dict, "AS_base", "center", _center] call DICT_fnc_set;
[_dict, "AS_base", "objects", _objects] call DICT_fnc_set;


/*
Grab data:
Mission: AS_objects
World: Enoch
Anchor position: [7902.74, 9706.92]
Area size: 500
Using orientation of objects: yes
*/

_center = [7902.74, 9706.92];

_objects = [
	["Land_BagFence_01_short_green_F",[-23.7524,96.0313,0.00524902],356.453,1,0,[0.29695,0.348662],"","",true,false],
	["Land_BagFence_01_short_green_F",[-22.0688,96.5986,0.000518799],319.403,1,0,[0.447068,0.0993541],"","",true,false],
	["Land_BagBunker_01_large_green_F",[-16.8765,101.75,-0.0018158],269.648,1,0,[0.180633,-0.459524],"","",true,false],
	["Land_Cargo_Patrol_V1_F",[-109.216,15.0996,0],91.7632,1,0,[0,-0],"","",true,false],
	["Land_BagFence_01_long_green_F",[-22.7017,107.063,-0.0153809],214.921,1,0,[-0.293662,-0.540188],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[107.261,-122.706,0.0183105],209.756,1,0,[-0.220004,-6.96905],"","",true,false],
	["Land_Cargo_Patrol_V1_F",[104.773,-130.992,0],297.384,1,0,[0,0],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[100.281,-135.742,0.0246429],213.258,1,0,[0.571164,-5.534],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[110.358,-128.326,0.00532532],298.861,1,0,[6.8676,0.0350053],"","",true,false],
	["Land_Cargo_Patrol_V1_F",[54.3813,164.514,0],274.336,1,0,[0,0],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[106.293,-135.944,0.00379944],298.915,1,0,[6.28538,0.344129],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[-53.0249,-167.244,0.016449],260.977,1,0,[9.31529,-2.78959],"","",true,false],
	["Land_Cargo_Patrol_V1_F",[-60.8672,-170.354,0],348.762,1,0,[0,0],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[-55.3643,-173.103,-1.52588e-005],350.398,1,0,[5.13607,3.5077],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[-67.5293,-169.921,0.0210571],264.697,1,0,[7.96414,-0.928158],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[-63.9707,-174.759,0.00463867],350.554,1,0,[1.84927,9.90792],"","",true,false],
	["Land_Cargo_Patrol_V1_F",[-99.3804,221.532,0],101.421,1,0,[0,-0],"","",true,false],
	["Land_Cargo_Patrol_V1_F",[-138.047,-206.408,0],11.2435,1,0,[0,0],"","",true,false]
];

[_dict, "AS_base_2", call DICT_fnc_create] call DICT_fnc_set;
[_dict, "AS_base_2", "center", _center] call DICT_fnc_set;
[_dict, "AS_base_2", "objects", _objects] call DICT_fnc_set;

/*Grab data:
Mission: AS_objects
World: Enoch
Anchor position: [9010.58, 6619.37]
Area size: 500
Using orientation of objects: yes
*/

_center = [9010.58, 6619.37];

_objects =


[
	["Land_BagFence_Short_F",[-0.0849609,-6.06787,0.00418091],240.756,1,0,[0.384026,0.310377],"","",true,false],
	["Land_BagFence_Short_F",[-18.4922,-15.1143,0.0142365],82.5454,1,0,[-0.652113,0.926098],"","",true,false],
	["Land_BagFence_Short_F",[-25.7959,-1.44482,-0.00120544],240.754,1,0,[0.126207,-0.0106818],"","",true,false],
	["Land_Cargo_Patrol_V1_F",[85.3516,-14.9658,0],316.528,1,0,[0,0],"","",true,false],
	["Land_BagFence_01_long_green_F",[-64.7441,-63.3086,0.170456],64.7467,1,0,[2.07189,4.38572],"","",true,false],
	["Land_BagFence_01_long_green_F",[-63.6348,-65.8818,0.108917],68.304,1,0,[1.79556,4.50514],"","",true,false],
	["Land_BagFence_01_long_green_F",[-64.4766,-67.8232,0.110397],330.209,1,0,[2.4805,3.95996],"","",true,false],
	["Land_HBarrier_01_tower_green_F",[-68.874,-68.0186,0.000137329],330.85,1,0,[0,0],"","",true,false],
	["Land_BagFence_01_long_green_F",[-74.7021,-66.4141,0.0223999],330.134,1,0,[0.332211,0.76053],"","",true,false],
	["Land_Cargo_Patrol_V1_F",[79.5703,69.873,0],161.368,1,0,[0,-0],"","",true,false],
	["Land_BagFence_01_long_green_F",[-81.8428,-69.4932,-0.0019989],330.123,1,0,[1.29524,-0.321593],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[-82.1523,-74.2051,0.00234985],242.768,1,0,[-0.384115,-1.34845],"","",true,false],
	["Land_BagFence_01_short_green_F",[-23.0615,-110.476,0.0157089],64.5426,1,0,[1.13099,0.882794],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[-82.6992,-80.2832,0.00218201],147.962,1,0,[-3.58992,2.03168],"","",true,false],
	["Land_Cargo_Patrol_V1_F",[-88.0068,-80.061,0],329.321,1,0,[0,0],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[-90.0303,-84.7256,0.00454712],153.652,1,0,[-4.30116,0.80057],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[-95.625,-81.2729,0.00904846],238.797,1,0,[-0.86328,-4.07883],"","",true,false]
];

[_dict, "AS_base_1", call DICT_fnc_create] call DICT_fnc_set;
[_dict, "AS_base_1", "center", _center] call DICT_fnc_set;
[_dict, "AS_base_1", "objects", _objects] call DICT_fnc_set;

/*
Grab data:
Mission: AS_objects
World: Enoch
Anchor position: [3964.01, 10259.3]
Area size: 1000
Using orientation of objects: yes
*/

_center = [3964.01, 10259.3];

_objects = [
	["Land_HBarrier_01_big_4_green_F",[-50.6609,105.464,-0.000610352],50.8393,1,0,[-1.10574,1.25489],"","",true,false],
	["Land_Cargo_Patrol_V1_F",[-45.2544,112.193,0],138.307,1,0,[0,-0],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[-39.4878,115.091,0.0136795],54.3321,1,0,[-2.50198,0.442889],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[-51.5769,111.811,0.00523376],139.989,1,0,[-1.89591,-2.11742],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[-45.0454,117.457,0.00406647],139.98,1,0,[-1.40245,-1.81419],"","",true,false],
	["Land_Bunker_01_big_F",[-16.7759,-168.859,0],334.298,1,0,[0,0],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[-81.4314,-181.662,0.00100708],235.574,1,0,[0.54903,-0.820406],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[-81.0823,-188.052,-0.00119019],324.679,1,0,[1.77636,0.763444],"","",true,false],
	["Land_Cargo_Patrol_V1_F",[-87.3203,-187.94,0],323.033,1,0,[0,0],"","",true,false],
	["Land_BagBunker_01_large_green_F",[-203.983,-38.7227,0.0270844],132.854,1,0,[-2.57572,-1.26567],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[-93.3638,-190.369,0.0121078],239.044,1,0,[0.267559,-0.266177],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[-88.0535,-193.148,-0.00157166],324.686,1,0,[1.83845,1.16871],"","",true,false],
	["Land_BagBunker_01_large_green_F",[200.608,85.0068,0],310.158,1,0,[0,0],"","",true,false],
	["Land_BagBunker_01_large_green_F",[-272.183,-118.994,0.0204849],131.857,1,0,[-1.89564,2.11571],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[215.057,349.418,-0.000221252],47.1581,1,0,[0.517754,0.0194971],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[213.759,355.656,0.000999451],136.241,1,0,[1.44533,-0.876039],"","",true,false],
	["Land_Cargo_Patrol_V1_F",[219.975,356.479,0],134.609,1,0,[0,-0],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[219.901,361.707,0.00145721],136.234,1,0,[1.70948,-1.13008],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[225.565,359.733,0.0142746],50.6474,1,0,[-1.96761,-0.519915],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[378.836,316.901,0.00826263],140.712,1,0,[0.139889,-4.0208],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[388.523,305.746,0.0213852],144.187,1,0,[0.263659,-4.48213],"","",true,false],
	["Land_Cargo_Patrol_V1_F",[385.655,311.61,7.62939e-006],228.099,1,0,[0,0],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[385.198,317.819,3.8147e-005],229.809,1,0,[3.4157,0.351174],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[390.874,311.331,9.15527e-005],229.785,1,0,[2.9214,0.0487858],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[-512.715,-368.867,-0.00189209],323.459,1,0,[2.9208,5.00961],"","",true,false],
	["Land_Cargo_Patrol_V1_F",[-519.094,-363.2,0],50.7509,1,0,[0,0],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[-521.898,-357.25,0.01091],326.9,1,0,[4.11215,4.96315],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[-519.071,-369.471,0.00165558],52.3099,1,0,[-3.49356,2.81748],"","",true,false],
	["Land_HBarrier_01_big_4_green_F",[-524.442,-362.695,0.000740051],52.2563,1,0,[-3.02161,3.72699],"","",true,false]
];

[_dict, "AS_airfield", call DICT_fnc_create] call DICT_fnc_set;
[_dict, "AS_airfield", "center", _center] call DICT_fnc_set;
[_dict, "AS_airfield", "objects", _objects] call DICT_fnc_set;
