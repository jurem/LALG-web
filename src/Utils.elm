module Utils exposing (..)

import Html exposing (Html)
import Material.Options as Options
import Material.Color as Color


parentheses : String -> String
parentheses str =
    if String.isEmpty str then
        ""
    else
        String.concat [ " (", str, ")" ]


spacepx : Int -> Html a
spacepx pixels =
    Options.span [ Options.css "width" <| toString pixels ++ "px" ] []


space : Html a
space =
    spacepx 4


primaryHue : Color.Hue
primaryHue =
    Color.Green


accentedHue : Color.Hue
accentedHue =
    Color.Pink


header_bg : Color.Color
header_bg =
    Color.color primaryHue Color.S300


header_fg : Color.Color
header_fg =
    Color.color primaryHue Color.S900


footer_bg : Color.Color
footer_bg =
    Color.color primaryHue Color.S300


footer_fg : Color.Color
footer_fg =
    Color.color primaryHue Color.S900


tabs_bg : Color.Color
tabs_bg =
    Color.color primaryHue Color.S100


tabs_fg : Color.Color
tabs_fg =
    Color.color primaryHue Color.S900


page_bg : Color.Color
page_bg =
    Color.color primaryHue Color.S50


page_fg : Color.Color
page_fg =
    Color.color primaryHue Color.S900


card_bg : Color.Color
card_bg =
    Color.color primaryHue Color.S200


card_fg : Color.Color
card_fg =
    Color.color primaryHue Color.S900
