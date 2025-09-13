#charset "us-ascii"
//
// actionBuffer.t
//
#include <adv3.h>
#include <en_us.h>

#include "actionBuffer.h"

// Module ID for the library
actionBufferModuleID: ModuleID {
        name = 'Action Buffer Library'
        byline = 'Diegesis & Mimesis'
        version = '1.0'
        listingOrder = 99
}

function gLastLocation(actor) {
	local l;

	actor = (actor ? actor : gActor);
	if((l = actor.getMovementBuffer()) == nil)
		return(nil);
	if(l.length < 2)
		return(nil);
	return(l[l.length - 1]);
}


modify Actor
	bufferMovement = nil		// flag; only buffer when true
	movementBufferLength = 3	// moves to buffer

	_movementBuffer = nil		// the buffer, a Vector

	getMovementBuffer() { return(_movementBuffer ? _movementBuffer : []); }

	afterAction() {
		inherited();
		_bufferMovement();
	}

	getPreviousLocation() {
		local l;

		if((l = getMovementBuffer()) == nil)
			return(nil);
		if(l.length < 2)
			return(nil);
		return(l[l.length - 1]);
	}

	_bufferMovement() {
		// Create the buffer if it doesn't exist.
		if(_movementBuffer == nil)
			_movementBuffer = new Vector();

		// If we haven't moved, we don't record the location.
		if((_movementBuffer.length > 1)
			&& _movementBuffer[_movementBuffer.length] == location)
			return;

		// Add our current location to the buffer.
		_movementBuffer.append(location);

		// If the buffer contains more elements than we're
		// saving remove elements until it's the right size.
		// This SHOULD only have to remove a single element unless
		// something else is fiddling with the buffer.
		while(_movementBuffer.length > movementBufferLength)
			_movementBuffer.removeElementAt(1);
	}

	// Debugging method.
	logMovementBuffer() {
#ifdef __DEBUG
		if(_movementBuffer == nil) {
			defaultReport('No movement buffer.');
			return;
		}
		"Movement buffer:\n ";
		_movementBuffer.forEach({ x:
			"\n\t<<x.name>>\n "
		});
#endif // __DEBUG
	}
;

DefineSystemAction(DebugBuffer)
	execSystemAction() {
		//gActor.logMovementBuffer();
		local rm;

		if((rm = gLastLocation(nil)) == nil) {
			defaultReport('No last location. ');
			exit;
		}
		defaultReport('Last locaiton was <<rm.roomName>>. ');
	}
;
VerbRule(DebugBuffer) 'debugbuffer': DebugBufferAction
	verbPhrase = 'debugBuffer/debugBuffering';
