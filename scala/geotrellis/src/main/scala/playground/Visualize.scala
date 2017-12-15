package playground

import cats.implicits._
import com.monovore.decline._
import com.monovore.decline.refined._
import eu.timepit.refined.api.Refined
import eu.timepit.refined.auto._
import eu.timepit.refined.numeric.Positive
import geotrellis.raster._
import geotrellis.raster.io.geotiff._
import geotrellis.spark._
import geotrellis.spark.io._
import geotrellis.spark.io.kryo._
import geotrellis.spark.io.s3._
import org.apache.spark._
import org.apache.spark.serializer.KryoSerializer

/*
 run --bucket "rasterfoundry-staging-catalogs-us-east-1" --prefix "layers" --layer "e47d53d6-724c-4760-8fe3-07d85e8efc55" --zoom 4
 */

object Visualize extends CommandApp(

  name   = "layer-visualization",
  header = "Turn a GeoTrellis layer into a GeoTiff",
  main   = {

    /* Ensures that only positive, non-zero values can be given as arguments. */
    type UInt = Int Refined Positive

    val bucketO: Opts[String] = Opts.option[String]("bucket", help = "S3 bucket.")
    val prefixO: Opts[String] = Opts.option[String]("prefix", help = "Path to GeoTrellis layer catalog.")
    val layerO:  Opts[String] = Opts.option[String]("layer",  help = "Name of the layer.")
    val zoomO:   Opts[UInt]   = Opts.option[UInt]("zoom",     help = "Zoom level of the layer to stitch.")

    (bucketO, prefixO, layerO, zoomO).mapN { (bucket, prefix, layer, zoom) =>

      val conf = new SparkConf()
        .setIfMissing("spark.master", "local[*]")
        .setAppName("Ingest OSM")
        .set("spark.serializer", classOf[KryoSerializer].getName)
        .set("spark.kryo.registrator", classOf[KryoRegistrator].getName)

      implicit val sc = new SparkContext(conf)

      val reader = S3LayerReader(S3AttributeStore(bucket, prefix))

      val lid = LayerId(layer, zoom.value)

      val tiles: MultibandTileLayerRDD[SpatialKey] =
        reader.read[SpatialKey, MultibandTile, TileLayerMetadata[SpatialKey]](lid)

      val tile: Raster[MultibandTile] = tiles.stitch

      val geotiff: MultibandGeoTiff = MultibandGeoTiff(tile, tiles.metadata.crs)

      geotiff.write("tiffy.tiff")

      sc.stop()

    }
  }
)
