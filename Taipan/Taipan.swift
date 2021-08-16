//
//  WebViewController.swift
//  WKWebView
//
//  Created by Marco Barnig on 17/11/2016.
//  Copyright © 2016 Marco Barnig. All rights reserved.
//

import Cocoa
import WebKit

class Taipan: NSViewController, WKUIDelegate, WKNavigationDelegate {

    var myWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.pressStartbutton),
            name: NSNotification.Name(rawValue: "Startbutton"),
            object: nil)
    }
    
    @objc private func pressStartbutton(notification: NSNotification){
        let url = URL(fileURLWithPath: Bundle.main.resourcePath!)
        var LaunchPath = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString.replacingOccurrences(of: "file://", with: "").replacingOccurrences(of: "%20", with: " ")
        LaunchPath.removeLast()
        
        shell(cmd: "cp -rf " + LaunchPath + "/Contents/Resources/Taipan /private/tmp/")
        
        let languagecheck = UserDefaults.standard.string(forKey: "Language")
        if languagecheck!.contains("Engl") {
            print("")
        } else {
            shell(cmd: "rm /private/tmp/Taipan/Taipan.html; mv /private/tmp/Taipan/Taipan_DE.html /private/tmp/Taipan/Taipan.html")
        }
            
        let speedcheck = UserDefaults.standard.string(forKey: "Speed")
        if speedcheck == "2x"{
            shell(cmd: "sed -ib '120s/.*/250/' /private/tmp/Taipan/Taipan.html")
        } else if speedcheck == "3x"{
            shell(cmd: "sed -ib '120s/.*/170/' /private/tmp/Taipan/Taipan.html")
        } else if speedcheck == "4x"{
            shell(cmd: "sed -ib '120s/.*/125/' /private/tmp/Taipan/Taipan.html")
        } else if speedcheck == "5x"{
            shell(cmd: "sed -ib '120s/.*/100/' /private/tmp/Taipan/Taipan.html")
        }
        
        let fontcheck = UserDefaults.standard.string(forKey: "Font")
        if fontcheck == "System"{
            shell(cmd: "sed -ib '9d;10d' /private/tmp/Taipan/Taipan.html")
        }
        
        let alert_check = UserDefaults.standard.bool(forKey: "AlertShown")
        if alert_check == false {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Important!", comment: "")
        alert.informativeText = NSLocalizedString("Before entering you company name click on the input window first to active it.", comment: "")
        alert.alertStyle = .warning
        alert.icon = NSImage(named: "applied")
        let Button = NSLocalizedString("I understand", comment: "")
        alert.addButton(withTitle: Button)
        alert.runModal()
        UserDefaults.standard.set(true, forKey: "AlertShown")
        }

        let configuration = WKWebViewConfiguration()
        myWebView = WKWebView(frame: .zero, configuration: configuration)
        myWebView.translatesAutoresizingMaskIntoConstraints = false
        myWebView.navigationDelegate = self
        myWebView.uiDelegate = self
        view.addSubview(myWebView)
        // topAnchor only available in version 10.11
        [myWebView.topAnchor.constraint(equalTo: view.topAnchor),
         myWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         myWebView.leftAnchor.constraint(equalTo: view.leftAnchor),
         myWebView.rightAnchor.constraint(equalTo: view.rightAnchor)].forEach  {
            anchor in
            anchor.isActive = true
        }
        let myURL = URL(string: "file://private/tmp/Taipan/Taipan.html")
        let myRequest = URLRequest(url: myURL!)
        myWebView.load(myRequest)
    }
    
    
    func shell(cmd: String) {
        let process            = Process()
        process.launchPath     = "/bin/bash"
        process.arguments      = ["-c", cmd]
        process.launch() // Start process
        process.waitUntilExit() // Wait for process to terminate.
    }
}
