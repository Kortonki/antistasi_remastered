#include "../macros.hpp"
AS_SERVER_ONLY("AS_stats_fnc_deinitialize");
if ([AS_container, "stats"] call DICT_fnc_exists) then {
  [AS_container, "stats"] call DICT_fnc_del;
};
