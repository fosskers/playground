// This enables ScalaJS use
enablePlugins(ScalaJSPlugin)

// Use NodeJS
scalaJSUseRhino in Global := false

// To avoid manually launching the app in HTML
persistLauncher in Compile := true
persistLauncher in Test := false

name := """diode-full"""

version := "1.0"

scalaVersion := "2.11.8"

// Change this to another test framework if you prefer
libraryDependencies ++= Seq(
  //  "com.github.japgolly.scalajs-react" %%% "core" % "0.10.4",
  "com.github.japgolly.scalajs-react" %%% "extra" % "0.10.4",
  "org.scala-js" %%% "scalajs-dom" % "0.9.0",
  "me.chrons" %%% "diode" % "0.5.1",
  "me.chrons" %%% "diode-react" % "0.5.1"
)

jsDependencies ++= Seq(
  RuntimeDOM,

  "org.webjars.bower" % "react" % "15.0.1"
    /        "react-with-addons.js"
    minified "react-with-addons.min.js"
    commonJSName "React",

  "org.webjars.bower" % "react" % "15.0.1"
    /         "react-dom.js"
    minified  "react-dom.min.js"
    dependsOn "react-with-addons.js"
    commonJSName "ReactDOM"
)

// Uncomment to use Akka
//libraryDependencies += "com.typesafe.akka" %% "akka-actor" % "2.3.11"

