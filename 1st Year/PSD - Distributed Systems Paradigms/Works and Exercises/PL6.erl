-module(authentication).
-export([create_account/2,close_account/2,login/2,logout/1,online/0]).

% interface fuction

start() ->
    register(?MODULE, spawn(fun()->loop(#{}) end)).

rpc(Req)->
    ?MODULE ! {Req, self()},
    receive {Res,  ?MODULE}  -> Res end.

reply(To, Res) -> 
    To ! {Res, ?MODULE}.


create_account(Username, Passwd) ->
    rpc({create_account, Username, Passwd}).

close_account(Username, Passwd) -> % ok | invalid
    rpc({close_account, Username, Passwd}).

login(Username, Passwd) -> % ok | invalid
    rpc({login, Username, Passwd}).


logout(Username) -> % ok
    rpc({logout, Username}).


online() -> 
    rpc({online}). %[Utilizadores].


loop(Map)->
    receive {Rpc, From} ->
        case Rpc of
            {create_account, Username, Passwd} ->
                case maps:is_key(Username,Map) of
                    true -> 
                        reply(From, user_exists),
                        loop(Map);
                    false -> 
                        reply(From, ok),
                        loop(maps:put(Username,{Passwd, false},Map))
                end;
            {close_account, Username, Passwd} ->
                case maps:find(Username,Map) of
                    {ok, {Passwd, _ }} ->
                        reply(From, ok),
                        loop(maps:remove(Username,Map));
                    _ -> 
                        reply(From, invalid),
                        loop(Map)
                end;
            {login, Username, Passwd} ->
                case maps:find(Username,Map) of
                    {ok, {Passwd, false }} ->
                        reply(From, ok),
                        loop(maps:update(Username,{Passwd, true},Map));
                    _ -> 
                        reply(From, invalid),
                        loop(Map)
                end;
            {logout, Username} ->
                case maps:find(Username,Map) of
                    {ok, {Passwd, true }} ->
                        reply(From, ok),
                        loop(maps:update(Username,{Passwd, false},Map));
                    _ -> 
                        loop(Map)
                end;
            {online} ->
                reply (From, [U || {U, {_, 0}} <- maps:to_list(Map)]),
                loop(Map)
        end  
    end.