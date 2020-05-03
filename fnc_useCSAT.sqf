#include "macros.hpp"

if (((random 100 < AS_P("CSATsupport")) or (call AS_fnc_NATOinvolved)) and {not(AS_S("blockCSAT"))}) exitWith {true};
false
