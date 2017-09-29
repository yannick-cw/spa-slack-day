module Routing exposing (Route(..), parseLocation)

import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = Home
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    map Home top


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
