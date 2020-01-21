private ["_center", "_objects"];
private _dict = [AS_compositions, "locations"] call DICT_fnc_get;

/*
Grab data:
Mission: Antistasi2
World: ruha
Anchor position: [6709.82, 1276.61]
Area size: 200
Using orientation of objects: yes
*/
_center = [6709.82, 1276.61];
_objects = [
	["Land_BagFence_Long_F",[0.418457,-13.2217,-0.000999451],84.4013,1,0,[0,0],"","",true,false],
	["Land_BagFence_Long_F",[2.08496,-14.6569,-0.000999451],173.794,1,0,[0,-0],"","",true,false],
	["Land_HBarrier_5_F",[8.39404,-14.2131,0],174.638,1,0,[0,-0],"","",true,false],
	["Land_BagFence_Long_F",[-0.351563,16.0417,-0.000999451],259.829,1,0,[0,0],"","",true,false],
	["Land_CncBarrier_F",[3.6626,-16.7344,0],88.1946,1,0,[0,0],"","",true,false],
	["Land_BagFence_Long_F",[-10.2988,-13.7379,-0.000999451],265.254,1,0,[0,0],"","",true,false],
	["Land_BagFence_Long_F",[-9.37109,14.6333,-0.000999451],90.4252,1,0,[0,-0],"","",true,false],
	["Land_BagFence_Long_F",[1.1084,17.6057,-0.000999451],353.729,1,0,[0,0],"","",true,false],
	["Land_BagBunker_Tower_F",[7.65479,15.7576,0],83.3112,1,0,[0,0],"","",true,false],
	["Land_HBarrier_5_F",[14.1118,-13.7074,0],174.638,1,0,[0,-0],"","",true,false],
	["Land_BagFence_Long_F",[-11.7588,-15.2178,-0.000999451],175.325,1,0,[0,-0],"","",true,false],
	["Land_BagFence_Long_F",[-10.7998,16.0466,-0.000999451],174.899,1,0,[0,-0],"","",true,false],
	["Land_CncBarrier_F",[3.67822,-19.7557,0],88.3108,1,0,[0,0],"","",true,false],
	["Land_BagFence_Long_F",[15.8545,-15.2628,-0.000999451],216.82,1,0,[0,0],"","",true,false],
	["Land_HBarrier_5_F",[-12.8569,16.501,0],174.638,1,0,[0,-0],"","",true,false],
	["Land_CncBarrier_F",[-13.2866,-18.1967,0],88.1946,1,0,[0,0],"","",true,false],
	["Land_HBarrier_5_F",[-13.8052,-15.7489,0],174.638,1,0,[0,-0],"","",true,false],
	["Land_HBarrier_5_F",[16.8423,18.9153,0],174.638,1,0,[0,-0],"","",true,false],
	["Land_BagFence_Short_F",[17.7158,-16.4235,-0.000999451],196.043,1,0,[0,0],"","",true,false],
	["Land_CncBarrier_F",[-13.271,-21.218,0],88.3108,1,0,[0,0],"","",true,false],
	["Land_BagFence_Long_F",[-18.8574,-17.4034,-0.000999451],286.719,1,0,[0,0],"","",true,false],
	["Land_BagFence_Round_F",[19.8716,-17.2339,-0.00130081],0,1,0,[0,0],"","",true,false],
	["Land_HBarrier_5_F",[-18.5703,16.0177,0],174.638,1,0,[0,-0],"","",true,false],
	["Land_BagFence_Long_F",[22.3672,-16.1661,-0.000999451],158.876,1,0,[0,-0],"","",true,false],
	["Land_HBarrier_5_F",[22.4468,19.3347,0],174.638,1,0,[0,-0],"","",true,false],
	["Land_BagFence_Long_F",[24.5854,-14.3453,-0.000999451],125.424,1,0,[0,-0],"","",true,false],
	["Land_BagBunker_Small_F",[-21.1592,-20.3195,0],355.421,1,0,[0,0],"","",true,false],
	["Land_BagFence_Long_F",[-23.8721,-17.5447,-0.000999451],48.8992,1,0,[0,0],"","",true,false],
	["Land_HBarrier_5_F",[-28.9595,4.99146,0],106.059,1,0,[0,-0],"","",true,false],
	["Land_HBarrier_5_F",[-29.0513,5.39587,0],267.363,1,0,[0,0],"","",true,false],
	["Land_HBarrier_5_F",[-23.9839,15.5726,0],174.638,1,0,[0,-0],"","",true,false],
	["Land_HBarrier_5_F",[30.2036,-11.8606,0],174.638,1,0,[0,-0],"","",true,false],
	["Land_HBarrier_5_F",[-25.2534,-15.5845,0],178.598,1,0,[0,-0],"","",true,false],
	["Land_HBarrier_5_F",[27.8604,19.7798,0],174.638,1,0,[0,-0],"","",true,false],
	["Land_HBarrier_5_F",[-29.7979,-14.3875,0],263.865,1,0,[0,0],"","",true,false],
	["Land_BagBunker_Small_F",[-30.8174,12.8024,0],105.781,1,0,[0,-0],"","",true,false],
	["Land_BagBunker_Large_F",[-34.0962,-4.60852,0],90.0319,1,0,[0,-0],"","",true,false],
	["Land_HBarrier_5_F",[32.6123,9.60486,0],259.583,1,0,[0,0],"","",true,false],
	["Land_HBarrier_5_F",[34.3657,-0.538818,0],81.1292,1,0,[0,0],"","",true,false],
	["Land_HBarrier_5_F",[35.6172,-11.4155,0],174.638,1,0,[0,-0],"","",true,false],
	["Land_BagFence_Long_F",[29.6255,20.7175,-0.000999451],342.242,1,0,[0,0],"","",true,false],
	["Land_HBarrier_5_F",[35.0757,-5.9729,0],82.8852,1,0,[0,0],"","",true,false],
	["Land_BagFence_Long_F",[32.5547,16.1952,-0.000999451],288.34,1,0,[0,0],"","",true,false],
	["Land_BagBunker_Large_F",[37.3188,5.14832,0],260.392,1,0,[0,0],"","",true,false],
	["Land_BagBunker_Small_F",[33.5649,19.942,0],234.861,1,0,[0,0],"","",true,false],
	["Land_BagFence_Long_F",[4.38379,-58.4274,-0.000999451],286.719,1,0,[0,0],"","",true,false],
	["Land_BagFence_Long_F",[-0.726074,-58.8181,-0.000999451],48.8992,1,0,[0,0],"","",true,false],
	["Land_BagBunker_Small_F",[2.08203,-61.3434,0],355.421,1,0,[0,0],"","",true,false]
];

[_dict, "AS_airfield", call DICT_fnc_create] call DICT_fnc_set;
[_dict, "AS_airfield", "center", _center] call DICT_fnc_set;
[_dict, "AS_airfield", "objects", _objects] call DICT_fnc_set;




/*
Grab data:
Mission: Antistasi2
World: ruha
Anchor position: [6691.84, 1652.15]
Area size: 200
Using orientation of objects: yes
*/

_center = [6691.84, 1652.15];
_objects = [
	["Land_BagFence_Long_F",[-31.9443,-35.2479,-0.000999451],247.799,1,0,[0,0],"","",true,false],
	["Land_BagFence_Long_F",[-31.8101,-37.8976,-0.000999451],286.612,1,0,[0,0],"","",true,false],
	["Land_BagFence_Short_F",[-32.4414,-40.0553,-0.000999451],287.96,1,0,[0,0],"","",true,false],
	["Land_BagFence_Long_F",[-64.4277,-6.62732,0.0074501],158.334,1,0,[-0.0964678,0.368088],"","",true,false],
	["Land_BagFence_Long_F",[-52.0381,39.9828,-0.00166702],208.583,1,0,[0,0],"","",true,false],
	["Land_BagBunker_Small_F",[-67.8589,-8.56018,-0.000911713],108.853,1,0,[0.0945263,0.142866],"","",true,false],
	["Land_BagFence_Long_F",[-63.0396,32.1655,-0.0911484],63.7935,1,0,[-6.74498,-7.7918],"","",true,false],
	["Land_BagBunker_Tower_F",[-58.7017,42.3621,0],74.6467,1,0,[0,0],"","",true,false],
	["Land_BagFence_Long_F",[-63.7988,34.8458,-0.232208],91.9895,1,0,[-2.26663,-10.0085],"","",true,false],
	["Land_BagFence_Long_F",[-63.2744,37.0398,-0.216091],122.111,1,0,[3.10967,-9.78789],"","",true,false],
	["Land_BagFence_Long_F",[75.1074,-28.2916,-0.000999451],192.911,1,0,[0,0],"","",true,false],
	["Land_BagFence_Long_F",[77.335,-27.0697,-0.000999451],295.257,1,0,[0,0],"","",true,false],
	["Land_BagFence_Long_F",[126.483,-60.1785,0.0829773],227.773,1,0,[-1.53396,2.55606],"","",true,false],
	["Land_BagFence_Long_F",[126.557,-66.2042,0.053196],297.554,1,0,[-2.86527,2.18316],"","",true,false],
	["Land_BagBunker_Small_F",[128.873,-63.0652,-0.048317],270.134,1,0,[5.45427,0.875539],"","",true,false]
];

[_dict, "AS_powerplant", call DICT_fnc_create] call DICT_fnc_set;
[_dict, "AS_powerplant", "center", _center] call DICT_fnc_set;
[_dict, "AS_powerplant", "objects", _objects] call DICT_fnc_set;


/*
Grab data:
Mission: Antistasi2
World: ruha
Anchor position: [7677.76, 6531.31]
Area size: 200
Using orientation of objects: yes
*/
_center = [7677.76, 6531.31];
_objects = [
	["Land_BagFence_Long_F",[21.896,0.622559,0.00802422],234.161,1,0,[-2.11537,-0.238324],"","",true,false],
	["Land_BagFence_Short_F",[9.84277,21.1816,0.0502224],291.599,1,0,[-1.58727,2.45105],"","",true,false],
	["Land_BagFence_Long_F",[18.3604,15.5752,-0.0305176],158.445,1,0,[2.4246,-1.26596],"","",true,false],
	["Land_BagFence_Short_F",[6.22363,24.1802,0.0208893],196.047,1,0,[1.51188,1.47842],"","",true,false],
	["Land_BagBunker_Small_F",[9.37207,24.2393,-0.0209141],207.113,1,0,[2.28741,1.8154],"","",true,false],
	["Land_BagFence_Short_F",[-23.1909,29.0986,-0.0285511],31.7285,1,0,[-0.61547,-1.72763],"","",true,false],
	["Land_BagFence_Short_F",[-24.7437,29.0122,0.00247955],146.871,1,0,[1.82531,0.177063],"","",true,false],
	["Land_BagFence_Long_F",[25.1626,-29.4722,-0.00440216],263.006,1,0,[-1.59838,-0.09268],"","",true,false],
	["Land_BagFence_Long_F",[-45.627,7.60742,-0.0138474],281.541,1,0,[-2.74755,-0.853321],"","",true,false],
	["Land_BagFence_Long_F",[-14.6279,44.8281,-0.103727],81.2052,1,0,[0.0743631,-4.20727],"","",true,false],
	["Land_BagBunker_Tower_F",[23.9561,-43.2202,-0.000137329],257.548,1,0,[0,0],"","",true,false],
	["Land_BagFence_Long_F",[-36.48,33.7188,0.272268],288.653,1,0,[-5.07794,9.0893],"","",true,false],
	["Land_HBarrier_5_F",[15.2739,-48.6631,0.000566483],337.354,1,0,[-0.770916,0.0117344],"","",true,false],
	["Land_HBarrier_5_F",[10.2153,-50.7866,0.00135994],337.356,1,0,[-0.451575,0.0338149],"","",true,false],
	["Land_HBarrier_5_F",[50.1289,12.4966,0.505291],248.724,1,0,[4.32905,12.5554],"","",true,false],
	["Land_HBarrier_5_F",[48.3325,17.7856,0.454409],248.046,1,0,[0.689134,11.3103],"","",true,false],
	["Land_BagFence_Long_F",[33.7129,-38.9136,-0.0363026],263.036,1,0,[-1.47097,-1.40743],"","",true,false],
	["Land_BagFence_Long_F",[-49.7251,-14.396,-0.0258732],100.617,1,0,[2.40148,-1.15247],"","",true,false],
	["Land_BagFence_Long_F",[30.2163,-42.4839,-0.0574284],327.373,1,0,[0.829431,-1.89169],"","",true,false],
	["Land_BagFence_Long_F",[32.5718,-40.9912,-0.0443478],331.042,1,0,[0.628864,-1.8212],"","",true,false],
	["Land_HBarrier_5_F",[52.3076,7.56689,0.128359],248.302,1,0,[0.365358,3.24273],"","",true,false],
	["Land_Razorwire_F",[-43.0762,32.4937,-1.45197],15.5853,1,0,[-7.81279,-10.0952],"","",true,false],
	["Land_HBarrier_5_F",[46.3115,23.2739,0.0882969],268.764,1,0,[-2.96044,2.21191],"","",true,false],
	["Land_BagFence_Short_F",[24.3945,47.3755,-0.0745792],245.256,1,0,[11.8082,-5.81623],"","",true,false],
	["Land_BagFence_Long_F",[9.7207,-52.7559,-0.0132999],277.551,1,0,[-0.227045,-0.463626],"","",true,false],
	["Land_HBarrier_3_F",[53.0034,6.52832,0.0295792],59.109,1,0,[1.91422,1.52467],"","",true,false],
	["Land_BagFence_Short_F",[35.9346,40.4058,0.107435],158.368,1,0,[0.329425,5.86158],"","",true,false],
	["Land_HBarrier_5_F",[-22.4282,-49.4375,-0.0508671],18.3735,1,0,[2.39816,-1.3169],"","",true,false],
	["Land_HBarrier_5_F",[-0.103516,-54.9956,0.012558],337.356,1,0,[-0.0215529,0.31886],"","",true,false],
	["Land_BagBunker_Small_F",[-51.8057,-17.8594,-0.00144005],91.3816,1,0,[0.149508,-0.282468],"","",true,false],
	["Land_HBarrier_5_F",[-11.0562,-53.0469,0.0203934],13.6631,1,0,[0.316093,0.519136],"","",true,false],
	["Land_BagFence_Long_F",[-24.4487,49.0112,0.109762],36.1408,1,0,[-3.69006,4.56401],"","",true,false],
	["Land_HBarrier_5_F",[20.1025,51.188,0.26898],29.857,1,0,[-6.96617,6.69829],"","",true,false],
	["Land_HBarrier_5_F",[-27.6372,-47.7183,-0.050602],18.3787,1,0,[2.85049,-1.31781],"","",true,false],
	["Land_BagFence_Long_F",[6.01563,-54.5205,0.00151062],28.1971,1,0,[-0.319445,-0.00942633],"","",true,false],
	["Land_HBarrier_5_F",[-5.71436,-54.3306,-0.00413895],13.6633,1,0,[0.172292,-0.104924],"","",true,false],
	["Land_HBarrier_5_F",[46.1743,29.0425,0.038353],259.442,1,0,[-3.4637,0.937222],"","",true,false],
	["Land_BagFence_Short_F",[-17.9136,-52.5874,0.0331631],75.7013,1,0,[2.58017,2.00184],"","",true,false],
	["Land_BagFence_Long_F",[-13.2344,-54.0615,-0.0675068],329.341,1,0,[0.701778,-2.74648],"","",true,false],
	["Land_BagFence_Round_F",[8.64941,-55.3306,0.00872993],333.315,1,0,[-0.0625249,0.51243],"","",true,false],
	["Land_HBarrier_5_F",[15.1187,54.0454,-0.141022],30.2592,1,0,[-6.52892,-3.81986],"","",true,false],
	["Land_HBarrier_5_F",[-51.6187,-24.6699,-0.0652161],284.497,1,0,[-0.751109,-1.67318],"","",true,false],
	["Land_HBarrier_5_F",[-33.7979,-45.5093,-0.0228653],20.2848,1,0,[2.51078,-0.599635],"","",true,false],
	["Land_HBarrier_5_F",[37.521,41.0806,-0.0727444],30.0275,1,0,[1.90954,-1.87345],"","",true,false],
	["Land_Razorwire_F",[-47.4897,32.9727,-2.47316],3.98677,1,0,[4.54064,-13.5249],"","",true,false],
	["Land_HBarrier_5_F",[44.8853,34.6699,0.101431],230.336,1,0,[0.267895,2.56723],"","",true,false],
	["Land_HBarrier_5_F",[10.1958,56.9541,-0.00553703],30.3321,1,0,[-8.53198,-0.341984],"","",true,false],
	["Land_BagFence_Long_F",[-25.5981,51.4331,0.0306072],273.655,1,0,[5.82254,0.660437],"","",true,false],
	["Land_BagBunker_Small_F",[-16.71,-55.562,-0.0309353],20.5944,1,0,[3.41817,-1.77692],"","",true,false],
	["Land_HBarrier_5_F",[-38.9331,-43.6108,0.113859],20.2941,1,0,[3.71157,-1.37802],"","",true,false],
	["Land_BagFence_Long_F",[-10.5527,58.1934,-0.0120049],212.842,1,0,[0.197205,-0.0424721],"","",true,false],
	["Land_BagFence_Long_F",[-24.5508,53.9321,0.199259],308.471,1,0,[-2.98775,8.35829],"","",true,false],
	["Land_HBarrier_5_F",[5.39307,59.9229,-0.130732],30.2089,1,0,[-5.72656,-3.50709],"","",true,false],
	["Land_HBarrier_5_F",[-53.2021,-29.9268,-0.0665436],284.515,1,0,[-1.47967,-1.71427],"","",true,false],
	["Land_HBarrier_5_F",[-44.106,-41.9175,-0.0498714],17.9687,1,0,[1.62006,-1.28165],"","",true,false],
	["Land_BagFence_Long_F",[-22.4839,55.4692,-0.0702171],353.844,1,0,[-0.980207,-5.0677],"","",true,false],
	["Land_BagBunker_Tower_F",[-15.9185,57.8618,0.000614166],32.7767,1,0,[0,0],"","",true,false],
	["Land_BagFence_Short_F",[-52.8711,-31.4712,0.0313129],103.923,1,0,[1.4973,1.6989],"","",true,false],
	["Land_Razorwire_F",[-53.9121,33.3374,1.47013],3.99321,1,0,[4.46892,13.745],"","",true,false],
	["Land_HBarrier_5_F",[-48.9082,-39.9873,-0.109705],23.902,1,0,[3.77424,-2.86977],"","",true,false],
	["Land_BagFence_Long_F",[6.12598,62.374,-0.0908031],108.328,1,0,[3.61905,-4.07397],"","",true,false],
	["Land_BagFence_Round_F",[-53.2412,-33.7559,0.0114346],70.1247,1,0,[3.1049,1.00864],"","",true,false],
	["Land_HBarrier_5_F",[-51.771,-35.2959,0.0485687],60.2261,1,0,[3.65834,1.2045],"","",true,false],
	["Land_BagFence_Long_F",[6.88623,65.2393,0.087429],102.851,1,0,[1.3767,5.58549],"","",true,false],
	["Land_BagFence_Long_F",[-15.0088,64.4839,0.0438881],308.453,1,0,[-2.32507,0.164619],"","",true,false],
	["Land_BagFence_Long_F",[-3.84326,66.6748,-0.00322914],147.102,1,0,[4.95039,0.551318],"","",true,false],
	["Land_BagFence_Long_F",[5.30762,67.2695,0.155024],202.016,1,0,[-7.54023,4.98753],"","",true,false],
	["Land_HBarrier_5_F",[-9.42188,68.4248,-0.0816975],39.6877,1,0,[-3.24774,-2.13728],"","",true,false],
	["Land_Razorwire_F",[-61.2876,32.4922,-0.559652],341.339,1,0,[5.33811,-6.50325],"","",true,false],
	["Land_BagFence_Long_F",[-1.57861,68.4482,-0.0010376],133.835,1,0,[5.48847,1.51262],"","",true,false],
	["Land_HBarrier_5_F",[-13.1631,65.7354,0.106691],306.901,1,0,[-1.66257,2.68993],"","",true,false],
	["Land_BagFence_Long_F",[3.02979,69.0933,0.0193386],244.133,1,0,[-8.15849,0.162235],"","",true,false],
	["Land_BagFence_Long_F",[0.909668,69.8462,0.159534],172.06,1,0,[2.18273,7.32202],"","",true,false],
	["Land_Razorwire_F",[-69.5518,30.2017,-1.849],342.798,1,0,[-3.37895,-17.174],"","",true,false],
	["Land_Razorwire_F",[-74.1514,26.3677,-1.19372],306.156,1,0,[-10.9863,-9.45993],"","",true,false],
	["Land_Razorwire_F",[-70.7251,-33.0122,0.116957],218.715,1,0,[-0.492968,1.07325],"","",true,false],
	["Land_Razorwire_F",[-76.5459,20.3604,-0.120111],290.412,1,0,[0.0815899,-1.03927],"","",true,false],
	["Land_Razorwire_F",[-78.855,13.4502,-0.152281],290.412,1,0,[0.0815899,-1.03927],"","",true,false],
	["Land_Razorwire_F",[-76.0264,-27.8193,0.0669746],242.986,1,0,[-1.02087,0.520507],"","",true,false],
	["Land_Razorwire_F",[-81.0352,-1.75537,-0.0803642],262.389,1,0,[-1.5335,-0.662263],"","",true,false],
	["Land_Razorwire_F",[-81.8159,6.16113,-0.127043],290.412,1,0,[0.0815899,-1.03927],"","",true,false],
	["Land_Razorwire_F",[-80.8574,-12.8247,-0.0586147],262.385,1,0,[-1.51438,-0.520141],"","",true,false],
	["Land_Razorwire_F",[-79.769,-20.3516,0.1141],262.345,1,0,[-1.60789,0.938832],"","",true,false]
];

[_dict, "AS_base_1", call DICT_fnc_create] call DICT_fnc_set;
[_dict, "AS_base_1", "center", _center] call DICT_fnc_set;
[_dict, "AS_base_1", "objects", _objects] call DICT_fnc_set;




/*
Grab data:
Mission: AS_remastered
World: ruha
Anchor position: [995.222, 4981.53]
Area size: 100
Using orientation of objects: yes
*/

_center = [995.222, 4981.53];
_objects = [
	["Land_HBarrier_01_tower_green_F",[18.5551,1.05615,0.00111771],291.811,1,0,[0,0],"","",true,false],
	["Land_HBarrier_01_line_3_green_F",[21.1401,4.94336,0.000499725],113.414,1,0,[0.447228,1.13003],"","",true,false],
	["Land_BagFence_01_long_green_F",[18.5171,11.5093,0.0424862],212.275,1,0,[-0.67548,1.606],"","",true,false],
	["Land_HBarrier_01_line_1_green_F",[21.7848,7.36523,0.000581741],265.02,1,0,[-0.738134,-0.222744],"","",true,false],
	["Land_CzechHedgehog_01_new_F",[25.002,-9.62988,-4.57764e-005],0.00695301,1,0,[0.619537,1.10107],"","",true,false],
	["Land_CzechHedgehog_01_new_F",[17.2601,-20.7778,0.000284195],359.997,1,0,[0.429704,1.00238],"","",true,false],
	["Land_CncBarrier_F",[26.3381,-7.1167,0.00025177],112.521,1,0,[-1.22292,-0.0418901],"","",true,false],
	["Land_CncBarrier_F",[27.179,-3.88525,0.00135994],93.8349,1,0,[1.27044,4.66876],"","",true,false],
	["Land_CncBarrier_F",[28.0679,-0.574707,0.000146866],114.347,1,0,[-0.413311,0.913334],"","",true,false],
	["Land_CncBarrier_F",[16.8943,-23.6294,0.000209808],106.8,1,0,[-0.509169,1.19269],"","",true,false],
	["Land_CncBarrier_F",[16.4328,-27.0464,0.000640869],86.1282,1,0,[-1.13231,2.37228],"","",true,false],
	["Land_CncBarrier_F",[15.975,-30.3862,0.00974464],106.233,1,0,[-8.7226,-8.90211],"","",true,false],
	["Land_BagBunker_01_large_green_F",[25.802,-23.5898,-0.00128746],0.00143232,1,0,[0.143228,0.572955],"","",true,false],
	["Land_BagFence_01_long_green_F",[-38.7219,-39.4536,0.0238419],118.918,1,0,[-0.873685,0.989959],"","",true,false],
	["Land_BagBunker_01_small_green_F",[-40.778,-42.8496,-0.00529289],336.084,1,0,[0.580645,1.30913],"","",true,false],
	["Land_HBarrier_01_tower_green_F",[-53.0363,-30.1812,0.00134468],68.7408,1,0,[0,0],"","",true,false],
	["Land_CzechHedgehog_01_new_F",[-60.2377,-15.189,1.52588e-005],0.000934179,1,0,[-0.14342,0.143379],"","",true,false],
	["Land_HBarrier_01_line_5_green_F",[-46.1785,-42.1401,0.000404358],19.6401,1,0,[1.43567,0.663929],"","",true,false],
	["Land_HBarrier_01_line_5_green_F",[-51.3719,-35.8594,0.00153351],61.7661,1,0,[-0.120115,2.50163],"","",true,false],
	["Land_CncBarrier_F",[-61.5679,-11.9873,1.71661e-005],62.3694,1,0,[-0.0602176,0.192513],"","",true,false],
	["Land_BagFence_01_long_green_F",[-49.4133,-39.5,-0.0268059],240.169,1,0,[0.851359,-0.818626],"","",true,false],
	["Land_CzechHedgehog_01_new_F",[-60.8925,-29.7822,5.72205e-005],359.997,1,0,[-0.286515,0.430168],"","",true,false]


];

[_dict, "AS_outpost_5", call DICT_fnc_create] call DICT_fnc_set;
[_dict, "AS_outpost_5", "center", _center] call DICT_fnc_set;
[_dict, "AS_outpost_5", "objects", _objects] call DICT_fnc_set;




/*
Grab data:
Mission: AS_objects
World: ruha
Anchor position: [3465.24, 7091.87]
Area size: 300
Using orientation of objects: yes
*/
_center = [3465.24, 7091.87];

_objects =

[
	["Land_BagFence_01_round_green_F",[27.0471,3.12012,-0.0620689],190.876,1,0,[0.405385,-2.10894],"","",true,false],
	["Land_HBarrier_01_line_5_green_F",[30.9966,3.40283,0.000572205],167.923,1,0,[-1.9493,-2.95012],"","",true,false],
	["Land_HBarrier_01_tower_green_F",[31.3298,-5.67285,0.00265121],260.628,1,0,[0,0],"","",true,false],
	["Land_HBarrier_01_line_5_green_F",[34.074,0.446777,0.000545502],256.011,1,0,[2.88356,-2.04664],"","",true,false],
	["Land_BagFence_01_long_green_F",[-32.8467,-33.8535,-0.0142021],153.89,1,0,[-0.443184,-0.580166],"","",true,false],
	["Land_BagFence_01_long_green_F",[-33.3982,-35.8477,0.0120468],61.8719,1,0,[-1.0189,0.220446],"","",true,false],
	["Land_BagFence_01_long_green_F",[-27.604,-41.8062,-0.00855637],322.93,1,0,[0.400574,0.055798],"","",true,false],
	["Land_BagBunker_01_small_green_F",[-32.5088,-39.269,0.00329208],51.8401,1,0,[-0.321934,0.98121],"","",true,false],
	["Land_BagFence_01_long_green_F",[-29.5581,-41.2593,0.0145378],61.8657,1,0,[-0.622989,0.657414],"","",true,false],
	["Land_BagFence_01_round_green_F",[12.3171,53.5869,0.0137482],258.361,1,0,[2.61008,-0.0996655],"","",true,false],
	["Land_HBarrier_01_big_tower_green_F",[-30.4138,45.9507,0.00386429],118.168,1,0,[-1.66828,0.0815393],"","",true,false],
	["Land_HBarrier_01_line_3_green_F",[11.1018,56.291,-0.00031662],257.305,1,0,[1.22608,-0.422438],"","",true,false],
	["Land_BagFence_01_long_green_F",[-23,52.7124,0.00493622],107.311,1,0,[-0.443444,0.461625],"","",true,false],
	["Land_BagFence_01_long_green_F",[-21.3105,54.9487,0.0391769],152.951,1,0,[-1.01488,1.16171],"","",true,false],
	["Land_HBarrier_01_line_5_green_F",[-10.0925,-58.1216,8.7738e-005],265.083,1,0,[2.01785,-1.61085],"","",true,false],
	["Land_BagFence_01_round_green_F",[-3.25806,-59.0869,-0.0313797],284.282,1,0,[-0.133925,-1.21629],"","",true,false],
	["Land_BagFence_01_long_green_F",[-18.6543,56.3408,0.00373459],333.299,1,0,[0.319576,-0.00108043],"","",true,false],
	["Land_HBarrier_01_line_5_green_F",[-7.34155,59.9834,-6.48499e-005],175.205,1,0,[0.975084,-0.368825],"","",true,false],
	["Land_HBarrier_01_line_5_green_F",[-1.71265,60.4722,0.000881195],175.203,1,0,[-2.10409,0.60778],"","",true,false],
	["Land_BagBunker_01_large_green_F",[5.58691,62.1367,-0.0301514],173.479,1,0,[3.2132,1.65302],"","",true,false],
	["Land_HBarrier_01_big_tower_green_F",[-6.84521,-62.4688,-0.000484467],355.306,1,0,[2.32777,2.10889],"","",true,false],
	["Land_HBarrier_01_line_5_green_F",[-63.3303,-15.6284,0.000747681],0,1,0,[-1.14586,1.14608],"","",true,false],
	["Land_BagBunker_01_small_green_F",[-62.6123,-26.2773,-0.00405121],0,1,0,[0.429308,0.716005],"","",true,false],
	["Land_HBarrier_01_line_5_green_F",[-66.314,-18.9873,0.00448608],88.1629,1,0,[-4.5021,-5.85398],"","",true,false],
	["Land_BagFence_01_long_green_F",[-65.1226,-23.2041,-0.00429535],58.1834,1,0,[-0.457658,0.620483],"","",true,false]
];

[_dict, "AS_resource_3", call DICT_fnc_create] call DICT_fnc_set;
[_dict, "AS_resource_3", "center", _center] call DICT_fnc_set;
[_dict, "AS_resource_3", "objects", _objects] call DICT_fnc_set;

/*
Grab data:
Mission: AS_objects
World: ruha
Anchor position: [4352.9, 4442.25]
Area size: 100
Using orientation of objects: yes
*/
_center = [4352.9, 4442.25];
_objects =
[
["Land_HBarrier_01_line_5_green_F",[1.24463,3,0],49.6101,1,0,[0,0],"","",true,false],
["Land_HBarrier_01_line_5_green_F",[4.91553,-1.3623,3.48091e-005],49.6109,1,0,[-0.403137,-0.0325157],"","",true,false],
["Land_HBarrier_01_line_5_green_F",[-2.69287,4.45752,0],142.678,1,0,[0,-0],"","",true,false],
["Land_BagFence_01_long_green_F",[-6.28467,0.301758,-0.000999928],229.548,1,0,[0,0],"","",true,false],
["Land_BagFence_01_long_green_F",[-6.25244,2.42969,-0.000999928],138.172,1,0,[0,-0],"","",true,false],
["Land_BagFence_01_long_green_F",[-2.04346,7.69482,-0.000999928],229.548,1,0,[0,0],"","",true,false],
["Land_HBarrier_01_line_5_green_F",[5.854,-5.39697,-6.24657e-005],139.032,1,0,[0.0141972,-0.201226],"","",true,false],
["Land_BagFence_01_long_green_F",[1.14014,-8.979,-0.000999928],230.233,1,0,[0,0],"","",true,false],
["Land_BagFence_01_long_green_F",[3.13037,-8.81787,-0.00554895],138.172,1,0,[0.0111783,-0.201416],"","",true,false],
["Land_BagFence_01_long_green_F",[-3.86377,9.80957,-0.000999928],229.548,1,0,[0,0],"","",true,false],
["Land_BagFence_01_long_green_F",[-5.91943,9.82617,-0.000999928],133.048,1,0,[0,-0],"","",true,false],
["Land_BagFence_01_long_green_F",[-20.1885,8.56006,-0.000999928],81.4116,1,0,[0,0],"","",true,false],
["Land_HBarrier_01_line_5_green_F",[21.0171,-9.12207,0.0367107],59.0294,1,0,[5.59937,16.0731],"","",true,false],
["Land_BagFence_01_long_green_F",[-20.4561,11.3608,-0.000999928],274.463,1,0,[0,0],"","",true,false],
["Land_BagFence_01_long_green_F",[-10.7559,22.4902,-0.000999928],134.606,1,0,[0,-0],"","",true,false],
["Land_BagFence_01_long_green_F",[-8.67773,24.6953,-0.000999928],134.606,1,0,[0,-0],"","",true,false],
["Land_Razorwire_F",[-24.7964,5.91943,-2.86102e-006],244.116,1,0,[0,0],"","",true,false],
["Land_HBarrier_01_line_5_green_F",[23.9746,-13.998,0.00156021],58.5947,1,0,[0.674726,-5.44186],"","",true,false],
["Land_Razorwire_F",[-27.4004,12.981,0.00819492],265.917,1,0,[0,0],"","",true,false],
["Land_HBarrier_01_line_5_green_F",[26.8374,-18.7651,0.00658703],58.3834,1,0,[0.313953,-9.2632],"","",true,false],
["Land_Razorwire_F",[-18.9917,30.4385,-0.730481],310.077,1,0,[-11.9384,-9.54203],"","",true,false],
["Land_BagBunker_01_large_green_F",[28.4917,-26.7241,-0.0189314],48.4884,1,0,[1.98024,1.31918],"","",true,false],
["Land_BagFence_01_long_green_F",[37.6304,-16.8828,0.181206],289.198,1,0,[-0.304099,7.00583],"","",true,false],
["Land_HBarrier_01_line_5_green_F",[38.3096,-20.8359,0.00127292],55.1484,1,0,[-3.37364,-1.32057],"","",true,false],
["Land_HBarrier_01_line_5_green_F",[36.501,-24.8887,0.00435019],322.635,1,0,[1.77038,4.76933],"","",true,false],
["Land_Razorwire_F",[-5.80029,43.02,-0.0320256],309.075,1,0,[-2.77006,2.72877],"","",true,false],
["Land_BagFence_01_long_green_F",[-37.0928,-28.4023,-0.0623622],165.675,1,0,[3.79206,-4.22549],"","",true,false],
["Land_CzechHedgehog_01_new_F",[3.98584,47.2222,0.09584],359.99,1,0,[19.1628,-4.00952],"","",true,false],
["Land_CzechHedgehog_01_new_F",[6.89111,48.8779,0.0776691],1.09738,1,0,[13.2078,-0.634345],"","",true,false],
["Land_BagFence_01_long_green_F",[49.9229,-8.14746,0.280555],157.841,1,0,[5.04127,6.57997],"","",true,false],
["Land_Razorwire_F",[-1.48242,49.3232,-0.299092],282.734,1,0,[-21.1261,-4.69869],"","",true,false],
["Land_BagFence_01_long_green_F",[-51.0557,1.12402,-0.042694],230.53,1,0,[-3.08106,-2.83911],"","",true,false],
["Land_BagFence_01_long_green_F",[-51.1177,-1.25342,0.0392396],138.12,1,0,[-2.63172,1.78266],"","",true,false],
["Land_BagFence_01_long_green_F",[51.8853,-8.79248,-0.0577574],61.8719,1,0,[-0.560885,-2.18044],"","",true,false],
["Land_BagFence_01_long_green_F",[-53.0996,1.104,0.0653538],138.126,1,0,[-2.44034,1.99627],"","",true,false],
["Land_HBarrier_01_line_5_green_F",[-56.3633,1.35791,0.000537157],222.662,1,0,[-2.2194,-2.23942],"","",true,false],
["Land_CzechHedgehog_01_new_F",[16.4712,57.4883,0.00476933],359.999,1,0,[1.4596,3.86319],"","",true,false],
["Land_HBarrier_01_line_3_green_F",[60.1387,2.97803,0],318.748,1,0,[0,0],"","",true,false],
["Land_HBarrier_01_tower_green_F",[61.251,8.87256,0],140.082,1,0,[0,-0],"","",true,false],
["Land_CzechHedgehog_01_new_F",[17.9858,60.4971,0.00478363],359.988,1,0,[0.000953234,4.43282],"","",true,false],
["Land_BagBunker_01_small_green_F",[-64.6616,5.23584,-0.00504947],146.991,1,0,[0.576701,-1.74094],"","",true,false],
["Land_HBarrier_01_line_3_green_F",[-65.1069,-9.50879,0.000308514],250.132,1,0,[-0.64756,-0.527307],"","",true,false],
["Land_BagFence_01_long_green_F",[-66.3979,1.85303,0.172738],302.514,1,0,[-0.467505,5.79727],"","",true,false],
["Land_BagFence_01_long_green_F",[-66.978,-0.739746,0.0307872],84.4762,1,0,[-0.372676,0.611369],"","",true,false],
["Land_HBarrier_01_line_5_green_F",[-66.8154,-5.11035,-4.41074e-005],250.194,1,0,[-1.03542,-1.60578],"","",true,false],
["Land_Razorwire_F",[49.5098,-49.5796,-0.490614],313.397,1,0,[0.889902,-4.27597],"","",true,false],
["Land_Razorwire_F",[45.1675,-55.1514,-1.59435],313.801,1,0,[-1.52246,-8.73524],"","",true,false],
["Land_Razorwire_F",[12.7788,68.5791,0.290994],311.538,1,0,[-19.355,0.92357],"","",true,false],
["Land_Razorwire_F",[38.8223,-61.5938,1.53079],312.86,1,0,[-7.75896,12.2869],"","",true,false],
["Land_BagFence_01_long_green_F",[-53.9077,-53.3901,0.0221076],328.131,1,0,[0.457068,-0.62092],"","",true,false],
["Land_Razorwire_F",[18.0088,74.0044,0.0486813],312.629,1,0,[-13.4411,-0.533852],"","",true,false],
["Land_BagFence_01_long_green_F",[-56.5708,-53.7637,0.00103045],198.253,1,0,[-0.769531,0.0473622],"","",true,false],
["Land_BagFence_01_long_green_F",[-60.2705,-49.7114,-0.00869942],57.9871,1,0,[-0.576517,-0.653071],"","",true,false],
["Land_BagFence_01_long_green_F",[-58.7803,-52.0586,0.0235128],57.9834,1,0,[0.258662,0.682704],"","",true,false],
["Land_Razorwire_F",[22.9814,79.395,-0.111901],312.844,1,0,[-11.2718,-0.4322],"","",true,false],
["Land_BagFence_01_long_green_F",[96.1133,17.584,-0.000999928],136.977,1,0,[0,-0],"","",true,false],
["Land_BagFence_01_long_green_F",[98.1646,17.311,-0.000999928],229.727,1,0,[0,0],"","",true,false]
];

[_dict, "AS_resource_2", call DICT_fnc_create] call DICT_fnc_set;
[_dict, "AS_resource_2", "center", _center] call DICT_fnc_set;
[_dict, "AS_resource_2", "objects", _objects] call DICT_fnc_set;

/*
Grab data:
Mission: AS_objects
World: ruha
Anchor position: [754.179, 3540.93]
Area size: 100
Using orientation of objects: yes
*/

_center = [754.179, 3540.93];
_objects =

[
	["Land_Caravan_01_rust_F",[-10.6373,-11.4014,0.0256596],125.939,1,0,[0,-0],"","",true,false],
	["Land_BagFence_01_long_green_F",[-16.4783,1.98608,0.0310574],210.482,1,0,[-2.20005,1.19798],"","",true,false],
	["Land_BagFence_01_long_green_F",[-18.2931,1.13916,0.00778961],119.45,1,0,[1.20894,0.189124],"","",true,false],
	["Land_HBarrier_01_line_5_green_F",[-20.359,-2.8562,-0.000219345],124.559,1,0,[0.584092,-1.85805],"","",true,false],
	["Land_Caravan_01_green_F",[-14.748,-15.9414,0.00460815],123.828,1,0,[0,-0],"","",true,false],
	["Land_HBarrier_01_line_5_green_F",[-23.5094,-7.44165,0.000375748],124.55,1,0,[1.9026,0.267125],"","",true,false],
	["Land_BagFence_01_long_green_F",[17.5524,-19.5,-0.00981712],88.4477,1,0,[-1.30009,-0.394249],"","",true,false],
	["Land_BagFence_01_long_green_F",[17.7199,-22.3459,-0.00504303],88.4394,1,0,[-0.4335,-0.130895],"","",true,false],
	["Land_HBarrier_01_line_5_green_F",[-26.6803,-12.0151,3.8147e-005],124.52,1,0,[1.88872,-1.48166],"","",true,false],
	["Land_BagFence_01_long_green_F",[28.3082,-8.97388,0.0266418],310.998,1,0,[0.563634,-0.648426],"","",true,false],
	["Land_HBarrier_01_line_3_green_F",[6.44604,-29.1079,-0.000303268],184.387,1,0,[1.3507,-0.758237],"","",true,false],
	["Land_BagFence_01_long_green_F",[29.1334,-6.61987,-0.102438],88.4721,1,0,[-0.5376,-3.99129],"","",true,false],
	["Land_BagBunker_01_large_green_F",[12.8806,-27.5803,0.0056572],7.7943,1,0,[-0.541906,0.79321],"","",true,false],
	["Land_BagFence_01_long_green_F",[-29.4202,-15.4424,-0.125053],119.347,1,0,[2.61109,-4.92746],"","",true,false],
	["Land_BagFence_01_long_green_F",[-28.8701,-17.4768,0.0950375],218.942,1,0,[4.42615,3.39576],"","",true,false],
	["Land_BagFence_01_long_green_F",[29.5731,46.3237,0.184711],105.291,1,0,[4.71218,5.57993],"","",true,false],
	["Land_BagFence_01_long_green_F",[31.2787,47.6079,0.0946159],184.785,1,0,[-0.428916,3.4098],"","",true,false],
	["Land_BagFence_01_long_green_F",[40.7529,42.3167,-0.0272141],289.629,1,0,[4.01424,-1.45511],"","",true,false],
	["Land_BagFence_01_long_green_F",[-28.4967,-51.8806,0.00110054],22.7207,1,0,[0.90311,0.0681055],"","",true,false],
	["Land_BagBunker_01_small_green_F",[-24.0392,-55.1577,-0.00716591],8.01954,1,0,[0.74888,-0.183324],"","",true,false],
	["Land_BagFence_01_long_green_F",[40.1046,44.644,-0.0856285],218.019,1,0,[1.01401,-3.38616],"","",true,false],
	["Land_HBarrier_01_big_tower_green_F",[36.2233,48.1089,0.00192261],195.267,1,0,[0.967298,-2.99969],"","",true,false]
];

[_dict, "AS_resource_4", call DICT_fnc_create] call DICT_fnc_set;
[_dict, "AS_resource_4", "center", _center] call DICT_fnc_set;
[_dict, "AS_resource_4", "objects", _objects] call DICT_fnc_set;
