class AS_manageLocations
{
	idd=1602;
	movingenable=false;

	class controls
	{
AS_DIALOG(4,"Manage locations", "closeDialog 0;");

// build new
//LIST_L(0,1,0,3,"");
BTN_L(1,-1,"Build Camp (200€)",	"Deliver the crate to the desired position","['camp'] spawn AS_fnc_UI_manageLocations_add");
BTN_L(2,-1,"Build Roadblock (200€)", "Deliver the crate to the desired position","['roadblock'] spawn AS_fnc_UI_manageLocations_add");
BTN_L(3,-1,"Build Watchpost (200€)", "Deliver the crate to the desired position", "['watchpost'] spawn AS_fnc_UI_manageLocations_add");


// remove existing
BTN_R(1,-1,"Abandon","Select a location on the map to abandon","'abandon' spawn AS_fnc_UI_manageLocations_selectOnMap; closeDialog 0;");
BTN_R(2,-1,"Rename camp","Select a camp on the map to rename","'rename' spawn AS_fnc_UI_manageLocations_selectOnMap; closeDialog 0;");
	};
};

class AS_manageLocations_rename
{
    idd=1602;
	movingenable=false;

    class controls
    {
AS_DIALOG(1,"Rename camp", "closeDialog 0;");
WRITE(1,1,1,"camp name");
BTN_R(1,-1,"Save", "closeDialog 0;");
	};
};
