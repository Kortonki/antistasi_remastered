class AS_movement {

    class server {
        FNC(movement,sendAAFroadPatrol);
        FNC(movement,sendAAFpatrol);
        FNC(movement,sendAAFattack);
        FNC(movement,sendAAFConvoy);
        FNC(movement,sendAAFRecon);
    };

    class common {
        FNC(movement,sendEnemyQRF);
        INIT_FNC(movement\spawns,AAFpatrol);
        INIT_FNC(movement\spawns,AAFroadPatrol);
    };
};
