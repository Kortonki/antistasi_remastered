#include "macros.hpp"

private _AAFres = AS_P("resourcesAAF");
private _AAFlocCount = count ([["base","airfield","outpost","resource","factory","powerplant","seaport"],"AAF"] call AS_location_fnc_TS);
private _AAFresAdj = _AAFres / _AAFlocCount;
_AAFresAdj
