//
//  Copyright © 2021 Sascha Lamprecht. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {

    @IBOutlet weak var title_picture: NSImageView!
    @IBOutlet weak var start_button: NSButton!
    @IBOutlet weak var taipan_header: NSTextField!
    @IBOutlet weak var color_selector: NSPopUpButton!
    
    var player: AVAudioPlayer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height);
        let lc = Locale.current.languageCode
        
        let fontcheck = UserDefaults.standard.string(forKey: "Font")
        if fontcheck == nil{
            UserDefaults.standard.set("Taipan", forKey: "Font")
        }
        let colorcheck = UserDefaults.standard.string(forKey: "Color")
        if colorcheck == nil{
            if lc == "de"{
                UserDefaults.standard.set("Grün", forKey: "Color")
            } else {
            UserDefaults.standard.set("Green", forKey: "Color")
            }
        }
        let speedcheck = UserDefaults.standard.string(forKey: "Speed")
        if speedcheck == nil{
            if lc == "de"{
                UserDefaults.standard.set("Traditionell", forKey: "Speed")
            } else {
            UserDefaults.standard.set("Traditional", forKey: "Speed")
            }
        }
        let languagecheck = UserDefaults.standard.string(forKey: "Language")
        if languagecheck == nil{
            if lc == "de"{
                UserDefaults.standard.set("Englisch", forKey: "Language")
            } else {
            UserDefaults.standard.set("English", forKey: "Language")
            }
        }
     }
    
    @IBAction func start_game(_ sender: Any) {
        let url = Bundle.main.url(forResource: "gong", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
        title_picture.isHidden = true
        start_button.title = NSLocalizedString("Reset", comment: "")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Startbutton"), object: nil, userInfo: ["name" : self.start_game])
    }
}
