from django.contrib.gis.db import models

# --- #


class Trip(models.Model):
    """A simulated HitchPlanet trip."""
    origin = models.PointField()
    destination = models.PointField()
    departure_datetime = models.DateTimeField()

    def __unicode__(self):
        return "{:.3f}".format(self.distance())

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
