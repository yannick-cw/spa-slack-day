module Main exposing (..)

import Html exposing (div, Html, text, button)
import Html.Events exposing (onClick)
import Navigation exposing (Location, newUrl)
import Routing exposing (Route(..), parseLocation, routeToString)


type alias Model =
    Route


type Msg
    = OnLocationChange Location
    | GoToRoute Route


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


view : Model -> Html Msg
view m =
    div [] [ header, selectRouteView m ]


header : Html Msg
header =
    div [] [ button [ onClick (GoToRoute Starred) ] [ text "Starred" ] ]


selectRouteView : Model -> Html msg
selectRouteView m =
    case m of
        Home ->
            homeView

        NotFoundRoute ->
            notFoundView

        Starred ->
            starredView


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
    case msg of
        GoToRoute r ->
            ( model, newUrl ("#" ++ (routeToString r)) )

        OnLocationChange l ->
            init l


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            parseLocation location
    in
        ( currentRoute, Cmd.none )
