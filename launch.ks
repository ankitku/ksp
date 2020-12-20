lock throttle to 1.
stage.

lock targetPitch to 90 - 1.03287 * alt:radar^0.409511.
set targetDirection to 90.
lock steering to heading(targetDirection, targetPitch).

set oldThrust to ship:avaiLablethrust.
until apoapsis > 100000 {
  PRINT ROUND(SHIP:APOAPSIS,0) AT (0,16).

  if ship:availablethrust < (oldThrust - 10) {
    stage.
    wait 1.
    set oldThrust to ship:availablethrust.
  }
}

lock throttle to 0.
lock steering to prograde.

wait until false.
