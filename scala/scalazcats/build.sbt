name := """scalazcats"""

version := "1.0"

scalaVersion := "2.11.8"

libraryDependencies ++= Seq(
  "org.scalaz"    %% "scalaz-core" % "7.2.10",
  "org.typelevel" %% "cats"        % "0.9.0"
)
