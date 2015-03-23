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
    """Populates the DB with `num` Trips.
    Trips here are randomly generated as any two origin/destination Points
    on the Earth.
    Range of latitude values:    (-90, 90)  => South/North from Equator
    Range of longitutude values: (-180,180) => West/East from Greenwich

    Possible improvements:
      1. Only accept Point values that actually exist on a land mass.
      2. Only restrict Long/Lat ranges to some radius around Vancouver.
    """
    print "Generating {} Trips".format(num)
    trips = imap(make_trip, xrange(0, num))
    Trip.objects.bulk_create(trips)


def make_trip(n):
    """Randomly generate a Trip. Ignore `n`"""
    return Trip(
        origin=Point(uniform(-180.0, 180.0), uniform(-90.0, 90.0)),
        destination=Point(uniform(-180.0, 180.0), uniform(-90.0, 90.0)),
        departure_datetime=timezone.now() + timedelta(days=randrange(1, 10))
    )


def clear_db():
    """Clears Trip DB."""
    print "Clearing {} entries from Trip table".format(Trip.objects.count())
    Trip.objects.all().delete()
    print "DB cleared."


@timing
def find(point=Point(-123.6, 49.15), radius=20):
    """Find all Trips which originate within `radius` kilometers of
    some Point, which in practice would be the user's current position.

    Defaults:
      point:  Vancouver
      radius: 20km from `point`
    """
    return sorted(Trip.objects.filter(
        origin__distance_lte=(point, D(km=radius))
    ), key=lambda t: t.distance())
