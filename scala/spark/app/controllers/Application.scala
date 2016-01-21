/* This is a modified example from Spark's "Quick Start" guide,
 * changed to involve the Play framework
 */

package controllers

import javax.inject._
import org.apache.spark.SparkContext._
import play.api._
import play.api.mvc._

// --- //

class Application @Inject() (t: Text) extends Controller {

  def index = Action {
    val numAs = t.logData.filter(line => line.contains("a")).count()
    val numBs = t.logData.filter(line => line.contains("b")).count()

    Ok(s"Lines with a: ${numAs}, Lines with b: ${numBs}")
  }
}
