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
        }
        `additionalKeys`
        [ ((mod1Mask .|. controlMask, xK_l),
              spawn "slock")
        ]

startup :: X ()
startup = do
    spawn "/home/gautam/.startup.sh"

