##
# findtrips.py
# author:   Colin Woodbury
# created:  2015 March 23 @ 22:29
# modified: 2015 March 25 @ 11:32
#
# Implements the `findtrips` management command.
##

from django.contrib.gis.geos import Point
from django.contrib.gis.measure import D
from django.core.management.base import BaseCommand
from world.models import Trip
import time

# --- #


class Command(BaseCommand):
    args = '<radius>'
    help = 'Find relevant Trips.'

    def handle(self, *args, **options):
        # 2015 March 23 @ 22:50 - There is something wrong with this.
        # It's bailing with a type error. `int()` doesn't work either,
        # nor can it stay as a string.
        # radius = float(args[0]) if args else 50.0
        # self.stdout.write("RADIUS: {} {}".format(radius, type(radius)))
        self.find_trip()

    def find_trip(self,
                  origin=Point(-123.6, 49.15),
                  destination=Point(-122.57, 50.7),
                  radius=50.0):
        """Find all 'relevant' Trips. A Trip is relevant if its origin is
        within `radius` kilometers of a user specified origin, and its
        destination is within `radius` kilometers of a user specified
        destination Point.

        Resulting list is sorted by Trip origin distance to requested origin.

        Defaults:
          origin:      Vancouver
          destination: Whistler
          radius:      50km search radius from both points
        """
        start = time.time()
        trips = Trip.objects \
                    .filter(origin__dwithin=(origin, radius * 1000)) \
                    .filter(destination__dwithin=(destination, radius * 1000))

        #self.stdout.write("{}".format(trips.query))
        s_trips = sorted(trips, key=lambda t: t.origin.distance(origin))
        end = time.time()

        self.stdout.write(
            "{} Trip(s) found in {:.3f} ms (radius {}km).".format(
                len(trips), 1000 * (end - start), radius)
        )

        for t in s_trips[:10]:
            self.stdout.write(unicode(t))
