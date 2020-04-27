
    class ace_interaction_enableTeamManagement {
        title = "Enable Team Management";
            ACE_setting = 1;
            values[] = {0,1};
            texts[] = {"Off","On"};
            default = 1;
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
        default = 0;
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



    class ace_map_defaultChannel {
        title = "Map default channel";
            ACE_setting = 1;
            values[] = {0,5};
            texts[] = {"0","5"};
            default = 5;
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
            default = 0;
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
