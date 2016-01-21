/* This is a modified example from Spark's "Quick Start" guide,
 * changed to involve the Play framework
 */

package controllers

import javax.inject._
import org.apache.spark.SparkContext._
import org.apache.spark.mllib.recommendation.Rating
import play.api._
import play.api.mvc._

// --- //

class Application @Inject() (t: Text, c: Collab) extends Controller {

  def index = Action {
    val numAs = t.logData.filter(line => line.contains("a")).count()
    val numBs = t.logData.filter(line => line.contains("b")).count()

    Ok(s"Lines with a: ${numAs}, Lines with b: ${numBs}")
  }

  /* Evaluate the model on rating data */
  def collab = Action {
    val usersProducts = c.ratings.map { case Rating(user, product, rate) =>
      (user, product)
    }
    val predictions = c.model.predict(usersProducts)
      .map { case Rating(user, product, rate) =>
        ((user, product), rate)
    }

    val ratesAndPreds = c.ratings.map { case Rating(user, product, rate) =>
      ((user, product), rate)
    }.join(predictions)

    val MSE = ratesAndPreds.map { case ((user, product), (r1, r2)) =>
      val err = (r1 - r2)
      err * err
    }.mean()

    Ok(s"Mean Squared Error = ${MSE}")
  }
}
