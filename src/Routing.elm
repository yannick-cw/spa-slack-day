module Routing exposing (Route(..), parseLocation, routeToString)

import Navigation exposing (Location)
import UrlParser exposing (map, top, Parser, parseHash, oneOf, s)


type Route
    = Home
    | Starred
    | NotFoundRoute


routeToString : Route -> String
routeToString =
    String.toLower << toString


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map Home top
        , map Starred (s (routeToString Starred))
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
