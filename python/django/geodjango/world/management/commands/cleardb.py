##
# cleardb.py
# author:   Colin Woodbury
# created:  2015 March 23 @ 22:36
# modified:
#
# Implements the `cleardb` management command.
##

from django.core.management.base import BaseCommand
from world.models import Trip

# --- #


class Command(BaseCommand):
    help = 'Clear the PostgreSQL DB of all Trips.'

    def handle(self, *args, **options):
        self.stdout.write(
            "Clearing {} entries from Trip table".format(Trip.objects.count())
        )
        Trip.objects.all().delete()
        self.stdout.write("DB cleared.")
