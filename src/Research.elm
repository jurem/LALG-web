module Research exposing (..)

import Html exposing (..)


-- MODEL


type alias Model =
    Int


defaultModel : Model
defaultModel =
    0



-- UPDATE


type Msg
    = NoOp



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
        ]
