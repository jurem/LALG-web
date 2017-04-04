module Teaching exposing (..)

import Html exposing (..)


-- MODEL


type alias Course =
    { name : String
    , program : String
    , lecturer : String
    }


course : String -> String -> String -> Course
course name program lecturer =
    { name = name, program = program, lecturer = lecturer }


pro : String
pro =
    "Undergraduate professional study program Computer and Information Science"


uni : String
uni =
    "Undergraduate university study program Computer and Information Science"



-- undergraduate


courses1 : List Course
courses1 =
    [ course "Algorithms and data structures 1" (pro ++ ", Second year") "Jurij Mihelič"
    , course "Algorithms and data structures 2" (uni ++ ", Second year") "Borut Robič"
    , course "Compilers and virtual machines" (uni ++ ", Second year") "Boštjan Slivnik"
    , course "Computability theory" (uni ++ ", Second year") "Borut Robič"
    , course "Operating systems" (uni ++ ", Second year") "Borut Robič"
    , course "Programming 2" (uni ++ ", First year") "Boštjan Slivnik"
    , course "Programming 2" (pro ++ ", First year") "Tomaž Dobravec"
    , course "Scala programming language" "Technical course" "Uroš Čibej"
    , course "System Software" (uni ++ ", Third year") "Tomaž Dobravec"
    ]



-- master


courses2 : List Course
courses2 =
    [ course "Algorithms" "Master study, First year" "Tomaž Dobravec"
    , course "Algorithm engineering" "Master study" "Jurij Mihelič"
    ]



-- PhD


courses3 : List Course
courses3 =
    [ course "Contemporary apporaches to algorithm design" "PhD study" "Borut Robič, Jurij Mihelič"
    ]


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
        , ul [] (List.map (\x -> viewCourse model x) courses1)
        , h3 [] [ text "Master courses" ]
        , ul [] (List.map (\x -> viewCourse model x) courses2)
        , h3 [] [ text "PhD courses" ]
        , ul [] (List.map (\x -> viewCourse model x) courses3)
        ]
