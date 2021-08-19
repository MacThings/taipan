//
//  Copyright © 2021 Sascha Lamprecht. All rights reserved.
//

import Cocoa
     
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let alert_check = UserDefaults.standard.bool(forKey: "HintRead")
        if alert_check == false {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Important!", comment: "")
        alert.informativeText = NSLocalizedString("To start a game press the rotary switch at the bottom right. If you want to restart a game press the reset button. To enter the firm name at every beginning of a new game you must click at the input box to active textinput.", comment: "")
        alert.alertStyle = .warning
        alert.icon = NSImage(named: "applied")
        let Button = NSLocalizedString("I understand", comment: "")
        alert.addButton(withTitle: Button)
        alert.runModal()
        UserDefaults.standard.set(true, forKey: "HintRead")
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
}

