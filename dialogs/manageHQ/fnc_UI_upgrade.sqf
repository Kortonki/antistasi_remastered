#include "../../macros.hpp"

if (BE_currentStage == 3) exitWith {
    hint "No further training available.";
};
private _price = call fnc_BE_calcPrice; //TODO: Consider doing this server side so no need to publish so much in BE_module
if (AS_P("resourcesFIA") > _price) then {
    [] remoteExec ["fnc_BE_upgrade", 2];
    hint "FIA upgraded";
} else {
    hint "Not enough money.";
};
