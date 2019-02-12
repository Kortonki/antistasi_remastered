#include "../macros.hpp"
AS_SERVER_ONLY("AS_players_fnc_deinitialize");
if ([AS_container, "players"] call DICT_fnc_exists) then {
  [AS_container, "players"] call DICT_fnc_del;
};
