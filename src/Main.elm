module Main exposing (..)

import Html exposing (div, Html, text)
import Navigation exposing (Location)
import Routing exposing (Route(..), parseLocation)


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
    case m of
        Home ->
            homeView

        NotFoundRoute ->
            notFoundView


homeView : Html msg
homeView =
    div [] [ text "Home" ]


starredView : Html msg
starredView =
    div [] [ text "STAr" ]


notFoundView : Html msg
notFoundView =
    div [] [ text "Not Found" ]


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
