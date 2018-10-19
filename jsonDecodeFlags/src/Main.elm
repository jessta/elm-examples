module Main exposing (main)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Json.Decode


type alias Model =
    { count : Int }

-- a decoder to conver the incoming flags to a Model value
flagsToModelDecoder: Json.Decode.Decoder Model
flagsToModelDecoder =
    Json.Decode.map Model (Json.Decode.field "count" Json.Decode.int)


init : Json.Decode.Value -> ( Model, Cmd Msg )
init flags =
    let
        decodedResult =
            Json.Decode.decodeValue flagsToModelDecoder flags
    in
    -- If the decoder fails just use a default value.
    ( Result.withDefault { count = 0 } decodedResult, Cmd.none )


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | count = model.count + 1 }, Cmd.none )

        Decrement ->
            ( { model | count = model.count - 1 }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Increment ] [ text "+1" ]
        , div [] [ text <| String.fromInt model.count ]
        , button [ onClick Decrement ] [ text "-1" ]
        ]


main : Program Json.Decode.Value Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
