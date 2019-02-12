#include "../macros.hpp"
AS_SERVER_ONLY("AS_location_fnc_deinitialize");
if ([AS_container, "location"] call DICT_fnc_exists) then {
  [AS_container, "location"] call DICT_fnc_del;
};
