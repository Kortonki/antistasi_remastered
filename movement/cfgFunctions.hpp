class AS_movement {

    class server {
        FNC(movement,sendAAFroadPatrol);
        FNC(movement,sendAAFpatrol);
        FNC(movement,sendEnemyQRF);
        FNC(movement,sendAAFattack);
        FNC(movement,sendAAFConvoy);
        FNC(movement,sendAAFRecon);
    };

    class common {
        INIT_FNC(movement\spawns,AAFpatrol);
        INIT_FNC(movement\spawns,AAFroadPatrol);
    };
};
