class AS_ManageMissions
{
	idd=1602;
	movingenable=false;

	class controls
	{
AS_DIALOG(8,"Manage missions", "closeDialog 0;");

LIST_L(0,1,0,7,"call AS_fnc_UI_manageMissions_updatePanel;");
READ(1,1,1,7, "Mission information");

BTN_L(8,-1,"City Missions", "", "closeDialog 0; [] spawn AS_fnc_UI_manageMissions_cityMissions;");
BTN_R(8,-1,"Start selected", "", "call AS_fnc_UI_manageMissions_activate;");
	};
};

class AS_cityMissions
{
	idd=1603;
	movingenable=false;

	class controls
	{
			AS_DIALOG(3, "City Missions", "closeDialog 0;");

			BTN_M(1,-1, "Supply City", "Costs 100€. Good to increase FIA city support and foreign support", "closeDialog 0; AS_cityMission_type = 'send_meds';");
			BTN_M(2,-1, "Propaganda", "Costs 600€ (Truck can be sold afterwards): Good to increase FIA city support and to lower enemy support. Depends how long you maintain the propaganda station.", "closeDialog 0; AS_cityMission_type = 'broadcast';");
			BTN_M(3,-1, "Drop leaflets", "Costs 100€. Lowers enemy city and foreign support and increases FIA support some", "closeDialog 0; AS_cityMission_type = 'pamphlets';");
	};
};
