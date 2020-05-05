#include "macros.hpp"

if (AS_P("CSATsupport") >= 10 and {not(AS_S("blockCSAT")) and {((random 100 < AS_P("CSATsupport")) or (call AS_fnc_NATOinvolved))}}) exitWith {true};
false
