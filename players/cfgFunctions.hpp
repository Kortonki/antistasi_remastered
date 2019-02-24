#include "../hpp_macros.hpp"

class AS_players {
    class server {
        FNC(players,initialize);
        FNC(players,deinitialize);
        FNC(players,toDict);
        FNC(players,fromDict);

        FNC(players,change);
        FNC(players,set);
        FNC(players,shareMoney);
        FNC(players,incomeChart);
    };

    class common {
        FNC(players,get);
    };

    class withInterface {
        FNC(players,loadLocal);
    };
};
