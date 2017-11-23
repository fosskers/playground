package playground

import geotrellis.raster._
import geotrellis.raster.render.ascii._
import geotrellis.raster.io.geotiff._

object Ascii {
  def draw: Unit = {
    val tiff = MultibandGeoTiff("tinychatta.tif")

    val tile: Tile = tiff.tile.bands.head

    println(tile.renderAscii(AsciiArtEncoder.Palette.STIPLED))
  }

  def rtdIndex: Unit = {
    val nd = NODATA

    val input = Array[Int](
      nd, 7, 1, 1,  3, 5, 9, 8, 2,
      9, 1, 1, 2,  2, 2, 4, 3, 5,
      3, 8, 1, 3,  3, 3, 1, 2, 2,
      2, 4, 7, 1, nd, 1, 8, 4, 3
    )

    val tile: Tile = IntArrayTile(input, 9, 4)

    println(tile.renderAscii(AsciiArtEncoder.Palette.STIPLED))
  }
}
