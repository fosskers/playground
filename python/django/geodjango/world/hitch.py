from datetime import timedelta
from django.contrib.gis.geos import Point
from django.contrib.gis.measure import D
from django.utils import timezone
from itertools import imap
from models import Trip
from random import uniform, randrange
import time

# --- #


def timing(f):
    """Time a function."""
    def wrap(*args, **kwargs):
        start = time.time()
        result = f(*args, **kwargs)
        end = time.time()
        print "Function `{}` finished in {:.3f} ms".format(
            f.func_name, 1000 * (end - start)
        )
        return result
    return wrap


@timing
def populate(num):
    """Populates the DB with `num` Trips."""
    print "Generating {} Trips".format(num)
    trips = imap(make_trip, xrange(0, num))
    Trip.objects.bulk_create(trips)


def make_trip(n):
    """Trips here are randomly generated as any two origin/destination Points
    on the Earth.
    Range of latitude values:    (-90, 90)  => South/North from Equator
    Range of longitutude values: (-180,180) => West/East from Greenwich

    The `Point` class in GeoDjango orders its coordinates opposite of
    what is typical. The format is `Point(LONG,LAT)`.

    Possible improvements:
      1. Only accept Point values that actually exist on a land mass.
      2. Only restrict Long/Lat ranges to some radius around Vancouver.

    Note: The `n` value passed here is to be ignored.
    """
    return Trip(
        origin=Point(uniform(-180.0, 180.0), uniform(-90.0, 90.0)),
        destination=Point(uniform(-180.0, 180.0), uniform(-90.0, 90.0)),
        departure_datetime=timezone.now() + timedelta(days=randrange(1, 10))
    )


@timing
def clear_db():
    """Clears Trip DB."""
    print "Clearing {} entries from Trip table".format(Trip.objects.count())
    Trip.objects.all().delete()
    print "DB cleared."


@timing
def find_trip(origin=Point(-123.6, 49.15),
              destination=Point(-122.57, 50.7),
              radius=20):
    """Find all 'relevant' Trips. A Trip is relevant if its origin is within
    `radius` kilometers of a user specified origin, and its destination is
    within `radius` kilometers of a user specified destination Point.

    Resulting list is sorted by Trip origin distance to requested origin.

    Defaults:
      origin:      Vancouver
      destination: Whistler
      radius:      20km search radius from both points
    """
    return sorted(
        Trip.objects
        .filter(origin__distance_lte=(origin, D(km=radius)))
        .filter(destination__distance_lte=(destination, D(km=radius))),
        key=lambda t: t.origin.distance(origin)
    )
