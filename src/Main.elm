module Main exposing (..)

import Html exposing (div, Html)
import Navigation exposing (Location)
import UrlParser exposing (..)


type alias Model =
    Route


type Msg
    = OnLocationChange Location


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


view : Model -> Html msg
view m =
    div [] []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            parseLocation location
    in
        ( currentRoute, Cmd.none )



-- routing


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
