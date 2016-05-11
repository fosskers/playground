package com.example

import org.scalajs.dom._
import scala.scalajs.js.JSApp

import diode.{Circuit, ActionHandler, Dispatcher, ModelR}
import scalatags.JsDom.all._

// --- //

/* The Model */
case class RootModel(cnt: Int)

/* Possible Actions */
case class Inc(amount: Int)
case class Dec(amount: Int)
case object Reset

/* The View */
class CounterView(counter: ModelR[_, Int], dispatch: Dispatcher) {
  def render = {
    div(
      h3("Counter"),
      p("Value = ", b(counter.value)),
      div(cls := "btn-group",
        button(onclick := { () => dispatch(Inc(2)) }, "Increase"),
        button(onclick := { () => dispatch(Dec(1)) }, "Decrease"),
        button(onclick := { () => dispatch(Reset) }, "Reset")
      )
    )
  }
}

/* The Circuit */
object AppCircuit extends Circuit[RootModel] {
  def initialModel = RootModel(0)

  val cntHandler = new ActionHandler(zoomRW(_.cnt)((m,v) => m.copy(cnt = v))) {
    override def handle = {
      case Inc(a) => updated(value + a)
      case Dec(a) => updated(value - a)
      case Reset => updated(0)
    }
  }

  override val actionHandler = composeHandlers(cntHandler)
}

object Hello extends JSApp {
  val counter = new CounterView(AppCircuit.zoom(_.cnt), AppCircuit)

  def render(root: Element) = {
    val e = div(
      h1("Diode example"),
      counter.render
    ).render
    root.innerHTML = ""
    root.appendChild(e)
  }

  def main(): Unit = {
    val root = document.getElementById("root")
    AppCircuit.subscribe(AppCircuit.zoom(identity))(_ => render(root))
    AppCircuit(Reset)
  }
}
