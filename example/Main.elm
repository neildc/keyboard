module Main exposing (..)

import Browser
import Html exposing (Html, div, li, p, text, ul)
import Keyboard exposing (Key(..), RawKey)
import Keyboard.Arrows
import Style


type Msg
    = KeyboardMsg Keyboard.Msg


{-| We don't need any other info in the model, since we can get everything we
need using the helpers right in the `view`!

This way we always have a single source of truth, and we don't need to remember
to do anything special in the update.

-}
type alias Model =
    { pressedKeys : List RawKey
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { pressedKeys = [] }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyboardMsg keyMsg ->
            ( { model
                | pressedKeys = Keyboard.update keyMsg model.pressedKeys
              }
            , Cmd.none
            )


view : Model -> Html msg
view model =
    let
        keys =
            model.pressedKeys
                |> List.map
                    (Keyboard.anyKeyWith
                        [ Keyboard.modifierKey
                        , Keyboard.navigationKey
                        , Keyboard.characterKey
                        ]
                    )

        shiftPressed =
            List.member Shift keys

        arrows =
            Keyboard.Arrows.arrows keys

        wasd =
            Keyboard.Arrows.wasd keys
    in
    div Style.container
        [ text ("Shift: " ++ Debug.toString shiftPressed)
        , p [] [ text ("Arrows: " ++ Debug.toString arrows) ]
        , p [] [ text ("WASD: " ++ Debug.toString wasd) ]
        , p [] [ text "Currently pressed down:" ]
        , ul []
            (List.map (\key -> li [] [ text (Debug.toString key) ]) model.pressedKeys)
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map KeyboardMsg Keyboard.subscriptions


main : Program () Model Msg
main =
    Browser.embed
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
