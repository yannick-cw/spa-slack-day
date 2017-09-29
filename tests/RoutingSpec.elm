module RoutingSpec exposing (..)

import Test exposing (..)
import Fuzz as F
import Routing exposing (..)
import Navigation exposing (Location)
import Expect as E


testLocation =
    { href = ""
    , host = ""
    , hostname = ""
    , protocol = ""
    , origin = ""
    , port_ = ""
    , pathname = ""
    , search = ""
    , hash = ""
    , username = ""
    , password = ""
    }


hashFuzzer : F.Fuzzer String
hashFuzzer =
    let
        unknownRoute hash =
            hash /= "" && hash /= "/"
    in
        F.string
            |> F.conditional { retries = 10, fallback = identity, condition = unknownRoute }
            |> F.map ((++) "#")


suite : Test
suite =
    describe "Routing"
        [ test "no hash leads to Home Page" <|
            \_ ->
                testLocation
                    |> parseLocation
                    |> E.equal Home
        , test "hash / leads to Home Page" <|
            \_ ->
                let
                    newLocation =
                        { testLocation | hash = "#/" }
                in
                    newLocation
                        |> parseLocation
                        |> E.equal Home
        , fuzz hashFuzzer "every unknown route leads to NotFound Page" <|
            \hash ->
                let
                    newLocation =
                        { testLocation | hash = hash }
                in
                    newLocation
                        |> parseLocation
                        |> E.equal NotFoundRoute
        ]
