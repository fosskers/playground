import akka.actor.{ ActorRef, ActorSystem, Props, Actor, Inbox }
import scala.concurrent.duration._

case object Greet
case class WhoToGreet(who: String)
case class Greeting(msg: String)

class Greeter extends Actor {
  var greeting = ""  // var? Gross.

  def receive = {
    case WhoToGreet(who) => greeting = s"Hello, $who!"
    case Greet           => sender ! Greeting(greeting)
  }
}

class GreetPrinter extends Actor {
  def receive = {
    case Greeting(msg) => println(msg)
  }
}

object HelloActor extends App {
  // The Actor supervisor
  val system = ActorSystem("helloactor")

  // The actual actor reference (?)
  val greeter = system.actorOf(Props[Greeter], "greeter")

  // A sandbox?
  val inbox = Inbox.create(system)

  greeter ! WhoToGreet("fosskers")

  inbox.send(greeter, Greet)

  val Greeting(msg1) = inbox.receive(5 seconds)
  println(s"Greeting: $msg1")

  // Send another message
  greeter.tell(WhoToGreet("Jack"), ActorRef.noSender)
  inbox.send(greeter, Greet)
  val Greeting(msg2) = inbox.receive(5 seconds)
  println(s"Greeting: $msg2")

  val greetPrinter = system.actorOf(Props[GreetPrinter])
  system.scheduler
    .schedule(0 seconds, 1 second, greeter, Greet)(system.dispatcher, greetPrinter)}
