#charset "us-ascii"
//
// locationHistory.t
//
#include <adv3.h>
#include <en_us.h>

#include "locationHistory.h"

// Module ID for the library
locationHistoryModuleID: ModuleID {
        name = 'Location History Library'
        byline = 'Diegesis & Mimesis'
        version = '1.0'
        listingOrder = 99
}

locationHistoryInit: InitObject
	execute() {
		forEachInstance(Actor, function(x) {
			if(x.useLocationHistory == nil)
				return;
			x.rememberLocation();
		});
	}
;

modify Actor
	useLocationHistory = nil	// flag; only track when true
	locationHistoryLength = 3	// number of locations to keep

	_locationHistory = nil		// the history, a Vector

	// Returns the location history, or an empty list if there is none.
	getLocationHistory() {
		return(_locationHistory ? _locationHistory : []);
	}

	// Returns the location the actor was in before their current location.
	getPreviousLocation() {
		local l;

		if((l = getLocationHistory()) == nil)
			return(nil);
		if(l.length < 2)
			return(nil);
		return(l[l.length - 1]);
	}

	getMostRecentLocation() {
		local l;

		if((l = getLocationHistory()) == nil)
			return(nil);
		if(l.length < 1)
			return(nil);
		return(l[l.length]);
	}

	afterAction() {
		inherited();
		rememberLocation();
	}

	rememberLocation() {
		// Make sure we should remember the location.
		if((useLocationHistory == nil) || (location == nil))
			return;

		// Create the history vector if it doesn't exist.
		if(_locationHistory == nil)
			_locationHistory = new Vector();

		// If we haven't moved, we don't record the location.
		if(getMostRecentLocation() == location)
			return;

		// Add our current location to the history.
		_locationHistory.append(location);

		// If the history contains more elements than we're
		// saving remove elements until it's the right size.
		// This SHOULD only have to remove a single element unless
		// something else is fiddling with the history.
		while(_locationHistory.length > locationHistoryLength)
			_locationHistory.removeElementAt(1);
	}

	// Debugging method.
	logLocationHistory() {
#ifdef __DEBUG
		if(_locationHistory == nil) {
			defaultReport('No location history.');
			return;
		}
		"Location history:\n ";
		_locationHistory.forEach({ x:
			"\n\t<<x.name>>\n "
		});
#endif // __DEBUG
	}

#ifdef __DEBUG

DefineSystemAction(LHLast)
	execSystemAction() {
		local rm;

		if((rm = gActor.getPreviousLocation()) == nil) {
			defaultReport('No last location. ');
			exit;
		}
		defaultReport('Last locaiton was <<rm.roomName>>. ');
	}
;
VerbRule(LHLast) 'lhlast': LHLastAction
	verbPhrase = 'lhlast/lhlasting';

DefineSystemAction(LH)
	execSystemAction() {
		gActor.logLocationHistory();
	}
;
VerbRule(LH) 'lh': LHAction
	verbPhrase = 'lh/lhing';

#endif // __DEBUG
