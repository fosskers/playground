from django.contrib.gis.db import models

# --- #


class Trip(models.Model):
    """A simulated HitchPlanet trip."""
    origin = models.PointField(spatial_index=True,
                               srid=4326,
                               geography=True)
    destination = models.PointField(spatial_index=True,
                                    srid=4326,
                                    geography=True)
    departure_datetime = models.DateTimeField()
    objects = models.GeoManager()

    def __unicode__(self):
        return "From: ({:.2f},{:.2f}) to ({:.2f},{:.2f})".format(
            self.origin.coords[0], self.origin.coords[1],
            self.destination.coords[0], self.destination.coords[1])

    def distance(self):
        """The distance between origin and destination."""
        return self.origin.distance(self.destination)


class WorldBorder(models.Model):
    # --- Normal Django Fields --- #
    name = models.CharField(max_length=50)
    area = models.IntegerField()
    pop2005 = models.IntegerField('Population 2005')
    fips = models.CharField('FIPS Code', max_length=2)
    iso2 = models.CharField('2 Digit ISO', max_length=2)
    iso3 = models.CharField('3 Digit ISO', max_length=3)
    un = models.IntegerField('United Nations Code')
    region = models.IntegerField('Region Code')
    subregion = models.IntegerField('Sub-Region Code')
    lon = models.FloatField()
    lat = models.FloatField()

    # --- GeoDjango Fields --- #
    mpoly = models.MultiPolygonField()
    # Must override here to perform spacial queries!
    objects = models.GeoManager()

    def __unicode__(self):
        return self.name
