class AS {

    class server {
        FNC_BASE(startNewGame);

        FNC(orgPlayers,setCommander);
        FNC(orgPlayers,chooseCommander);

        FNC_BASE(cleanGarbage);

        FNC_BASE(abandonFIALocation);
        FNC_BASE(renameFIAcamp);
        FNC_BASE(changeSecondsforAAFattack);
        FNC_BASE(changeForeignSupport);
        FNC_BASE(changeAAFmoney);
        FNC_BASE(changeFIAmoney);
        FNC_BASE(changeCitySupport);

        FNC_BASE(resourcesToggle);
        FNC_BASE(resourcesUpdate);

        FNC_BASE(respawnPetros);
        FNC_BASE(initPetros);
        FNC_BASE(rearmPetros);
        FNC_BASE(petrosDeath);
        FNC_BASE(initPlayer);
        FNC_BASE(HQbuild);
        FNC_BASE(HQforceBuild);
        FNC_BASE(HQdeploy);
        FNC_BASE(HQmove);
        FNC_BASE(HQplace);
        FNC_BASE(HQaddObject);
        FNC_BASE(HQdeployPad);
        FNC_BASE(HQdeletePad);

        FNC_BASE(buildCamp);
        FNC_BASE(buildRoadBlock);
        FNC_BASE(buildWatchpost);

        FNC_BASE(addMinefield);
        FNC_BASE(changePersistentVehicles);
        FNC_BASE(deployAAFminefield);

        FNC(fia_recruitment,recruitFIAunit);


        FNC(arsenal,pollServerArsenal);
        FNC_BASE(refreshArsenal);
        FNC_BASE(resetPetrosPosition);

        FNC_BASE(spendAAFmoney);
        FNC_BASE(updateAll);
        FNC_BASE(revealFromAAFRadio);
        FNC_BASE(globalMessage);
        FNC_BASE(eventCheck);

        FNC_BASE(win_location);
        FNC_BASE(lose_location);
        FNC_BASE(destroy_location);

        FNC_BASE(recomputePowerGrid);

        FNC_BASE(onPlayerDisconnect);

        FNC_BASE(showInGarageInfo);
    };

    class common {
        FNC_BASE(isAdmin);

        FNC_BASE(codeToString);
        FNC_BASE(uniqueID);

        FNC_BASE(setDefaultSkill);
        FNC_BASE(lockVehicle);
        FNC_BASE(hasRadio);
        FNC_BASE(location_isPowered);

        FNC_BASE(antennaKilledEH);
        FNC_BASE(shuffle);

        FNC_BASE(getSide);
        FNC_BASE(setSide);
        FNC_BASE(getFaction);
        FNC_BASE(getFactionSide);
        FNC_BASE(getEntity);
        FNC_BASE(getAllUnits);

        FNC_BASE(getCost);
        FNC_BASE(getAAFresourcesAdj);

        FNC_BASE(pickGroup);
        FNC_BASE(updateProgressBar);

        FNC_BASE(useCSAT);
        FNC_BASE(NATOinvolved);

        FNC_BASE(spawnComposition);
        FNC_BASE(findSpawnSpots);
        FNC_BASE(roadAndDir);
        FNC_BASE(spawnAAF_patrol);
        FNC_BASE(spawnAAF_patrolSquad);
        FNC_BASE(spawnVehiclePatrol);
        FNC_BASE(spawnAAF_roadAT);
        FNC_BASE(spawnAAF_truck);
        FNC_BASE(spawnAAF_AA);
        FNC_BASE(spawnAAF_support);
        FNC_BASE(createVehicle);
        FNC_BASE(createEmptyVehicle);
        FNC_BASE(safeDelete);
        FNC_BASE(vehicleAvailability);

        FNC(Scripts,spawnAttackWaves);

        FNC_BASE(AAFattackScore);
        FNC_BASE(wait_or_fail);
        FNC_BASE(deployFIAminefield);

        FNC_BASE(canFight);
        FNC_BASE(detected);

        // auxiliars to missions
        FNC_BASE(oneStepMission);
        FNC_BASE(cleanResources);
        FNC_BASE(cleanMissionResources);

        // auxiliars to FIArecruitment
        FNC(fia_recruitment,spawnFIAUnit);
        FNC(fia_recruitment,spawnFIASquad);
        FNC(fia_recruitment,getFIASquadName);
        FNC(fia_recruitment,getFIAUnitType);
        FNC(fia_recruitment,getFIAUnitClass);
        FNC(fia_recruitment,getFIASquadCost);
        FNC(fia_recruitment,getFIABestSquadVehicle);


        FNC_BASE(spawnAAFairAttack);
        FNC_BASE(spawnAAFlandAttack);
        FNC_BASE(spawnCSATattack);
        FNC_BASE(spawnCSATuav);
        FNC_BASE(spawnJournalist);
        FNC_BASE(spawnMortar);
        FNC_BASE(spawnDog);
        FNC_BASE(isDog);

        FNC_BASE(EH_AAFKilled);
        FNC_BASE(EH_CSATKilled);
        FNC_BASE(EH_AAFVehicleKilled);
        FNC_BASE(EH_CSATVehicleKilled);
        FNC_BASE(EH_VehicleHit);
        FNC_BASE(getContactThreat);
        FNC_BASE(getLandThreat);
        FNC_BASE(getAirThreat);
        FNC_BASE(callArtillerySupport);
        FNC_BASE(EH_KeyDown);
        FNC_BASE(unitsAtDistance);
        FNC_BASE(getLocationName);
        FNC_BASE(activateUndercover);
        FNC_BASE(toggleVehicleDoors);
        FNC_BASE(activateMortarCrewOnTruck);
        FNC_BASE(getSafeRoadToUnload);
        FNC_BASE(putVehicleInGarage);
        FNC_BASE(accessGarage);

        FNC_BASE(availableSeats);
        FNC_BASE(otherTurrets);
        FNC_BASE(createGroup);
        FNC_BASE(createVehicleGroup);
        FNC_BASE(groupCfgToComposition);

        FNC_BASE(EH_handleDamage);
        FNC_BASE(EH_handleDamageACE);

        FNC(AI,activateUndercoverAI);

        FNC_BASE(location_canBeDestroyed);
        FNC_BASE(location_name);
        FNC_BASE(getGarrisonAsText);
        FNC_BASE(getFIAvehiclePrice);
        FNC_BASE(location_isFrontline);
        FNC_BASE(getCitiesToCivPatrol);
        FNC_BASE(penalizePlayer);
        FNC_BASE(enemiesNearby);
        FNC_BASE(friendlyNearby);
        FNC_BASE(activateCleanup);
        FNC_BASE(activateVehicleCleanup);
        FNC_BASE(activateMissionVehicleCleanup);
        FNC_BASE(sendAwayFromBlufor);
        FNC_BASE(localCommunication);
        FNC_BASE(hasRadioCoverage);
        FNC_BASE(sellVehicle);
        FNC_BASE(skipTime);
        FNC_BASE(showFoundIntel);

        FNC_BASE(populateMilBuildings);
        FNC_BASE(createFIAgarrison);
        FNC_BASE(garrisonRelease);

        FNC_BASE(getBasesForCA);
        FNC_BASE(getBasesForConvoy);
        FNC_BASE(getAirportsForCA);

        FNC_BASE(setConvoyImmune);
        FNC_BASE(activateAirstrike);
        FNC_BASE(dropArtilleryShells);
        FNC_BASE(dropArtilleryShellsNATO);
        FNC_BASE(changeStreetLights);
        FNC_BASE(getFlagTexture);

        FNC(arsenal,removeUnlocked);
        FNC(arsenal,getArsenal);
        FNC(arsenal,setArsenal);
        FNC(arsenal,checkArsenal);
        FNC(arsenal,openArsenal);
        FNC(arsenal,buyGear);
        FNC(arsenal,listUniqueEquipment);
        FNC(arsenal,getWeaponItemsCargo);
        FNC(arsenal,getBestEquipment);
        FNC(arsenal,equipUnit);
        FNC(arsenal,getUnitArsenal);
        FNC(arsenal,getBoxArsenal);
        FNC(arsenal,getBestItem);
        FNC(arsenal,getBestWeapon);
        FNC(arsenal,getBestMagazines);
        FNC(arsenal,listToCargoList);
        FNC(arsenal,mergeCargoLists);
        FNC(arsenal,createCargoLists);
        FNC(arsenal,addToArsenal);
        FNC(arsenal,removeFromArsenal);
        FNC(arsenal,populateBox);
        FNC(arsenal,getTotalCargo);
        FNC(arsenal,emptyUnit);
        FNC(arsenal,equipDefault);
        FNC(arsenal,transferToBox);
        FNC(arsenal,fillCrateNATO);
        FNC(arsenal,fillCrateAAF);
        FNC(arsenal,emptyCrate);
        FNC(arsenal,removeNightEquipment);
        FNC(arsenal,unlockedCargoList);
        FNC(arsenal,addMagazineRemains);
        FNC(arsenal,showUnlocked);
        FNC(arsenal,collectDroppedEquipment);
        FNC(arsenal,excludeBlanks);

        FNC_BASE(initPlayerPosition);
        FNC_BASE(initVehicle);
        FNC_BASE(initVehicleCiv);
        FNC_BASE(initUnit);
        FNC_BASE(initUnitFIA);
        FNC_BASE(initUnitAAF);
        FNC_BASE(initUnitCIV);
        FNC_BASE(initUnitNATO);
        FNC_BASE(initUnitCSAT);
        FNC_BASE(initUnitSurvivor);

        FNC_BASE(FIAstoryTags);
        FNC_BASE(AAFstoryTags);
        FNC_BASE(CSATstoryTags);
        FNC_BASE(NATOstoryTags);
    };

    class withInterface {
        FNC_BASE(selectNewHQ);

        FNC_BASE(activatePlayerRankLoop);
        FNC_BASE(showProgressBar);
        FNC_BASE(respawnPlayer);
        FNC_BASE(spawnPlayer);
        FNC_BASE(fastTravel);
        FNC_BASE(unlockVehicle);
        FNC_BASE(revealToPlayer);

        FNC(actions,addAction);

        FNC(arsenal,countArsenal);
        FNC(arsenal,getCargoAsText);

        FNC_BASE(displayCargo_hint);

        FNC(ai_control,controlsAI);
        FNC(ai_control,setAIControl);
        FNC(ai_control,dropAIcontrol);
        FNC(ai_control,safeDropAIcontrol);
        FNC(ai_control,completeDropAIcontrol);
        FNC(ai_control,controlUnit);
        FNC(ai_control,controlHCSquad);
        FNC_UI(ai_control,controlUnit);
        FNC(ai_control,EH_handleDamage_AIcontrol);

        FNC_BASE(addFIAlocation);
        FNC(fia_recruitment,recruitFIAgarrison);
        FNC(fia_recruitment,recruitFIAsquad);
        FNC(fia_recruitment,dismissFIAsquad);
        FNC(fia_recruitment,dismissFIAsquads);
        FNC(fia_recruitment,dismissFIAunits);
        FNC(fia_recruitment,dismissFIAgarrison);
        FNC(fia_recruitment,buyFIAvehicle);
        FNC(fia_recruitment,buyFIAskill);
        FNC(fia_recruitment,addSquadVehicle);
        FNC_UI(fia_recruitment,dismissSelected);

        FNC_UI(dialogs,squadVehicleStatus);
        FNC_UI(dialogs,squadVehicleDismount);

        FNC_UI(dialogs,donateMoney);
        FNC_UI(dialogs,changePersistent);
        FNC_UI(dialogs,toggleElegibility);
        FNC_UI(dialogs,showTopBar);

        FNC_UI(dialogs,natoAirstrike);

        #include "dialogs\buyVehicle\cfgFunctions.hpp"
        #include "dialogs\manageLocations\cfgFunctions.hpp"
        #include "dialogs\manageMissions\cfgFunctions.hpp"
        #include "dialogs\manageGarrisons\cfgFunctions.hpp"
        #include "dialogs\manageTraits\cfgFunctions.hpp"
        #include "dialogs\manageHQ\cfgFunctions.hpp"
        #include "dialogs\manageNATO\cfgFunctions.hpp"
        #include "dialogs\recruitUnit\cfgFunctions.hpp"
        #include "dialogs\recruitSquad\cfgFunctions.hpp"
        #include "dialogs\newGame\cfgFunctions.hpp"
        #include "dialogs\startMenu\cfgFunctions.hpp"
        #include "dialogs\loadMenu\cfgFunctions.hpp"
        #include "dialogs\saveMenu\cfgFunctions.hpp"
    };
};

class AS_AI {

    class common {
        FNC(AI,activateSmokeCoverAI);
        FNC(AI,smokeCover);
        FNC(AI,autoRearm);
        FNC(AI,toggleAutocombat);
        FNC(AI,activateUnloadUnderSmoke);
        FNC(AI,surrender);
        FNC(AI,dismountOnDanger);
        FNC(ai,autoCombatCallON);
        FNC(ai,autoCombatCallOFF);
        FNC(ai,rearmCall);
        FNC(ai,dangerOnApproach);
        FNC(AI,setOrders);
        FNC(AI,adjustThreatModifier);

    };

};

class AS_tactics {
    class common {
        FNC(tactics,heli_disembark);
        FNC(tactics,heli_paradrop);
        FNC(tactics,heli_fastrope);
        FNC(tactics,heli_attack);
        FNC(tactics,ground_disembark);
        FNC(tactics,ground_attack);
        FNC(tactics,ground_combined);
        FNC(tactics,crew_sentry);
    };
};
