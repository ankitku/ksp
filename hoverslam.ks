CLEARSCREEN.
BRAKES OFF.
GEAR OFF.
lock vv to SHIP:VERTICALSPEED.
lock ht to alt:radar.
set shipht to ht.

lock throttle to 1.
stage.

lock targetPitch to 90.
set targetDirection to 90.
lock steering to heading(targetDirection, targetPitch).


until apoapsis > 80000 {
  PRINT ROUND(SHIP:APOAPSIS,0) AT (0,16).
  PRINT vv AT (0,17).
  PRINT ship:availablethrust AT (0,18).
  PRINT ship:mass AT (0,19).
}

CLEARSCREEN.

set thrtl to 0.
lock throttle to thrtl.
lock avlblthrst to ship:availablethrust.

until vv < 0 {
PRINT "COASTING to 80000m" AT (0,16).
}

lock tacc to (avlblthrst/ship:mass - CONSTANT:g0).
lock slamdist to shipht + vv*vv/(2*tacc).
until ht < shipht+1 {

if ht < slamdist+1 {
  GEAR ON.
  RCS ON.
  BRAKES ON.
  set thrtl to 1.
}

if vv > -2 {
  set thrtl to 0.
}

PRINT "HOVERSLAM" AT (0,15).
PRINT ht AT (0,16).
PRINT ">" AT (20,16).
PRINT slamdist AT (25,16).
}

set thrtl to 0.
BRAKES OFF.
CLEARSCREEN.
PRINT "LANDED" AT (0,16).
