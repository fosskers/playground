package com.example

import diode.{ ActionHandler, Circuit, Effect, ModelRW }
import diode.react.ReactConnector
import org.scalajs.dom
import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global

// --- //

/* Model Tree */
//case class MsgDB(users: Seq[User])
//case class User(id: String, msgs: Seq[String])
case class DBRoot(db: MsgDB)
case class MsgDB(msgs: Seq[String], logSize: Int)

/* Actions */
case class Post(msg: String)
case class LogIt(msg: String)
case object Logged
//case class NewUser(user: String)

object ReactApp extends Circuit[DBRoot] with ReactConnector[DBRoot] {
  override def initialModel = DBRoot(MsgDB(Seq(), 0))

  // Boilerplate :(
  val dbL: ModelRW[DBRoot, MsgDB] = zoomRW(_.db)((m,v) => m.copy(db = v))
  val msgL: ModelRW[DBRoot, Seq[String]] = dbL.zoomRW(_.msgs)((m,v) => m.copy(msgs = v))
  val lsL: ModelRW[DBRoot, Int] = dbL.zoomRW(_.logSize)((m,v) => m.copy(logSize = v))

  val postH = new ActionHandler(msgL) {
    override def handle = {
      case Post(m) => updated(value :+ m, Effect.action(LogIt))
    }
  }

  val logH = new ActionHandler(lsL) {
    override def handle = {
      case LogIt(m) => effectOnly(logIt(m) >> logIt(m :+ '!'))
      case Logged => updated(value + 1)
    }
  }

  /* This is the main handler */
  override val actionHandler = composeHandlers(postH, logH)

  /* This could be any Future effect anywhere */
  def logIt(m: String) = Effect(Future {
    println(m)
    Logged
  })
}
