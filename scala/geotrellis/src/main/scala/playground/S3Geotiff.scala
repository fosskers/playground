package playground

import geotrellis.proj4.ConusAlbers
import geotrellis.raster.Tile
import geotrellis.spark._
import geotrellis.spark.io.s3.S3GeoTiffRDD
import geotrellis.spark.pyramid.Pyramid
import geotrellis.spark.tiling.ZoomedLayoutScheme
import geotrellis.vector.ProjectedExtent
import org.apache.spark.SparkContext
import org.apache.spark.rdd.RDD

// --- //

object S3Geotiff {
  def layerFromS3(bucket: String, key: String)(implicit sc: SparkContext): (Int, TileLayerRDD[SpatialKey]) = {
    /* Extract Tiles efficiently from a remote GeoTiff. */
    val ungridded: RDD[(ProjectedExtent, Tile)] =
      S3GeoTiffRDD.spatial(bucket, key)

    /* It was in WebMercator, say. We want it in ConusAlbers. */
    val reprojected: RDD[(ProjectedExtent, Tile)] =
      ungridded.reproject(ConusAlbers)

    /* Our layer will need metadata. Luckily, this can be derived mostly for free. */
    val (zoom, meta): (Int, TileLayerMetadata[SpatialKey]) =
      TileLayerMetadata.fromRdd(reprojected, ZoomedLayoutScheme(ConusAlbers))

    /* Recut our Tiles to form a proper gridded "layer". */
    val gridded: RDD[(SpatialKey, Tile)] = reprojected.tileToLayout(meta)

    (zoom, ContextRDD(gridded, meta))
  }

  def pyramid(bucket: String, key: String)(implicit sc: SparkContext): Stream[(Int, TileLayerRDD[SpatialKey])] = {
    val (zoom, layer) = layerFromS3(bucket, key)

    /* Why do I have to repeat the LayoutScheme? Shouldn't that be inferrable? */
    Pyramid.levelStream(layer, ZoomedLayoutScheme(ConusAlbers), zoom)
  }
}
