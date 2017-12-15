name := """pg-geotrellis"""

version := "1.0.0"

scalaVersion in ThisBuild := "2.11.12"

resolvers += "locationtech-releases" at "https://repo.locationtech.org/content/repositories/releases/"

scalacOptions := Seq(
  "-deprecation",
  "-Ypartial-unification",
  "-Ywarn-value-discard",
  "-Ywarn-unused-import",
  "-Ywarn-dead-code",
  "-Ywarn-numeric-widen"
)

javaOptions ++= Seq("-Dsun.io.serialization.extendedDebugInfo=true")

fork in run := true

libraryDependencies ++= Seq(
  "org.locationtech.geotrellis" %% "geotrellis-spark"  % "1.2.0",
  "org.locationtech.geotrellis" %% "geotrellis-s3"     % "1.2.0",
  "org.apache.spark"            %% "spark-core"        % "2.2.0",
  "com.monovore"                %% "decline"           % "0.4.0-RC1",
  "com.monovore"                %% "decline-refined"   % "0.4.0-RC1",
  "org.typelevel"               %% "cats-core"         % "1.0.0-RC1"
)
