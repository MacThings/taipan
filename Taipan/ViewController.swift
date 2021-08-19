//
//  Copyright © 2021 Sascha Lamprecht. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {

    @IBOutlet weak var title_picture: NSImageView!
    @IBOutlet weak var taipan_header: NSTextField!
    @IBOutlet weak var color_selector: NSPopUpButton!
    @IBOutlet weak var crt_mask: NSImageView!
    @IBOutlet weak var crt_black_screen: NSBox!
    @IBOutlet weak var container_view: NSView!
    
    
    @IBOutlet weak var power_led: NSImageView!
    @IBOutlet weak var toggle_switch: NSButton!
    @IBOutlet weak var reset_button: NSButton!
    
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let scanlinescheck = UserDefaults.standard.string(forKey: "Scanlines")
        if scanlinescheck == nil {
            UserDefaults.standard.set(true, forKey: "Scanlines")
        }
        
        let scanlinescheck2 = UserDefaults.standard.bool(forKey: "Scanlines")
        if scanlinescheck2 == true {
            crt_mask.isHidden = false
        } else {
            crt_mask.isHidden = true
        }
        
        self.toggle_switch.image = NSImage(named: "switch_off")
        self.power_led.image = NSImage(named: "NSStatusUnavailable")
        UserDefaults.standard.set(false, forKey: "SwitchOn")
     }
    
    @IBAction func crt_look(_ sender: Any) {
        let scanlinescheck = UserDefaults.standard.bool(forKey: "Scanlines")
        if scanlinescheck == true {
            crt_mask.isHidden = false
        } else {
            crt_mask.isHidden = true
        }
    }
    
    @IBAction func toggle_switch(_ sender: Any) {
        let switchcheck = UserDefaults.standard.bool(forKey: "SwitchOn")
        
        let url = Bundle.main.url(forResource: "switch_sound", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        
        if switchcheck == false {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Startbutton"), object: nil, userInfo: ["name" : self.toggle_switch ?? ""])
            let switchcheck = UserDefaults.standard.bool(forKey: "SwitchOn")
            self.toggle_switch.image = NSImage(named: "switch_on")
            self.power_led.image = NSImage(named: "NSStatusAvailable")
            UserDefaults.standard.set(true, forKey: "SwitchOn")
            if switchcheck == false {
                player.play()
                self.crt_black_screen.isHidden = true
                self.container_view.isHidden = false
            }
        } else {
            player.play()
            self.power_led.image = NSImage(named: "NSStatusUnavailable")
            self.toggle_switch.image = NSImage(named: "switch_off")
            UserDefaults.standard.set(false, forKey: "SwitchOn")
            self.crt_black_screen.isHidden = false
            self.container_view.isHidden = true
            
        }
    }
    
    @IBAction func reset_button(_ sender: Any) {
        let url = Bundle.main.url(forResource: "click_sound", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
        let switchcheck = UserDefaults.standard.bool(forKey: "SwitchOn")
        if switchcheck == true {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Startbutton"), object: nil, userInfo: ["name" : self.toggle_switch ?? ""])
        }
    }
    
}
