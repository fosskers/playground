package tutorial.webapp

import scala.scalajs.js.JSApp

import org.scalajs.jquery.jQuery

// --- //

object App extends JSApp {
  def main(): Unit = {
    jQuery(setupUI _)
  }

  def setupUI(): Unit = {
    jQuery("body").append("<p>This is ScalaJS!</p>")
    jQuery("""<button type="button">Click me!</button>""")
      .click(addClickedMessage _)
      .appendTo(jQuery("body"))
  }

  def addClickedMessage(): Unit = {
    jQuery("body").append("<p>You clicked the button!</p>")
  }
}
