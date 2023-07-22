#include <amxmodx>
#include <hamsandwich>

#define MAX_PLAYERS 32

new g_ReactStartTime[MAX_PLAYERS+1]

public plugin_init()
{
    register_plugin("Reaction Time", "1.0", "Your Name")

    register_event("HLTV", "event_player_death", "ah", "1=delayed")

    register_event("HLTV", "event_player_kill", "ahh", "1=delayed")
}

public event_player_death(victim, inflictor, attacker)
{
    if (attacker > 0 && attacker <= get_maxplayers() && g_ReactStartTime[attacker] > 0)
    {
        new reactionTime = get_gametime() - g_ReactStartTime[attacker]
        client_print(attacker, print_console, "Your reaction time: %0.2f seconds", reactionTime)
        g_ReactStartTime[attacker] = 0
    }

    return PLUGIN_CONTINUE
}

public event_player_kill(killer, victim, weapon)
{
    if (killer > 0 && killer <= get_maxplayers())
    {
        g_ReactStartTime[killer] = get_gametime()
    }

    return PLUGIN_CONTINUE
}
