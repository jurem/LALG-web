module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (src, width, height, href)
import Html.Lazy
import Material
import Material.Layout as Layout
import Material.Options as Options exposing (css, when, center)
import Material.Typography as Typography
import Material.Scheme as Scheme
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Typography as Typography
import Material.Icon as Icon
import Material.Footer as Footer
import Material.Card as Card
import Material.List as List
import Material.Grid as Grid


-- Local modules

import Utils exposing (spacepx, space)
import People
import Teaching
import Research
import Publications


-- MODEL


type alias Model =
    { mdl : Material.Model
    , tab : Int
    , people : People.Model
    , teaching : Teaching.Model
    , research : Research.Model
    , publications : Publications.Model
    }


defaultModel : Model
defaultModel =
    { mdl = Layout.setTabsWidth 50 Material.model --??? setTabsWidth
    , tab = 0
    , people = People.defaultModel
    , teaching = Teaching.defaultModel
    , research = Research.defaultModel
    , publications = Publications.defaultModel
    }



-- UPDATE


type Msg
    = Mdl (Material.Msg Msg)
    | SelectTab Int
    | PeopleMsg People.Msg
    | TeachingMsg Teaching.Msg
    | ResearchMsg Research.Msg
    | PublicationsMsg Publications.Msg


{-|
| Lift a submodel and submsg to (Model, Cmd Msg)
-}
lift :
    Model -- original model
    -> (Model -> submodel -> Model) -- updates model's submodel
    -> (submsg -> Msg) -- converts sub message to Msg
    -> ( submodel, Cmd submsg ) -- sub model and sub message
    -> ( Model, Cmd Msg ) -- model and message
lift mdl liftsubmdl liftsubmsg ( submdl, subcmd ) =
    ( liftsubmdl mdl submdl, Cmd.map liftsubmsg subcmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl submsg ->
            Material.update Mdl submsg model

        SelectTab t ->
            ( { model | tab = t }, Cmd.none )

        PeopleMsg submsg ->
            lift model (\m x -> { m | people = x }) PeopleMsg (People.update submsg model.people)

        TeachingMsg submsg ->
            lift model (\m x -> { m | teaching = x }) TeachingMsg (Teaching.update submsg model.teaching)

        ResearchMsg submsg ->
            lift model (\m x -> { m | teaching = x }) ResearchMsg (Research.update submsg model.teaching)

        PublicationsMsg submsg ->
            lift model (\m x -> { m | publications = x }) PublicationsMsg (Publications.update submsg model.publications)



-- VIEW


viewHeader : Model -> List (Html Msg)
viewHeader model =
    [ Layout.row
        [ css "height" "128px"
        , Color.background Utils.header_bg
        , Color.text Utils.header_fg
        ]
        [ img [ src "img/logo-lalg.png", width 100 ] []
        , spacepx 10
        , Layout.title [] [ text "Laboratory for Algorithms and Data Structures" ]
        , Layout.spacer
        , img [ src "img/logo-fri.png", width 200 ] []
        ]
    , Layout.row [ css "height" "16px", Color.background Utils.tabs_bg ] []
    ]


viewTabs : List (Html Msg)
viewTabs =
    [ Options.div [ Options.center ] [ Icon.i "home", space, b [] [ text "Home" ] ]
    , Options.div [ Options.center ] [ Icon.i "people", space, b [] [ text "People" ] ]
    , Options.div [ Options.center ] [ Icon.i "school", space, b [] [ text "Teaching" ] ]
    , Options.div [ Options.center ] [ Icon.i "filter_vintage", space, b [] [ text "Research" ] ]
    , Options.div [ Options.center ] [ Icon.i "edit", space, b [] [ text "Publications" ] ]
    ]


viewFooter : Html Msg
viewFooter =
    Footer.mega [ Color.background Utils.footer_bg, Color.text Utils.footer_fg ]
        { top =
            Footer.top []
                { left =
                    Footer.left []
                        [ Footer.html <|
                            div [ href "http://elm-lang.org" ]
                                [ img [ src "img/logo-lalg.png", width 40, height 40 ] []
                                , text " Report bugs to Jure M"
                                ]
                        ]
                , right =
                    Footer.right []
                        [ Footer.html <|
                            a [ href "http://elm-lang.org" ]
                                [ text "Handmade with Elm "
                                , img [ src "img/logo-elm.png", width 32, height 32 ] []
                                ]
                        ]
                }
        , middle =
            Footer.middle []
                [ Footer.html <|
                    Options.div [ Options.center, Typography.center ]
                        [ text "Laboratory for Algorithms and Data Structures"
                        , br [] []
                        , text "Faculty of Computer and Information Science"
                        , br [] []
                        , text "University of Ljubljana"
                        ]
                ]
        , bottom = Footer.bottom [] []
        }


view404 : Model -> Html Msg
view404 _ =
    div []
        [ Options.styled Html.h1
            [ Typography.display4, Typography.center ]
            [ text "404" ]
        , Options.styled Html.h3
            [ Typography.display3, Typography.center ]
            [ br [] []
            , text "Page simply not found"
            ]
        ]


viewResearch : String -> String -> String -> List (Grid.Cell msg)
viewResearch icon title desc =
    [ Grid.cell [ Grid.size Grid.All 1 ] [ List.icon icon [ Icon.size48 ] ]
    , Grid.cell [ Grid.size Grid.All 11 ]
        [ b [] [ text title ]
        , br [] []
        , text desc
        ]
    ]


viewMain : Model -> Html Msg
viewMain model =
    Card.view [ css "width" "100%", css "padding" "0px", Elevation.e2 ]
        [ Card.media []
            [ Options.img [ css "width" "100%" ] [ src "img/pic00.jpg" ] ]
        , Card.title [ Options.scrim 0.3, Color.background Utils.tabs_bg ]
            [ text "About us" ]
        , Card.text [ css "width" "100%", css "box-sizing" "border-box" ]
            [ a [ href "http://lalg.fri.uni-lj.si" ] [ text "Laboratory of Algorithms and Data Structures" ]
            , text " is a research laboratory at the "
            , a [ href "http://www.fri.uni-lj.si" ] [ text "Faculty of Computer and Information Science" ]
            , text ", "
            , a [ href "http://www.uni-lj.si" ] [ text "University of Ljubljana" ]
            , text "."
            , hr [] []
            , text "We conduct research and development as well as teaching in the following areas:"
            , Grid.grid []
                (viewResearch "build" "Algorithm engineering and experimental algorithmics" "implementing and optimizing algorithms to perfom well in practice, experimental evaluation of algorithm efficiency"
                    ++ viewResearch "done_all" "Parallel and distributed computation and algorithms" "using parallelism to enhance algorithms, multithreading, message passing, general purpose graphic processing unit, dataflow computing, grid computing"
                    ++ viewResearch "bug_report" "Compiler design and programming languages" "modern parsing methods, syntax and lexical analysis, parse trees, code optimization and generation, functional programming"
                    ++ viewResearch "apps" "System software engineering and operating systems" "assemblers, linkers, virtual machines, emulators, operating systems, virtualization and containers, system programming"
                    ++ viewResearch "spa" "Theory of algorithms, computability and complexity theory" "approximation and randomised algorithms, exact exponential algorithms and fixed parameter tractability, combinatorial optimization, problems on graphs"
                )
            ]
        ]


viewPage : Model -> Html Msg
viewPage model =
    Options.div
        [ css "padding-left" "10%"
        , css "padding-right" "10%"
        , css "border" "none"
        , css "background" "url('img/bgpat.png') repeat"
        , Color.background Utils.page_bg
        , Color.text Utils.page_fg
        ]
        [ br [] [] -- seems to be a bug in elm-mdl: if first element is a header, the border is to big
        , (case model.tab of
            0 ->
                viewMain model

            1 ->
                Html.map PeopleMsg (People.view model.people)

            2 ->
                Html.map TeachingMsg (Teaching.view model.teaching)

            3 ->
                Html.map ResearchMsg (Research.view model.teaching)

            4 ->
                Html.map PublicationsMsg (Publications.view model.teaching)

            _ ->
                view404 model
          )
        , br [] [] -- additonal space
        ]


view_ : Model -> Html Msg
view_ model =
    Layout.render Mdl
        model.mdl
        [ Layout.selectedTab model.tab
        , Layout.onSelectTab SelectTab
        , Layout.fixedHeader
        , Layout.fixedTabs
        , Layout.rippleTabs
        , Layout.waterfall True
        ]
        { header = viewHeader model
        , drawer = []
        , tabs = ( viewTabs, [ Color.background Utils.tabs_bg, Color.text Utils.tabs_fg ] )
        , main = [ viewPage model, viewFooter ]
        }


view : Model -> Html Msg
view model =
    -- TODO: production: move style to html
    --Scheme.topWithScheme Utils.primaryHue Utils.accentedHue <|
    Html.Lazy.lazy view_ model



-- MAIN


main : Program Never Model Msg
main =
    Html.program
        { init = ( defaultModel, Material.init Mdl )
        , update = update
        , subscriptions = \model -> Sub.batch [ Material.subscriptions Mdl model ]
        , view = view
        }
