class AS_manageHQ
{
	idd=1602;
	movingenable=false;

	class controls
	{
AS_DIALOG(4, "FIA HQ", A_CLOSE);

BTN_L(1,-1, "Grab 100 € from Pool", "Gain personal money and lose prestige", "call AS_fnc_UI_manageHQ_takeMoney;");
BTN_L(2,-1, "Manage Garrisons", "Recruit/dismiss units to garrison locations", "closeDialog 0; call AS_fnc_UI_manageGarrisons_menu;");
BTN_L(3,-1, "Move HQ to another position", "", "call AS_fnc_UI_manageHQ_move");

BTN_R(1,109, "Upgrade HQ", "Increase HR capacity, FIA skill cap and vehicle supply capacity", "call AS_fnc_UI_manageHQ_upgrade");
BTN_R(2,-1, "Rebuild Assets", "Rebuild a destroyed location (5.000 €)", "[] spawn AS_UI_manageHQ_rebuild;");
BTN_R(3, -1, "Respawn Petros", "", "closeDialog 0; [] spawn AS_fnc_respawnPetros;");

BTN_M(4,-1, "Missions", "Missions screen", "closeDialog 0; [] spawn AS_fnc_UI_manageMissions_menu;");
	};
};
