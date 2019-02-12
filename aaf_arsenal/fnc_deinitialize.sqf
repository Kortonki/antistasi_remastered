#include "../macros.hpp"
AS_SERVER_ONLY("AS_AAFarsenal_fnc_deinitialize");
if ([AS_container, "aaf_arsenal"] call DICT_fnc_exists) then {
    [AS_container, "aaf_arsenal"] call DICT_fnc_del;
};
