// Burn Baby Burn

lock g to constant:G * body:mass / body:radius^2.

function calculateStartTime {
	 parameter mnv.
	 return time:seconds + mnv:eta - mnvBurnTime(mnv) / 2.
}

function mnvBurnTime {
	 parameter mnv.
	 local dV is mnv:deltaV:mag.
	 local isp is 0.

	 list engines in myEngines.
	 for en in myEngines {
	     if en:name <>  "TPdecoupler2m"
	        and en:name <>  "TPdecoupler3m"
		and en:name <>  "TPdecoupler1m"
		and en:ignition and not en:flameout {
	     	set isp to isp + (en:isp * (en:maxThrust / ship:maxThrust)).
	     }
	 }
	 
	 local mf is ship:mass / constant:e^(dV / (isp * g)).
	 local fuelFlow is ship:maxThrust / (isp * g).
	 local t is (ship:mass - mf) / fuelFlow.

	 return t.
}

function lockSteeringToMnvTarget {
	 parameter mnv.
	 set steering to mnv:burnvector.
}

function doBurn {
	 parameter burnStopTime.
	 print "Burn".
	 lock throttle to 1.

	 set oldThrust to ship:avaiLablethrust.
	 until time:seconds >  burnStopTime {
	 if ship:availablethrust < (oldThrust - 10) {
	    stage.
	    wait 1.
    	    set oldThrust to ship:availablethrust.
	    }
	 }
	 
	 endBurn().
}

function endBurn {
	 lock throttle to 0.
	 rcs off.
	 sas off.
}

function execMnv {
	 CLEARSCREEN.
	 rcs on.
	 sas off.
	 if hasnode {
	    set mnv to nextnode.
	 }
	 ELSE {
	     print "No maneuver provided".
	     return.
	 }
	 
	 local startBurnTime is calculateStartTime(mnv).
	 local burnTime is mnvBurnTime(mnv).
	 print "Awaiting Maneuver Burn".
	 
	 WAIT UNTIL time:seconds > startBurnTime - 30.
	 print "Acquiring Target".
	 
	 rcs on.
	 lockSteeringToMnvTarget(mnv).
	 
	 WAIT UNTIL time:seconds > startBurnTime.
	 
	 doBurn(startBurnTime + burnTime).
	 
	 print "Maneuver complete".
}

execMnv().

