# amx-reaction-time
An AMX plugin that measures player reaction time

`g_ReactStartTime`: When enemy enters frame

`get_gametime`: Game time when first shot is fired

## spec
**Multiple enemies**: A timer for each enemy where each timer starts when each enemy enters player line of sight. Shooting while two enemies visible at the same time will result in reaction time based on when each enemy became visible.

**Shots on visible/non-visible**: If it's through a wall then no reaction time will be measured because no enemy is visible. If enemy is visible then go non-visible, timer will reset.

**Time to aim** vs **time to fire**:  The timer stops when the player fires, not when the cursor starts moving towards the enemy nor is on the enemy nor when enemy is killed. If the player takes longer to aim before firing then their reaction time is slower. It's separate from accuracy, a player can have fast reaction time but bad accuracy and vice versa.

## visual representation

#### fast:
![Fast](https://raw.githubusercontent.com/classicstrike/amx-reaction-time/main/fast.png)

#### slow:
![Slow](https://raw.githubusercontent.com/classicstrike/amx-reaction-time/main/slow.png)


## TODO
**Output**: Use .dem as input and then get list of shots fired as output, i.e.

| player        | enemy         | timestamp (enemy seen)  | reaction time (shot fired timestamp - enemy seen timestamp)  | weapon           |
| ------------- |:-------------:|:-----------------------:|:------------------------------------------------------------:|:----------------:|
| heaton        | sunman        | 32:10:000               | 0.2 (32:10:000-32:10:200)                                    | AK47             |
| heaton        | warden        | 32:15:000               | 0.1 (32:15:000-32:15:100)                                    | AK47             |
