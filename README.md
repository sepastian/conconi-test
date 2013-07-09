Conconi Test
============

This script uses `aplay` to playback a WAV file in intervals to support performing a [conconi test](http://en.wikipedia.org/wiki/Conconi_test).

Usage
-----

Requires Ruby >=1.9.1.

    ruby concony.rb

Options
-------

The following options can be configured, see `ruby concony.rb --help`:

* start speed in km/h, default: 8
* end speed  in km/h, default: 30
* number of points to pass per lap, default: 10
* distance between any two points in meters, default: 20

Given these parameters, the script will calculate the itntervals at which to play a sound. A sound will be played when the test starts, thereafter, a sound will be played at each interval.

Dependencies
------------

Ruby and `aplay` are required to run this script. On Debian (Ubuntu), install both with

    sudo aptitude install alsa-utils ruby1.9.1-full
