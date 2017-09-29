module Routing exposing (Route(..), parseLocation)

import Navigation exposing (Location)
import UrlParser exposing (map, top, Parser, parseHash, oneOf, s, (</>), string)


type Route
    = Home
    | Starred String
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map Home top
        , map Starred (s "starred" </> string)
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
