
    class ace_interaction_enableTeamManagement {
        title = "Enable Team Management";
            ACE_setting = 1;
            values[] = {0,1};
            texts[] = {"Off","On"};
            default = 0;
            typeName = "BOOL";
            force = 1;
    };

    class ace_ui_groupBar {
        title = "Group Bar";
        ACE_setting = 1;
        values[] = {0, 1};
        texts[] = {"Off", "On"};
        default = 1;
        typeName = "BOOL";
        force = 1;
    };

    class ace_weather_enabled {
        title = "ACE Weather";
        ACE_setting = 1;
        values[] = {0, 1};
        texts[] = {"Off", "On"};
        default = 1;
        typeName = "BOOL";
        force = 1;
    };

    class ace_weather_updateInterval {
        title = "ACE Weather Update Interval";
        ACE_setting = 1;
        values[] = {10, 30, 60, 90, 120};
        texts[] = {"10", "30", "60", "90", "120"};
        default = 10;
        typeName = "SCALAR";
        force = 1;
    };

    class ace_weather_windSimulation {
        title = "ACE Weather Wind Simulation";
        ACE_setting = 1;
        values[] = {0, 1};
        texts[] = {"Off", "On"};
        default = 1;
        typeName = "BOOL";
        force = 1;
    };

    class ace_winddeflection_enabled {
        title = "ACE Wind Deflection";
        ACE_setting = 1;
        values[] = {0, 1};
        texts[] = {"Off", "On"};
        default = 1;
        typeName = "BOOL";
        force = 1;
    };



    class ace_map_BFT_HideAiGroups {
        title = "Hide AI groups on map?";
            ACE_setting = 1;
            values[] = {0,1};
            texts[] = {"Off","On"};
            default = 1;
            typeName = "BOOL";
            force = 1;
    };

    class ace_map_BFT_ShowPlayerNames {
        title = "Show player names map?";
            ACE_setting = 1;
            values[] = {0,1};
            texts[] = {"Off","On"};
            default = 1;
            typeName = "BOOL";
            force = 1;
    };

    class ace_map_defaultChannel {
        title = "Map default channel";
            ACE_setting = 1;
            values[] = {0,5};
            texts[] = {"0","5"};
            default = 5;
            typeName = "SCALAR";
            force = 1;
    };

    class ace_medical_level { //This needs to match an ace_setting, this one is a "SCALAR"(number)
            title = "Medical Level"; // Name that is shown
            ACE_setting = 1; //Marks param to be read as an ace setting, without this nothing will happen!
            values[] = {1, 2}; //Values that ace_medical_level can be set to
            texts[] =  {"Basic", "Advanced"}; //Text names to show for values (Basic will set level to 1, Advanced will set level to 2)
            default = 2; //Default value used - Value should be in the values[] list
    };

    class ace_medical_increaseTrainingInLocations {
        title = "Locations boost medical training?";
            ACE_setting = 1;
            values[] = {0,1};
            texts[] = {"Off","On"};
            default = 1;
            typeName = "BOOL";
            force = 1;
    };

    class ace_medical_enableRevive {
        title = "Medical, enable revive?";
            ACE_setting = 1;
            values[] = {0,2};
            texts[] = {"0","2"};
            default = 0;
            typeName = "SCALAR";
            force = 1;
    };


    class ace_medical_medicSetting_basicEpi {
        title = "Full heal on epi injection restricted to medic?";
            ACE_setting = 1;
            values[] = {0,1};
            texts[] = {"Off","On"};
            default = 1;
            typeName = "SCALAR";
            force = 1;
    };

    class ace_microdagr_mapDataAvailable {
        title = "MicroDAGR map fill";
            ACE_setting = 1;
            values[] = {0,1};
            texts[] = {"Off","On"};
            default = 1;
            typeName = "SCALAR";
            force = 1;
    };


    class ace_repair_fullRepairLocation {
        title = "Full repair locations?";
            ACE_setting = 1;
            values[] = {0,3};
            texts[] = {"Anywhere","Repair Facility"};
            default = 3;
            typeName = "SCALAR";
            force = 1;
    };

    class ace_repair_engineerSetting_fullRepair {
        title = "Who can perform a full repair?";
            ACE_setting = 1;
            values[] = {0,1,2};
            texts[] = {"Anybody","Engineers","Repair Specialists"};
            default = 1;
            typeName = "SCALAR";
            force = 1;
    };

    class ace_advanced_fatigue_enabled {
        title = "Advanced Fatigue";
            ACE_setting = 1;
            values[] = {0,1};
            texts[] = {"Off","On"};
            default = 0;
            typeName = "BOOL";
            force = 1;
    };



    class ace_explosives_explodeOnDefuse {
        title = "Explosives explode on defusal?";
            ACE_setting = 1;
            values[] = {0,1};
            texts[] = {"Off","On"};
            default = 0;
            typeName = "BOOL";
            force = 1;
    };

    class ace_advanced_ballistics_enabled {
        title = "Advanced ballistics?";
            ACE_setting = 1;
            values[] = {0,1};
            texts[] = {"Off","On"};
            default = 1;
            typeName = "BOOL";
            force = 1;
    };

    class ace_map_mapIllumination {
        title = "Map Illumination";
        ACE_setting = 1;
        values[] = {0,1};
        texts[] = {"Deactivated","Activated"};
        default = 0;
        typeName = "BOOL";
        force = 1;
    };
