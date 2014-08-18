import logic.logic._

object logicTest extends App {
  println(true and true)
  println(table2(_ && _))
  println(table2(_ --> _))
  println(table2((a: Boolean, b: Boolean) => a and (a or not(b))))
}
