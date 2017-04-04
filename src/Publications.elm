module Publications exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, src, width, height)
import Material.Grid as Grid


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


viewBook : String -> String -> List (Html Msg) -> Html Msg
viewBook title imgsrc desc =
    div []
        [ h4 [] [ text title ]
        , Grid.grid []
            [ Grid.cell [ Grid.size Grid.All 3 ] [ img [ src imgsrc, height 256 ] [] ]
            , Grid.cell [ Grid.size Grid.All 6 ] desc
            ]
        ]


viewBooks : Html Msg
viewBooks =
    div []
        [ h3 [] [ text "Books" ]
        , ul []
            [ viewBook "The Foundations of Computability Theory"
                "img/book-fct.jpg"
                [ text "By Borut Robič, Springer, 2015"
                , ul []
                    [ li [] [ a [ href "http://lalg.fri.uni-lj.si/~borut/fct/" ] [ text "Booksite" ] ]
                    , li [] [ a [ href "http://www.springer.com/gp/book/9783662448076" ] [ text "Go at Springer" ] ]
                    , li [] [ a [ href "https://www.amazon.com/Foundations-Computability-Theory-Borut-Robi/dp/3662448076" ] [ text "Go at Amazon" ] ]
                    ]
                ]
            , viewBook "Koncepti operacijskih sistemov z Linuxovo lupino in programiranjem v Bashu"
                "img/book-kosbash.jpg"
                [ text "Compiled textbook by William Stallings, Jurij Mihelič, Bojan Klemenc, Peter Peer, Pearson, 2013"
                , ul []
                    [ li [] [ a [ href "http://lalg.fri.uni-lj.si/jurij/kosbash" ] [ text "Booksite" ] ]
                    , li [] [ a [ href "http://www.pasadena.si/knjiga/96706/" ] [ text "Go at Pasadena" ] ]
                    ]
                ]
            , viewBook "Aproksimacijski algoritmi"
                "img/book-aproksalg.png"
                [ text "By Borut Robic, Založba FE in FRI, UNI LJ, 2009" ]
            , viewBook "Processor Architecture: From Dataflow to Superscalar and Beyond"
                "img/book-procarch.jpg"
                [ text "By Borut Robic, Jurij Šilc, and Theo Ungerer, Springer, 1999"
                , ul []
                    [ li [] [ a [ href "http://www.springer.com/br/book/9783540647980" ] [ text "Go at Springer" ] ]
                    , li [] [ a [ href "https://www.amazon.com/Processor-Architecture-Dataflow-Superscalar-Beyond/dp/3540647988" ] [ text "Go at Amazon" ] ]
                    ]
                ]
            ]
        ]


viewChapters : Html Msg
viewChapters =
    div []
        [ h3 [] [ text "Book chapters" ]
        ]


viewPapers : Html Msg
viewPapers =
    div []
        [ h3 [] [ text "Selected papers" ]
        ]


viewSoftware : Html Msg
viewSoftware =
    div []
        [ h3 [] [ text "Software" ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ viewBooks
        , viewChapters
        , viewPapers
        , viewSoftware
        ]
