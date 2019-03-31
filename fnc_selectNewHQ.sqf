#include "macros.hpp"
AS_CLIENT_ONLY("fnc_selectNewHQ");

AS_commander allowDamage false;
AS_commander setcaptive true;
"Petros is Dead" hintC "Petros has been killed. You lost part of your influence and need to select a new HQ position far from the enemies.";

private _position = [false] call AS_fnc_UI_newGame_selectHQ;

AS_commander allowDamage true;
AS_commander setcaptive false;

[_position, false] remoteExec ["AS_fnc_HQplace", 2];
