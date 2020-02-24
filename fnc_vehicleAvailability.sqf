#include "macros.hpp"

params ["_category", "_minimumShare"]; //minimum share is from 0 to 1, higher value means the location is low on priority for such vehicle ->



if (_category call AS_AAFarsenal_fnc_countAvailable >= (_category call AS_AAFarsenal_fnc_max)*_minimumShare) exitWith {
  true
};

false
