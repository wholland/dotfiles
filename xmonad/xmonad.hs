import XMonad
import XMonad.Util.Run
import XMonad.Util.Loggers
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig(additionalKeys)
import Graphics.X11.ExtraTypes.XF86

myBar = "/home/wholland/local/bin/lemonbar -g 1920x30 -d -p -B \"#000000\" -u 4 -U \"#00ff00\" -f \"Iosevka Medium:size=10:weight=Medium\" -f \"Iosevka Medium:size=10:weight=Heavy:slant=Oblique\""
myTerminal = "/home/wholland/local/bin/st -e /usr/bin/tmux new-session \\; set-option destroy-unattached"
myNotificationServer = "/home/wholland/local/bin/dunst"
myManageHook = manageHook defaultConfig
myLayoutHook = avoidStruts $ smartBorders $ layoutHook defaultConfig

fgGreen = "%{F#00ff00}"
fgDefault = "%{F-}"

myBarFormat h = dynamicLogWithPP $ def 
    {
    ppCurrent =  (wrap "%{R}" "%{R}") . pad 
    , ppHidden =  (wrap "%{+u}" "%{-u}"  . pad) 
    , ppHiddenNoWindows =  pad 
    -- , ppSep = "|Ā©ÿ|"
    , ppSep = " "
    , ppLayout = (wrap (fgGreen ++ "%{T2}") (fgDefault ++ "%{T-}"))
    , ppOrder = \(workspaces:layout:title:extras) -> [layout, workspaces, "%{c}", title, "%{r}"] ++ extras
    , ppOutput = hPutStrLn h
    , ppExtras =  [date "%a %b %d %H:%M "]
    }

volumeUp = do
    spawn "amixer -D pulse set Master 5%+"
    -- spawn "notify-send -u low \"Volume\" \"Up\""

volumeDown = do
    spawn "amixer -D pulse set Master 5%-"
    -- spawn "notify-send -u low \"Volume\" \"Down\""
    
volumeMuteToggle = do
    spawn "amixer -D pulse set Master toggle"
    -- spawn "notify-send -u low \"Volume\" \"Mute Toggle\""

main = do
    bar <- spawnPipe myBar
    spawn myNotificationServer

    xmonad $ withUrgencyHook NoUrgencyHook $ docks $ ewmh $ defaultConfig { 
        terminal = myTerminal
        , modMask = mod4Mask
        , borderWidth = 3
        -- , logHook = myLogHook bar
        , logHook = myBarFormat bar
        , manageHook = myManageHook
        , layoutHook = myLayoutHook
        , handleEventHook = fullscreenEventHook
    } `additionalKeys`
        [ ((0, xF86XK_AudioLowerVolume), volumeDown)
        , ((0, xF86XK_AudioRaiseVolume), volumeUp)
        , ((0, xF86XK_AudioMute), volumeMuteToggle)
        ]
