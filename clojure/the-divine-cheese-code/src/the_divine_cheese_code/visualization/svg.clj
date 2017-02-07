(ns the-divine-cheese-code.visualization.svg
  (:require [clojure.string :as s]))

(defn comparator-over-maps
  [comparison-fn ks]
  (fn [maps]
    (zipmap ks
            (map (fn [k] (apply comparison-fn (map k maps)))
                 ks))))

(def map-min (comparator-over-maps clojure.core/min [:lat :lng]))
(def map-max (comparator-over-maps clojure.core/max [:lat :lng]))

(defn translate-to-origin
  [locations]
  (let [mincoords (map-min locations)]
    (map #(merge-with - % mincoords) locations)))

(defn scale
  [width height locations]
  (let [maxcoords (map-max locations)
        ratio {:lat (/ height (:lat maxcoords))
               :lng (/ width (:lng maxcoords))}]
    (map #(merge-with * % ratio) locations)))

(defn latlng->point
  "Convert lat/lng map to comma-separated string."
  [latlng]
  (str (:lat latlng) "," (:lng latlng)))

(defn points
  [locations]
  (s/join " " (map latlng->point locations)))

(defn line
  [points]
  (str "<polyline points=\"" points "\" />"))

(defn transform
  "Chain other functions."
  [width height locations]
  (->> locations
       translate-to-origin
       (scale width height)))

(defn xml
  "svg template which also flips the coordinate system."
  [width height locations]
  (str "<svg height=\"" height "\" width=\"" width "\">"
       "<g transform=\"translate(0," height ")\">"
       "<g transform=\"rotate(-90)\">"
       (-> (transform width height locations)
           points
           line)
       "</g></g>"
       "</svg>"))
