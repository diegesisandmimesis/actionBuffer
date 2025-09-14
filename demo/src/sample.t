#charset "us-ascii"
//
// sample.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the locationHistory library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f makefile.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

#include "locationHistory.h"

versionInfo: GameID;
gameMain: GameMainDef initialPlayerChar = me;

startRoom: Room 'Void'
	"This is a featureless void."
	north = northRoom
	south = southRoom
;
+me: Person useLocationHistory = true;

northRoom: Room 'North Room'
	"This is the north room. "
	south = startRoom
;

southRoom: Room 'South Room'
	"This is the south room. "
	north = startRoom
;
