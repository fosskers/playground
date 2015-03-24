##
# findtrips.py
# author:   Colin Woodbury
# created:  2015 March 23 @ 22:29
# modified:
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
        # radius = float(args[0]) if args else 20
        # self.stdout.write("RADIUS: {} {}".format(radius, type(radius)))
        self.find_trip()  # self.find_trip(radius)

    def find_trip(self,
                  origin=Point(-123.6, 49.15),
                  destination=Point(-122.57, 50.7),
                  radius=50):
        """Find all 'relevant' Trips. A Trip is relevant if its origin is
        within `radius` kilometers of a user specified origin, and its
        destination is within `radius` kilometers of a user specified
        destination Point.

        Resulting list is sorted by Trip origin distance to requested origin.

        Defaults:
          origin:      Vancouver
          destination: Whistler
          radius:      20km search radius from both points
        """
        start = time.time()
        trips = sorted(
            Trip.objects
            .filter(origin__distance_lte=(origin, D(km=radius)))
            .filter(destination__distance_lte=(destination, D(km=radius))),
            key=lambda t: t.origin.distance(origin)
        )
        end = time.time()

        self.stdout.write(
            "{} Trip(s) found in {:.3f} ms. Here are the first 10.".format(
                len(trips), 1000 * (end - start))
        )

        for t in trips[:10]:
            self.stdout.write(unicode(t))
