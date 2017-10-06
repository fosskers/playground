package playground

import geotrellis.raster._
import geotrellis.spark._
import geotrellis.spark.SpatialKey._  /* To get a `Boundable` instance for `SpatialKey` */
import geotrellis.spark.tiling._
import geotrellis.vector._
import org.apache.spark._
import org.apache.spark.rdd._

// --- //

object TileToLayer {

  /** Convert an in-memory `Tile` into a GeoTrellis layer. */
  def tileToLayer(raster: ProjectedRaster[Tile])(implicit sc: SparkContext): TileLayerRDD[SpatialKey] = {

    val layer: RDD[(ProjectedExtent, Tile)] =
      sc.parallelize(List((ProjectedExtent(raster.raster.extent, raster.crs), raster.raster.tile)))

    val scheme: LayoutScheme = ZoomedLayoutScheme(raster.crs)

    /* The metadata, plus the zoom level corresponding to the size of the Tile.
     * We don't need the zoom level here, but it deserves a note.
     */
    val meta: (Int, TileLayerMetadata[SpatialKey]) = layer.collectMetadata(scheme)

    ContextRDD(layer.tileToLayout[SpatialKey](meta._2), meta._2)
  }

}
