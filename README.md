# locationHistory

A TADS3/adv3 module providing a mechanism for tracking the locations occupied
by ``Actor``s.

The main implementation detail to be aware of is that the history is only
updated if the actor's ``.location`` changes and is non-``nil``.  If an
actor remains in the same location for multiple turns this will not cause
the history to fill up with multiple references to the same location.

## Description

## Table of Contents

[Getting Started](#getting-started)
* [Dependencies](#dependencies)
* [Installing](#install)
* [Compiling and Running Demos](#running)

[Classes](#classes)
* [Actor](#actor)

[Examples](#examples)

<a name="getting-started"/></a>
## Getting Started

<a name="dependencies"/></a>
### Dependencies

* TADS 3.1.3
* adv3 3.1.3

  These are the most recent versions of the TADS3 VM and adv3 library.

  Any TADS3 toolkit with these versions should work, although all of the
  [diegesisandmimesis](https://github.com/diegesisandmimesis) modules are
  primarily tested with [frobTADS](https://github.com/realnc/frobtads).

* git

  This module is distributed via github, so you'll need some way of
  cloning a git repo to obtain it.

  The process should be similar on any platform using any tools, but the
  command line examples given below were tested on an Ubuntu linux
  machine.  Other OSes and git tools will have a slightly different usage.

<a name="install"/></a>
### Installing

All of the [diegesisandmimesis](https://github.com/diegesisandmimesis) modules
are designed to be installed and used from a common base install directory.

In this example we'll use ``/home/username/tads`` as the base directory.

* Create the module base directory if it doesn't already exists:

  `mkdir -p /home/username/tads`

* Make it the current directory:

  ``cd /home/username/tads``

* Clone this repo:

  ``git clone https://github.com/diegesisandmimesis/locationHistory.git``

After the ``git`` command, the module source will be in
``/home/username/tads/locationHistory``.

<a name="running"/></a>
### Compiling and Running Demos

Once the repo has been cloned you should be able to ``cd`` into the
``./demo/`` subdirectory and compile the demonstration/test code that
comes with the module.

All the demos are structured in the expectation that they will be compiled
and run from the ``./demo/`` directory.  Again assuming that the module
is installed in ``/home/username/tads/locationHistory/``, enter the directory with:
```
# cd /home/username/tads/locationHistory/demo
```
Then make one of the demos, for example:
```
# make -a -f makefile.t3m
```
This should produce a bunch of output from the compiler but no errors.  When
it is done you can run the demo from the same directory with:
```
# frob games/game.t3
```
In general the name of the makefile and the name of the compiled story file
will be the same except for the extensions (``.t3m`` for makefiles and
``.t3`` for story files).

<a name="classes"/></a>
## Classes

<a name="actor"/></a>
### Actor

#### Properties

* ``useLocationHistory = nil``

  If boolean ``true`` the ``Actor``'s location history will be tracked.

  Default is ``nil``.

* ``locaitonHistoryLength = 3``

  Number of locations to remember.

  The current location is always the last element of the history, so with
  the defaut value of ``3`` this means the current and two prior
  locaitons will be remembered.

#### Methods

* ``getLocationHistory()``

  Returns a ``List`` containing the stored location history for this ``Actor``.

* ``getMostRecentLocation()``

  Returns the most recent location remembered for this ``Actor``.  In general
  this should be equivalent to ``Actor.location``.

* ``getPreviousLocation()``

  Returns the second most recent location remembered for this ``Actor``.  This
  is the location they were in prior to the current one.

* ``rememberLocation()``

  Method that stores the current location to the location history.

  **NOTE**:  This should not be called directly unless you want to change the
  default behavior of the module.  In normal operation it will already
  be called once per turn from within the ``Actor``'s ``afterAction()`` method.

<a name="examples"/></a>
## Examples

To enable location history tracking for a defined ``Actor`` named ``alice``:
```
    modify alice
        useLocationHistory = true
    ;
```

To return ``alice``'s location history:
```
    local hist = alice.getLocationHistory();
```
