from django.contrib.gis import admin
from world.models import WorldBorder, Trip

# --- #


admin.site.register(WorldBorder, admin.GeoModelAdmin)
admin.site.register(Trip)
