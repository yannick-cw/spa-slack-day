module Main exposing (..)

import Html exposing (div, Html, text, button)
import Html.Events exposing (onClick)
import Navigation exposing (Location, newUrl)
import Routing exposing (Route(..), parseLocation)
import Task
import Process


type alias Model =
    { routes : Route, repos : List String, user : String, loadingIndicator : Bool }


type Msg
    = OnLocationChange Location
    | GoToRoute Route
    | GotStarred (List String)


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init (Model Home [] "" False)
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


view : Model -> Html Msg
view model =
    let
        loadingIndicator =
            if model.loadingIndicator then
                [ div [] [ text "Loading..." ] ]
            else
                []
    in
        div []
            ([ header
             , selectRouteView model
             ]
                ++ loadingIndicator
            )


header : Html Msg
header =
    div [] [ button [ onClick (GoToRoute (Starred "")) ] [ text "Starred" ] ]


selectRouteView : Model -> Html msg
selectRouteView m =
    case m.routes of
        Home ->
            homeView

        NotFoundRoute ->
            notFoundView

        Starred user ->
            starredView m.repos


homeView : Html msg
homeView =
    div [] [ text "Home" ]


starredView : List String -> Html msg
starredView repos =
    div [] ([ text "STAr" ] ++ (repos |> List.map (\repo -> div [] [ text repo ])))


notFoundView : Html msg
notFoundView =
    div [] [ text "Not Found" ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoToRoute (Starred user) ->
            ( { model | loadingIndicator = True }, mockedFetchUser user )

        GoToRoute r ->
            ( model, Cmd.none )

        OnLocationChange l ->
            init model l

        GotStarred repos ->
            ( { model | repos = repos, loadingIndicator = False }, newUrl ("#starred/" ++ model.user) )


mockedFetchUser : String -> Cmd Msg
mockedFetchUser userName =
    Task.perform (\_ -> GotStarred [ "repo1" ]) ((Process.sleep 1000) |> Task.andThen (always <| Task.succeed ""))


init : Model -> Location -> ( Model, Cmd Msg )
init model location =
    let
        currentRoute =
            parseLocation location
    in
        ( { model | routes = currentRoute }, Cmd.none )
