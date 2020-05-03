class AS_stats {
    class server {
        FNC(stats,initialize);
        FNC(stats,deinitialize);
        FNC(stats,init);

        FNC(stats,fromDict);
        FNC(stats,toDict);
        FNC(stats,storeMessage);
    };

    class common {
      FNC(stats,get);
      FNC(stats,set);
      FNC(stats,change);
      FNC(stats,dictionary);
      FNC(stats,exists);
    };
};
