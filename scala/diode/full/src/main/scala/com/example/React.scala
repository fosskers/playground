package com.example

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future
import scala.scalajs.js.JSApp

import diode.{ActionHandler, Circuit, Effect, ModelRW}
import diode.react.{ModelProxy, ReactConnector}
import japgolly.scalajs.react._
import japgolly.scalajs.react.vdom.prefix_<^._
import org.scalajs.dom

// --- //

/* Model Tree */
case class DBRoot(db: MsgDB)
case class MsgDB(msgs: Seq[String], logSize: Int)

/* Actions */
case class Post(msg: String)
case object Reset
case class LogIt(msg: String)
case object Logged

object ReactCircuit extends Circuit[DBRoot] with ReactConnector[DBRoot] {
  override def initialModel = DBRoot(MsgDB(Seq(), 0))

  // Boilerplate :(
  val dbL: ModelRW[DBRoot, MsgDB] = zoomRW(_.db)((m, v) => m.copy(db = v))
  val msgL: ModelRW[DBRoot, Seq[String]] = dbL.zoomRW(_.msgs)((m, v) => m.copy(msgs = v))
  val lsL: ModelRW[DBRoot, Int] = dbL.zoomRW(_.logSize)((m, v) => m.copy(logSize = v))

  val resetH = new ActionHandler(dbL) {
    override def handle = {
      case Reset => updated(MsgDB(Seq(), 0))
    }
  }

  val postH = new ActionHandler(msgL) {
    override def handle = {
      case Post(m) => {
        updated(value :+ m, Effect.action(LogIt(m)))
      }
    }
  }

  val logH = new ActionHandler(lsL) {
    override def handle = {
      case LogIt(m) => effectOnly(logIt(m))
      case Logged => updated(value + 1)
    }
  }

  /* This is the main handler */
  override val actionHandler = composeHandlers(resetH, postH, logH)

  /* This could be any Future effect anywhere */
  def logIt(m: String) = Effect(Future {
    println(m)
    Logged
  })
}

object ReactView {

  val top = ReactComponentB[ModelProxy[MsgDB]]("TopComponent").render_P({ proxy =>
    <.div(
      proxy.wrap({ db: MsgDB => db })(inputThing(_)),
      proxy.connect({ db: MsgDB => db })(page(_))
    )
  }).build

  val page = ReactComponentB[ModelProxy[MsgDB]]("MessageDisplay").render_P({ proxy =>
    <.div(
      proxy().logSize,
      proxy().msgs.map(m => <.div(m))
    )
  }).build

  val inputThing = ReactComponentB[ModelProxy[MsgDB]]("Input").render_P({ proxy =>
    <.div(
      <.input(
        ^.tpe := "input",
        ^.onChange ==> { e: ReactEventI => proxy.dispatch(Post(e.target.value)) }
      ),
      <.button(
        ^.onClick --> proxy.dispatch(Reset),
        "Reset"
      )
    )
  }).build
}

object ReactDiode extends JSApp {
  def main(): Unit = {
    ReactDOM.render(
      ReactCircuit.connect(_.db)(ReactView.top(_)),
      dom.document.getElementById("reactdiode")
    )
  }
}
