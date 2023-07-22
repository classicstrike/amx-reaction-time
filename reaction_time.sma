#include < amxmodx > // Include the AMX Mod X module

// Constants
const Float:TIME_RESET = -1.0 // Represents an invalid timer value
const Float:TIMER_THRESHOLD = 1.0 // Minimum time threshold for reaction time measurement

// Variables
new g_PlayerTimers[33] // Array to store timers for each player (assuming max 32 players)
new g_PlayerAiming[33] // Array to store aiming status for each player
new g_PlayerVisible[33] // Array to store visibility status for each player

// Function to start/reset player reaction time timer
StartReactionTimeTimer(id)
{
    g_PlayerTimers[id] = get_gametime() // Store the current server time as the start time
    g_PlayerAiming[id] = true // Set aiming status to true (player aiming at an enemy)
    g_PlayerVisible[id] = true // Set visibility status to true (enemy visible)
}

// Function to stop player reaction time timer and calculate reaction time
StopReactionTimeTimer(id)
{
    if (g_PlayerTimers[id] > 0.0) // Check if the timer is valid
    {
        new reactionTime = get_gametime() - g_PlayerTimers[id] // Calculate reaction time
        if (reactionTime >= TIMER_THRESHOLD) // Check if reaction time is above the threshold
        {
            // Print or store the reaction time value (e.g., send it to the player or log it)
            client_print(id, print_chat, "Your reaction time: %.2f seconds", reactionTime)
        }
        g_PlayerTimers[id] = TIME_RESET // Reset the timer
        g_PlayerAiming[id] = false // Reset aiming status
        g_PlayerVisible[id] = false // Reset visibility status
    }
}

// Hook: Called when a player shoots
public client_cmd(command[], id)
{
    if (equal(command, "attack")) // Check if the player is firing
    {
        if (g_PlayerAiming[id]) // If the player was aiming at an enemy
        {
            StopReactionTimeTimer(id) // Stop the reaction time timer
        }
    }
}

// Hook: Called when a player sees an enemy
public client_prethink(id)
{
    new aimEntity = pev(id, pev_v_angle) // Get the player's view angles
    new aimVec[3], aimEnd[3], aimLineTrace // Vectors for aiming

    angleVectors(aimEntity, aimVec) // Get the aiming vector
    aimEnd = aimVec * 8192.0 + pev(id, pev_origin) // Calculate the end position of the aim line trace

    aimLineTrace = trace_line(pev(id, pev_origin), aimEnd, true, id) // Perform a line trace to check visibility

    if (aimLineTrace == 1) // Check if the line trace hit an entity (enemy)
    {
        if (!g_PlayerVisible[id]) // If the player was not previously visible
        {
            StartReactionTimeTimer(id) // Start/reset the reaction time timer
        }
        g_PlayerVisible[id] = true // Set visibility status to true (enemy visible)
    }
    else
    {
        g_PlayerVisible[id] = false // Set visibility status to false (enemy not visible)
    }
}
