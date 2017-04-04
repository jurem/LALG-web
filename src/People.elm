module People exposing (..)

import Http
import Json.Decode as Decode
import Html exposing (..)
import Html.Attributes exposing (..)
import Material
import Material.Options as Options exposing (styled, cs, css)
import Material.Grid as Grid
import Material.Card as Card
import Material.Color as Color
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Elevation as Elevation
import Material.Typography as Typography


--

import Utils exposing (..)


-- MODEL


type alias Member =
    { name : String
    , title : String
    , img : String
    , phone : String
    , email : String
    , room : String
    }


memberDecoder : Decode.Decoder Member
memberDecoder =
    Decode.map6 Member
        (Decode.field "name" Decode.string)
        (Decode.field "title" Decode.string)
        (Decode.field "img" Decode.string)
        (Decode.field "phone" Decode.string)
        (Decode.field "email" Decode.string)
        (Decode.field "room" Decode.string)


type alias Associate =
    { name : String
    , role : String
    , from : String
    , year : String
    }


associate : String -> String -> String -> String -> Associate
associate name role from year =
    { name = name, role = role, from = from, year = year }


associates : List Associate
associates =
    [ associate "Vojta Vojtech" "visiting student" "Prague, Czech" "2016"
    , associate "Jan Pérhač" "visiting student" "Košice, Slovakia" "2016"
    , associate "Ivan Halupka" "visiting student" "Košice, Slovakia" "2014"
    , associate "Christophe Rapine" "visiting researcher" "Grenoble, France" "2002"
    , associate "Amine Mahjoub" "visiting researcher" "Grenoble, France" "2002"
    ]


type alias Student =
    { name : String
    , role : String
    , year : String
    }


student : String -> String -> String -> Student
student name role year =
    { name = name, role = role, year = year }


students : List Student
students =
    [ student "Luka Hauptman" "teaching assistant, PhD student" ""
    , student "Mitja Bezenšek" "young researcher, PhD student" ""
    , student "Nikolaj Janko" "summer school, demonstrator, project member" "2012-2015"
    , student "Tadej Borovšak" "summer school, lalginar, demonstrator" "2013-2014"
    , student "Sven Cerk" "subgraph isomorphisms, summer school" "2014"
    , student "Klemen Kloboves" "SIC/XE toolchain, C++" "2013"
    ]


type alias Model =
    { mdl : Material.Model
    , raised : String
    , members : List Member
    }


defaultModel : Model
defaultModel =
    { mdl = Material.model
    , raised = ""
    , members = []
    }


init : Cmd Msg
init =
    Http.send UpdateMembers
        (Http.get "data/members.json" (Decode.list memberDecoder))



-- UPDATE


type Msg
    = Mdl (Material.Msg Msg)
    | Raise String -- the focused member name
    | UpdateMembers (Result Http.Error (List Member))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl submsg ->
            Material.update Mdl submsg model

        Raise member ->
            ( { model | raised = member }, Cmd.none )

        UpdateMembers (Ok m) ->
            ( { model | members = m }, Cmd.none )

        UpdateMembers (Err _) ->
            ( model, Cmd.none )



-- VIEW


elev_ : a -> a -> Options.Property m n
elev_ x y =
    if x == y then
        Elevation.e16
    else
        Elevation.e2


view_opt : String -> String -> Html Msg
view_opt icon str =
    if String.length str == 0 then
        div [] []
    else
        Options.div [ Options.center, Typography.body1 ] [ Icon.i icon, Utils.space, text str, Layout.spacer ]


viewMember : Model -> Member -> Html Msg
viewMember model member =
    Card.view
        [ css "width" "95%"
        , css "margin" "4px 8px 4px 0px"
        , Color.background Utils.card_bg
        , Color.text Utils.card_fg
        , elev_ model.raised member.name
        , Elevation.transition 250
        , Options.onMouseEnter (Raise member.name)
        , Options.onMouseLeave (Raise "")
        ]
        [ Card.title [ css "background" "rgba(0, 0, 0, 0.05)" ]
            [ Card.head [] [ text member.name ]
            , Card.subhead [] [ text member.title ]
            ]
        , Card.text []
            [ Options.img
                [ Options.attribute <| Html.Attributes.src <| "img/" ++ member.img, css "width" "190px", Elevation.e3 ]
                []
            ]
        , Card.actions [ Card.border ]
            [ view_opt "phone" member.phone
            , view_opt "email" member.email
            , view_opt "room" member.room
            ]
        ]


viewAssociate : Associate -> Html Msg
viewAssociate associate =
    li []
        [ b [] [ text associate.name ]
        , text (": " ++ associate.role ++ parentheses associate.year)
        ]


viewStudent : Student -> Html Msg
viewStudent student =
    li []
        [ b [] [ text student.name ]
        , text (": " ++ student.role ++ parentheses student.year)
        ]


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Members" ]
        , Grid.grid []
            (List.map (\x -> Grid.cell [ Grid.size Grid.All 4 ] [ viewMember model x ]) model.members)
        , h3 [] [ text "Associates and guests" ]
        , ul [] (List.map (\x -> viewAssociate x) associates)
        , h3 [] [ text "Students" ]
        , ul [] (List.map (\x -> viewStudent x) students)
        ]
