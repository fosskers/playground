##
# populate.py
# author:   Colin Woodbury
# created:  2015 March 23 @ 22:12
# modified:
#
# Implements the `populate` management command.
##

from datetime import timedelta
from django.contrib.gis.geos import Point
from django.core.management.base import BaseCommand, CommandError
from django.utils import timezone
from itertools import imap
from random import uniform, randrange
from world.models import Trip
import time

# --- #


class Command(BaseCommand):
    args = '<num>'
    help = 'Populate the PostreSQL DB with <num> random Trips.'

    def handle(self, *args, **options):
        if not args:
            raise CommandError('No Trip quantity given.')
        else:
            self.populate(int(args[0]))

    def populate(self, num):
        """Populates the DB with `num` Trips."""
        print "Generating {} Trips".format(num)
        start = time.time()
        trips = imap(self.make_trip, xrange(0, num))
        Trip.objects.bulk_create(trips)
        end = time.time()
        self.stdout.write("[populate] finished in {:.3f} ms".format(
            1000 * (end - start)
        ))

    def make_trip(self, n):
        """Trips here are randomly generated as any two origin/destination
        Points within some area around Vancouver.
        Range of latitude values:    (-90, 90)  => South/North from Equator
        Range of longitutude values: (-180,180) => West/East from Greenwich

        Latitude range used here:  (45,55)
        Longitude range used here: (-130,-115)

        The `Point` class in GeoDjango orders its coordinates opposite of
        what is typical. The format is `Point(LONG,LAT)`.

        Possible improvements:
          1. Only accept Point values that actually exist on a land mass.

        Note: The `n` value passed here is to be ignored.
        """
        offset = randrange(1, 10)

        return Trip(
            origin=Point(uniform(-130.0, -115.0), uniform(45.0, 55.0)),
            destination=Point(uniform(-130.0, -115.0), uniform(45.0, 55.0)),
            departure_datetime=timezone.now() + timedelta(days=offset)
        )
