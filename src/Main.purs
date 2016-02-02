module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Electron (ELECTRON)
import Electron.App (Path(Home), quit, onReady, getPath, getAppPath)
import Electron.BrowserWindow (BrowserWindowOption(WebPreferences, Height, Width), WebPreference(ZoomFactor, OverlayScrollbars), onNewWindow, webContents, loadURL, onClose, newBrowserWindow)
import Electron.Event (preventDefault)
import Electron.Shell (openExternal)

main :: forall eff. Eff (console :: CONSOLE, electron :: ELECTRON | eff) Unit
main = do
  appPath <- getAppPath
  log appPath
  homePath <- getPath Home
  log homePath
  onReady $ do
    log "starting..."
    mainWindow <- newBrowserWindow [ Width 1200
                                   , Height 600
                                   , WebPreferences [ OverlayScrollbars true
                                                    , ZoomFactor 1.0
                                                    ]
                                   ]
    mainWindow `onClose` quit
    mainWindow `loadURL` "https://www.irccloud.com/"

    webStuff <- webContents mainWindow
    webStuff `onNewWindow` \event url -> do
      preventDefault event
      openExternal url
