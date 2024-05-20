//
//  Copyright © 2021 Sascha Lamprecht. All rights reserved.
//

import Cocoa
import WebKit

class Taipan: NSViewController, WKUIDelegate, WKNavigationDelegate {

    var myWebView: WKWebView!
    
    let filename = "/private/tmp/Taipan/Taipan.html"
    
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
        if languagecheck == "1" {
            print("")
        } else {
            shell(cmd: "rm /private/tmp/Taipan/Taipan.html; mv /private/tmp/Taipan/Taipan_DE.html /private/tmp/Taipan/Taipan.html")
        }
            
        let speedcheck = UserDefaults.standard.string(forKey: "Speed")
        if speedcheck == "2"{
            shell(cmd: "sed -ib '120s/.*/250/' /private/tmp/Taipan/Taipan.html")
        } else if speedcheck == "3"{
            shell(cmd: "sed -ib '120s/.*/170/' /private/tmp/Taipan/Taipan.html")
        } else if speedcheck == "4"{
            shell(cmd: "sed -ib '120s/.*/125/' /private/tmp/Taipan/Taipan.html")
        } else if speedcheck == "5"{
            shell(cmd: "sed -ib '120s/.*/100/' /private/tmp/Taipan/Taipan.html")
        } else if speedcheck == "6"{
            shell(cmd: "sed -ib '120s/.*/75/' /private/tmp/Taipan/Taipan.html")
        }
        
        let fontcheck = UserDefaults.standard.string(forKey: "Font")
        if fontcheck == "2"{
            shell(cmd: "sed -ib '9d;10d;58d' /private/tmp/Taipan/Taipan.html")
        }
        
        let colorcheck = UserDefaults.standard.string(forKey: "Color")
        
        if colorcheck == "Green inv." || colorcheck == "Grün inv." {
            do {
                var contents = try String(contentsOfFile: filename)
                contents = contents.replacingOccurrences(of: "000000", with: "000001")
                contents = contents.replacingOccurrences(of: "0f0", with: "000000")
                contents = contents.replacingOccurrences(of: "000001", with: "0f0")
                contents = contents.replacingOccurrences(of: "pics\\/dm", with: "picsi\\/dm")
                contents = contents.replacingOccurrences(of: "\"pics", with: "\"picsi")
                try contents.write(toFile: filename, atomically: false, encoding: String.Encoding.utf8)
            } catch {
                return
            }
        } else if colorcheck == "Amber" || colorcheck == "Bernstein" {
            do {
                var contents = try String(contentsOfFile: filename)
                contents = contents.replacingOccurrences(of: "0f0", with: "ffb000")
                contents = contents.replacingOccurrences(of: "\"pics", with: "\"picsamb")
                try contents.write(toFile: filename, atomically: false, encoding: String.Encoding.utf8)
            } catch {
                return
            }
        } else if colorcheck == "Amber inv." || colorcheck == "Bernstein inv." {
            do {
                var contents = try String(contentsOfFile: filename)
                contents = contents.replacingOccurrences(of: "000000", with: "ffb000")
                contents = contents.replacingOccurrences(of: "0f0", with: "000000")
                contents = contents.replacingOccurrences(of: "pics\\/dm", with: "picsambi\\/dm")
                contents = contents.replacingOccurrences(of: "\"pics", with: "\"picsambi")
                try contents.write(toFile: filename, atomically: false, encoding: String.Encoding.utf8)
            } catch {
                return
            }
        } else if colorcheck == "B/W" || colorcheck == "S/W" {
            do {
                var contents = try String(contentsOfFile: filename)
                contents = contents.replacingOccurrences(of: "0f0", with: "fff")
                contents = contents.replacingOccurrences(of: "\"pics", with: "\"picsbw")
                try contents.write(toFile: filename, atomically: false, encoding: String.Encoding.utf8)
            } catch {
                return
            }
        } else if colorcheck == "B/W inv." || colorcheck == "S/W inv." {
            do {
                var contents = try String(contentsOfFile: filename)
                contents = contents.replacingOccurrences(of: "000000", with: "ffffff")
                contents = contents.replacingOccurrences(of: "0f0", with: "000000")
                contents = contents.replacingOccurrences(of: "background-color: #000000", with: "background-color: #cccccc")
                contents = contents.replacingOccurrences(of: "pics\\/dm", with: "picsbwi\\/dm")
                contents = contents.replacingOccurrences(of: "\"pics", with: "\"picsbwi")
                try contents.write(toFile: filename, atomically: false, encoding: String.Encoding.utf8)
            } catch {
                return
            }
        }
        
        let configuration = WKWebViewConfiguration()
        myWebView = WKWebView(frame: .zero, configuration: configuration)
        myWebView.translatesAutoresizingMaskIntoConstraints = false
        myWebView.navigationDelegate = self
        myWebView.uiDelegate = self
        myWebView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1 Mobile/15E148 Safari/604.1"
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
