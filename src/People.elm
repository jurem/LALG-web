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


associateDecoder : Decode.Decoder Associate
associateDecoder =
    Decode.map4 Associate
        (Decode.field "name" Decode.string)
        (Decode.field "role" Decode.string)
        (Decode.field "from" Decode.string)
        (Decode.field "year" Decode.string)


type alias Student =
    { name : String
    , role : String
    , year : String
    }


studentDecoder : Decode.Decoder Student
studentDecoder =
    Decode.map3 Student
        (Decode.field "name" Decode.string)
        (Decode.field "role" Decode.string)
        (Decode.field "year" Decode.string)


type alias Model =
    { mdl : Material.Model
    , raised : String
    , members : List Member
    , associates : List Associate
    , students : List Student
    }


defaultModel : Model
defaultModel =
    { mdl = Material.model
    , raised = ""
    , members = []
    , associates = []
    , students = []
    }



-- UPDATE


type Msg
    = Mdl (Material.Msg Msg)
    | Raise String -- the focused member name
    | FetchMembers (Result Http.Error (List Member))
    | FetchAssociates (Result Http.Error (List Associate))
    | FetchStudents (Result Http.Error (List Student))


init : Cmd Msg
init =
    Cmd.batch
        [ Http.send FetchMembers
            (Http.get "data/members.json" (Decode.list memberDecoder))
        , Http.send FetchAssociates
            (Http.get "data/associates.json" (Decode.list associateDecoder))
        , Http.send FetchStudents
            (Http.get "data/students.json" (Decode.list studentDecoder))
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl submsg ->
            Material.update Mdl submsg model

        Raise member ->
            ( { model | raised = member }, Cmd.none )

        FetchMembers (Ok m) ->
            ( { model | members = m }, Cmd.none )

        FetchMembers (Err _) ->
            ( model, Cmd.none )

        FetchAssociates (Ok a) ->
            ( { model | associates = a }, Cmd.none )

        FetchAssociates (Err _) ->
            ( model, Cmd.none )

        FetchStudents (Ok s) ->
            ( { model | students = s }, Cmd.none )

        FetchStudents (Err _) ->
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
        , text (": " ++ associate.role ++ " from " ++ associate.from ++ parentheses associate.year)
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
        , ul [] (List.map (\x -> viewAssociate x) model.associates)
        , h3 [] [ text "Students" ]
        , ul [] (List.map (\x -> viewStudent x) model.students)
        ]
