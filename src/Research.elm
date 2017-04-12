module Research exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)


-- MODEL


type alias Model =
    Int


defaultModel : Model
defaultModel =
    0



-- UPDATE


type Msg
    = LALGinarView



--| Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] [ h3 [] [ text "Topics" ] ]
        , div [] [ h3 [] [ text "Projects" ] ]
        , div [] [ h3 [] [ text "Collaboration" ] ]
        , div [] [ text "For our active discussion, please check the webpage of laboratory seminars, a.k.a. ", button [ onClick LALGinarView ] [ text "LALGinars" ] ]
        ]
