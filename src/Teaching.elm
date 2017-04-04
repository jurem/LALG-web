module Teaching exposing (..)

import Http
import Json.Decode as Decode
import Html exposing (..)
import Material


-- MODEL


type alias Course =
    { level : Int
    , name : String
    , program : String
    , lecturer : String
    }


courseDecoder : Decode.Decoder Course
courseDecoder =
    Decode.map4 Course
        (Decode.field "level" Decode.int)
        (Decode.field "name" Decode.string)
        (Decode.field "program" Decode.string)
        (Decode.field "lecturer" Decode.string)


type alias Model =
    { mdl : Material.Model
    , courses : List Course
    }


defaultModel : Model
defaultModel =
    { mdl = Material.model
    , courses = []
    }


init : Cmd Msg
init =
    Http.send UpdateCourses
        (Http.get "data/courses.json" (Decode.list courseDecoder))



-- UPDATE


type Msg
    = UpdateCourses (Result Http.Error (List Course))



--| Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateCourses (Ok c) ->
            ( { model | courses = c }, Cmd.none )

        UpdateCourses (Err _) ->
            ( model, Cmd.none )



-- VIEW


viewCourse : Model -> Course -> Html Msg
viewCourse model course =
    div []
        [ h5 [] [ text course.name ]
        , text course.program
        , br [] []
        , text ("Lecturer: " ++ course.lecturer)
        ]


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Undergraduate courses" ]
        , ul [] (List.map (\x -> viewCourse model x) (List.filter (\x -> 1 == .level x) model.courses))
        , h3 [] [ text "Master courses" ]
        , ul [] (List.map (\x -> viewCourse model x) (List.filter (\x -> 2 == .level x) model.courses))
        , h3 [] [ text "PhD courses" ]
        , ul [] (List.map (\x -> viewCourse model x) (List.filter (\x -> 3 == .level x) model.courses))
        ]
