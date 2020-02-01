class AS_manageGarrisons
{
	idd=1602;
	movingenable=false;

	class controls
	{
AS_DIALOG(6,"Manage garrison - Press BACK to respawn garrison", "closeDialog 0; call AS_fnc_UI_manageHQ_menu; if (not(isNil ""garrisonUpdated"")) then {[map_location] spawn AS_location_fnc_respawnGarrison; map_location = nil; garrisonUpdated = nil;};");

LIST_L(0,1,1,4,"");

BTN_L(5,-1,"Recruit selected", "Recruit the unit selected above", "call AS_fnc_UI_manageGarrisons_recruit;");
BTN_R(1,2,"Select location", "Select the location", "[] spawn AS_fnc_UI_manageGarrisons_selectOnMap;");
BTN_M(6,-1, "Garrison orders", "Garrison orders", "closeDialog 0; createDialog ""AS_manageGarrisons_orders"";");
LIST_L(1,2,3,3,"");
BTN_R(5,-1,"Dismiss selected", "Dismiss the unit selected above", "call AS_fnc_UI_manageGarrisons_dismiss;");
	};
};

class AS_manageGarrisons_orders
{
	idd=1702;
	movingenable=false;

	class controls
	{
		AS_DIALOG(4,"Manage garrison orders", "closeDialog 0; createDialog ""AS_manageGarrisons"";");

		BTN_L(1, -1, "Open Fire", "Open fire", "[""YELLOW""] call AS_fnc_UI_manageGarrisons_orders;");
		BTN_R(1, -1, "Hold Fire", "Hold fire", "[""GREEN""] call AS_fnc_UI_manageGarrisons_orders;");

		BTN_L(3, -1, "Safe", "Safe", "[""SAFE""] call AS_fnc_UI_manageGarrisons_orders;");
		BTN_R(3, -1, "Aware", "Aware", "[""AWARE""] call AS_fnc_UI_manageGarrisons_orders;");
		BTN_L(4, -1, "Combat", "Combat", "[""COMBAT""] call AS_fnc_UI_manageGarrisons_orders;");
		BTN_R(4, -1, "Stealth", "Stealth", "[""STEALTH""] call AS_fnc_UI_manageGarrisons_orders;");
	};
};
