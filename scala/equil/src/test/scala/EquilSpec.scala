import org.scalatest._
import equil.Equil._

// --- //

class EquilSpec extends FlatSpec with Matchers {
  val one: Stream[Int] = Stream(1, 7, -1, 3, -1, 2, 8, 1)
  val two: Stream[Int] = Stream(1, 10, -1, 0, -1, 2, 8, 1)
  val rob: Stream[Int] = Stream(1, 2, -3, 0, 5, -5)
  val exa: Stream[Int] = Stream(-7, 1, 5, 2, -4, 3, 0)

  "equilibriumIx" should "fail on an empty list" in {
    equilibriumIx(Stream()) should not be defined
  }

  it should "fail when there is no equilibrium point" in {
    equilibriumIx(Stream(1,2,3)) should not be defined
  }

  it should "succeed on a singleton" in {
    equilibriumIx(Stream(5)) shouldBe Some(0)
  }

  it should "succeed when there is one eq. point" in {
    equilibriumIx(one) shouldBe Some(5)
  }

  it should "succeed when there are two eq. points" in {
    equilibriumIx(two) shouldBe Some(3)
  }

  it should "succeed for Rob's example" in {
    equilibriumIx(rob) shouldBe Some(3)
  }

  it should "succeed for a random example from the net" in {
    equilibriumIx(exa) shouldBe Some(3)
  }

  "oneIter" should "fail on an empty list" in {
    oneIter(Array()) should not be defined
  }

  it should "succeed when there are two eq. points" in {
    oneIter(two.toArray) shouldBe Some(3)
  }

  it should "succeed on a singleton" in {
    oneIter(Array(5)) shouldBe Some(0)
  }

  it should "succeed when there is one eq. point" in {
    oneIter(one.toArray) shouldBe Some(5)
  }

  it should "succeed for Rob's example" in {
    oneIter(rob.toArray) shouldBe Some(3)
  }

  it should "succeed for a random example from the net" in {
    oneIter(exa.toArray) shouldBe Some(3)
  }

}
