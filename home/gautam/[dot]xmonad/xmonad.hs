import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/gautam/.xmobarrc"
    xmonad $ defaultConfig
        { terminal = "gnome-terminal"
        , manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , startupHook = startup
        }--  `additionalKeys`
        --[ ((modMask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
        --]

startup :: X ()
startup = do
    spawn "trayer --edge bottom --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x191970 --height 12 &"
    spawn "nm-applet --sm-disable > /dev/null 2>&1 &"
    spawn "sleep 3 && gnome-power-manager > /dev/null 2>&1 &"

