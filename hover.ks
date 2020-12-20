lock throttle to 1.
stage.

lock targetPitch to 90.
set targetDirection to 90.
lock steering to heading(targetDirection, targetPitch).

lock vert to SHIP:VERTICALSPEED.
lock ht to alt:radar.

until apoapsis > 100 {
  PRINT ROUND(SHIP:APOAPSIS,0) AT (0,16).
  PRINT vert AT (0,17).
  PRINT ship:availablethrust AT (0,18).
  PRINT ship:mass AT (0,19).
}

CLEARSCREEN.

PRINT "COASTING to 500m" AT (0,16).

set thrtl to 0.
lock throttle to thrtl.
lock avlblthrst to ship:availablethrust.

wait until vert < 0.
set hoverht to ht.
set c to 1.
set d to 1.
lock thrtl to ((ship:mass*CONSTANT:g0*c*d)/avlblthrst).
lock c to (1 - (ht - hoverht)/10).
lock d to (1 - vert/10).

CLEARSCREEN.
PRINT "HOVER" AT (0,15).
GEAR ON.

until false {
 PRINT thrtl AT (0,16).
 PRINT vert AT (0,17).
 PRINT ship:availablethrust AT (0,18).
 PRINT ship:mass AT (0,19).
}
 
