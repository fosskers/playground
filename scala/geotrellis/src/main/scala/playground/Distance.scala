package playground

import geotrellis.raster._
import geotrellis.raster.render._
import geotrellis.raster.render.ascii._
import geotrellis.vector.{ Extent, Point }

// --- //

object Distance {

  lazy val euclid: Tile = {
    val extent: RasterExtent = RasterExtent(Extent(0, 0, 250, 250), 250, 250)
    val ps0: Array[Point] = Array.range(50, 200).map(n => Point(n, n))
    val ps1: Array[Point] = Array.range(50, 200).map(n => Point(n, (-1 * n) + 250))

    (ps0 ++ ps1).euclideanDistanceTile(extent)
  }

  def work: Unit = {
    // println(euclid.renderAscii(AsciiArtEncoder.Palette.STIPLED))
    euclid.renderPng(ColorRamps.Plasma).write("foobar.png")
  }

}
