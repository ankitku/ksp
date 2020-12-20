//First, we'll clear the terminal screen to make it look nice
CLEARSCREEN.

//Next, we'll lock our throttle to 100%.
LOCK THROTTLE TO 1.0.   // 1.0 is the max, 0.0 is idle.

//This is our countdown loop, which cycles from 5 to 0
PRINT "Counting down:".
FROM {local countdown is 5.} UNTIL countdown = 0 STEP {SET countdown to countdown - 1.} DO {
    PRINT "..." + countdown.
    WAIT 1. // pauses the script here for 1 second.
}

//This is a trigger that constantly checks to see if our thrust is zero.
//If it is, it will attempt to stage and then return to where the script
//left off. The PRESERVE keyword keeps the trigger active even after it
//has been triggered.
WHEN MAXTHRUST = 0 THEN {
    PRINT "Staging".
    STAGE.
    PRESERVE.//First, we'll clear the terminal screen to make it look nice
CLEARSCREEN.
}

//Next, we'll lock our throttle to 100%.
LOCK THROTTLE TO 1.0.   // 1.0 is the max, 0.0 is idle.

//This will be our main control loop for the ascent. It will
//cycle through continuously until our apoapsis is greater
//than 100km. Each cycle, it will check each of the IF
//statements inside and perform them if their conditions
//are met
SET TGT TO 100000.0.
SET MYSTEER TO HEADING(90,90).
LOCK STEERING TO MYSTEER. // from now on we'll be able to change steering by just assigning a new value to MYSTEER
UNTIL SHIP:APOAPSIS > TGT { //Remember, all altitudes will be in meters, not kilometers

    //For the initial ascent, we want our steering to be straight
    //up and rolled due east
    
    IF SHIP:VELOCITY:SURFACE:MAG >= 300 AND SHIP:VELOCITY:SURFACE:MAG < 400 {
        SET MYSTEER TO HEADING(90,60).
        PRINT "Pitching to 60 degrees" AT(0,15).
        PRINT ROUND(SHIP:APOAPSIS,0) AT (0,16).

    } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 400 AND SHIP:VELOCITY:SURFACE:MAG < 1000 {
        SET MYSTEER TO HEADING(90,50).
        PRINT "Pitching to 50 degrees" AT(0,15).
        PRINT ROUND(SHIP:APOAPSIS,0) AT (0,16).

    //Beyond 900m/s, we can keep facing towards 10 degrees above the horizon and wait
    //for the main loop to recognize that our apoapsis is above 100km
    } ELSE IF SHIP:VELOCITY:SURFACE:MAG >= 1000 {
        SET MYSTEER TO HEADING(90,10).
        PRINT "Pitching to 10 degrees" AT(0,15).
        PRINT ROUND(SHIP:APOAPSIS,0) AT (0,16).

    }.

}.

PRINT "100km apoapsis reached, cutting throttle".

//At this point, our apoapsis is above 100km and our main loop has ended. Next
//we'll make sure our throttle is zero and that we're pointed prograde
LOCK THROTTLE TO 0.

WAIT UNTIL SHIP:ALTITUDE > 0.99*SHIP:APOAPSIS.
SET TGT TO SHIP:APOAPSIS.

CLEARSCREEN.
SET MYSTEER TO HEADING(90,0).
PRINT "Pitching to 0 degrees" AT (0,15).
PRINT ROUND(SHIP:APOAPSIS,0) AT (0,16).
PRINT "TARGET PERIAPSIS :" AT (0,17).
PRINT TGT AT (0,18).

PRINT "STANDBY FOR ORBIT INJECTION BURN NEAR APOAPSIS" AT (0,17).

SET ORBIT_BURN_COMPLETE TO FALSE.

UNTIL SHIP:APOAPSIS - SHIP:PERIAPSIS < 100 {
WHEN SHIP:ALTITUDE > 0.99*SHIP:APOAPSIS AND NOT ORBIT_BURN_COMPLETE THEN {
    	 SET MYSTEER TO HEADING(90,-2).
         LOCK THROTTLE TO 1.
}.

WHEN SHIP:APOAPSIS - SHIP:PERIAPSIS < 100 THEN {
LOCK THROTTLE TO 0.
SET ORBIT_BURN_COMPLETE TO TRUE.
}.
}.

CLEARSCREEN.
STAGE.
PRINT "Reached Orbit" AT(0,15).
