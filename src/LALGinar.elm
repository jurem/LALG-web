module LALGinar exposing (..)

import Http
import Json.Decode as Decode
import Html exposing (..)
import Material
import Material.List as Lists


-- MODEL


type alias Seminar =
    { author : String
    , title : String
    , date : String
    }


seminarDecoder : Decode.Decoder Seminar
seminarDecoder =
    Decode.map3 Seminar
        (Decode.field "author" Decode.string)
        (Decode.field "title" Decode.string)
        (Decode.field "date" Decode.string)


type alias Model =
    { mdl : Material.Model
    , raised : String
    , seminars : List Seminar
    }


defaultModel : Model
defaultModel =
    { mdl = Material.model
    , raised = ""
    , seminars = []
    }


init : Cmd Msg
init =
    Http.send UpdateSeminars
        (Http.get "data/lalginar.json" (Decode.list seminarDecoder))



-- UPDATE


type Msg
    = Mdl (Material.Msg Msg)
    | Raise String
    | UpdateSeminars (Result Http.Error (List Seminar))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl submsg ->
            Material.update Mdl submsg model

        Raise member ->
            ( { model | raised = member }, Cmd.none )

        UpdateSeminars (Ok m) ->
            ( { model | seminars = m }, Cmd.none )

        UpdateSeminars (Err e) ->
            ( { model | seminars = [ Seminar (toString e) "1231" "1213", Seminar "BLA" "1231" "1213" ] }, Cmd.none )



-- VIEW


makeIcon : Seminar -> Html Msg
makeIcon seminar =
    let
        s =
            List.head (List.filter (\p -> (Tuple.first p) == seminar.author) [ ( "Jure Mihelič", "mem-mihelic.png" ), ( "Uroš Čibej", "mem-cibej.png" ), ( "Borut Robič", "mem-robic.png" ), ( "Boštjan Slivnik", "mem-slivnik.png" ), ( "Tomaž Dobravec", "mem-dobravec.png" ), ( "Boštjan Vilfan", "mem-vilfan.jpg" ) ])
    in
        case s of
            Nothing ->
                Lists.avatarIcon "account_circle" []

            Just p ->
                Lists.avatarImage ("img/" ++ (Tuple.second p)) []


viewSeminar : Model -> Seminar -> Html Msg
viewSeminar model seminar =
    Lists.content []
        [ makeIcon seminar
        , text seminar.author
        , br [] []
        , Lists.body [] [ text seminar.title ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Past seminars" ]
        , Lists.ul []
            (List.map (\x -> Lists.li [ Lists.withBody ] [ viewSeminar model x ]) model.seminars)
        ]
