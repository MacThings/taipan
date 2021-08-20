//
//  Copyright © 2021 Sascha Lamprecht. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {

    @IBOutlet weak var taipan_header: NSTextField!
    @IBOutlet weak var crt_mask: NSImageView!
    @IBOutlet weak var crt_black_screen: NSBox!
    @IBOutlet weak var container_view: NSView!

    @IBOutlet weak var power_led: NSImageView!
    @IBOutlet weak var toggle_switch: NSButton!
    
    @IBOutlet weak var font_toggle_switch: NSButton!

    @IBOutlet weak var language_toggle_switch: NSButton!
    
    @IBOutlet weak var color_label: NSTextField!
    
    @IBOutlet weak var scanlines_led: NSImageView!
    @IBOutlet weak var scanlines_button: NSButton!

    @IBOutlet weak var reset_button: NSButton!
    
    var player: AVAudioPlayer!
    var player2: AVAudioPlayer!
    var player3: AVAudioPlayer!
    var player4: AVAudioPlayer!
    var player5: AVAudioPlayer!
    
    let lc = Locale.current.languageCode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height);

        let fontcheck = UserDefaults.standard.string(forKey: "Font")
        if fontcheck == nil{
            UserDefaults.standard.set("Taipan", forKey: "Font")
        }
        
        let colorsteppercheck = UserDefaults.standard.string(forKey: "ColorStepper")
        if colorsteppercheck == nil{
            UserDefaults.standard.set("1", forKey: "ColorStepper")
        }
        
        let colorcheck = UserDefaults.standard.string(forKey: "Color")
        if colorcheck == nil{
            if lc == "de"{
                UserDefaults.standard.set("Grün", forKey: "Color")
            } else {
            UserDefaults.standard.set("Green", forKey: "Color")
            }
        }
        
        let colorcheck2 = UserDefaults.standard.string(forKey: "ColorStepper")
        if colorcheck2 == nil{
        UserDefaults.standard.set("1", forKey: "ColorStepper")
        UserDefaults.standard.set("Green", forKey: "Color")
            if lc == "de"{
                UserDefaults.standard.set("Grün", forKey: "Color")
            }
        }
        
        let speedcheck = UserDefaults.standard.string(forKey: "Speed")
        if speedcheck == nil{
            UserDefaults.standard.set("1", forKey: "Speed")
        }
        let languagecheck = UserDefaults.standard.string(forKey: "Language")
        if languagecheck == nil{
            UserDefaults.standard.set("English", forKey: "Language")
            self.language_toggle_switch.image = NSImage(named: "switch_45_2")
        }
        let scanlinescheck = UserDefaults.standard.string(forKey: "Scanlines")
        if scanlinescheck == nil {
            UserDefaults.standard.set(true, forKey: "Scanlines")
        }
        
        let scanlinescheck2 = UserDefaults.standard.bool(forKey: "Scanlines")
        if scanlinescheck2 == true {
            crt_mask.isHidden = false
            scanlines_led.image = NSImage(named: "NSStatusAvailable")
        } else {
            crt_mask.isHidden = true
            scanlines_led.image = NSImage(named: "NSStatusUnavailable")
        }
        
        let fontcheck2 = UserDefaults.standard.string(forKey: "Font")
        if fontcheck2 == "Taipan" {
            self.font_toggle_switch.image = NSImage(named: "switch_45_2")
        } else {
            self.font_toggle_switch.image = NSImage(named: "switch_45_1")
        }
        
        let languagecheck2 = UserDefaults.standard.string(forKey: "Language")
        if languagecheck2 == "English" {
            self.language_toggle_switch.image = NSImage(named: "switch_45_2")
        } else {
            self.language_toggle_switch.image = NSImage(named: "switch_45_1")
        }
        
        if colorcheck2 == "6"{
        UserDefaults.standard.set("Green", forKey: "Color")
            if lc == "de"{
                UserDefaults.standard.set("Grün", forKey: "Color")
            }
        }
        if colorcheck2 == "5"{
        UserDefaults.standard.set("Green inv.", forKey: "Color")
            if lc == "de"{
                UserDefaults.standard.set("Grün inv.", forKey: "Color")
            }
        }
        if colorcheck2 == "4"{
        UserDefaults.standard.set("Amber", forKey: "Color")
            if lc == "de"{
                UserDefaults.standard.set("Bernstein", forKey: "Color")
            }
        }
        if colorcheck2 == "3"{
        UserDefaults.standard.set("Amber inv.", forKey: "Color")
            if lc == "de"{
                UserDefaults.standard.set("Bernstein inv.", forKey: "Color")
            }
        }
        if colorcheck2 == "2"{
        UserDefaults.standard.set("B/W", forKey: "Color")
            if lc == "de"{
                UserDefaults.standard.set("S/W", forKey: "Color")
            }
        }
        if colorcheck2 == "1"{
        UserDefaults.standard.set("B/W inv.", forKey: "Color")
            if lc == "de"{
                UserDefaults.standard.set("S/W inv.", forKey: "Color")
            }
        }
        
        self.toggle_switch.image = NSImage(named: "switch_off")
        self.font_toggle_switch.image = NSImage(named: "switch_45_2")
        self.power_led.image = NSImage(named: "NSStatusUnavailable")
        UserDefaults.standard.set(false, forKey: "SwitchOn")
     }
    
    @IBAction func toggle_switch(_ sender: Any) {
        let switchcheck = UserDefaults.standard.bool(forKey: "SwitchOn")
        let url = Bundle.main.url(forResource: "switch_sound", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        
        if switchcheck == false {
            sound_crt_switch_on()
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
            //sound_hd_spin_up()
            
            //DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(8695)) {
                //self.sound_hd_running()
            //}
        } else {
            player.play()
            self.power_led.image = NSImage(named: "NSStatusUnavailable")
            self.toggle_switch.image = NSImage(named: "switch_off")
            UserDefaults.standard.set(false, forKey: "SwitchOn")
            self.crt_black_screen.isHidden = false
            self.container_view.isHidden = true
            //sound_hd_spin_down()
            
        }
    }
    
    @IBAction func font_switch(_ sender: Any) {
        sound_click()
        let fontcheck = UserDefaults.standard.string(forKey: "Font")
        if fontcheck == "Taipan" {
            self.font_toggle_switch.image = NSImage(named: "switch_45_1")
            UserDefaults.standard.set("System", forKey: "Font")
        } else {
            self.font_toggle_switch.image = NSImage(named: "switch_45_2")
            UserDefaults.standard.set("Taipan", forKey: "Font")
        }
        
    }

    @IBAction func language_toggle(_ sender: Any) {
        sound_click()
        let languagecheck = UserDefaults.standard.string(forKey: "Language")
        if languagecheck == "English" {
            print("nun de")
            self.language_toggle_switch.image = NSImage(named: "switch_45_1")
            UserDefaults.standard.set("German", forKey: "Language")
        } else {
            self.language_toggle_switch.image = NSImage(named: "switch_45_2")
            UserDefaults.standard.set("English", forKey: "Language")
            print("nun en")
        }
        
    }
    
    
    @IBAction func color_selector(_ sender: Any) {
        let colorcheck = UserDefaults.standard.string(forKey: "ColorStepper")
        if colorcheck == "6"{
        UserDefaults.standard.set("Green", forKey: "Color")
            if lc == "de"{
                UserDefaults.standard.set("Grün", forKey: "Color")
            }
        }
        if colorcheck == "5"{
        UserDefaults.standard.set("Green inv.", forKey: "Color")
            if lc == "de"{
                UserDefaults.standard.set("Grün inv.", forKey: "Color")
            }
        }
        if colorcheck == "4"{
        UserDefaults.standard.set("Amber", forKey: "Color")
            if lc == "de"{
                UserDefaults.standard.set("Bernstein", forKey: "Color")
            }
        }
        if colorcheck == "3"{
        UserDefaults.standard.set("Amber inv.", forKey: "Color")
            if lc == "de"{
                UserDefaults.standard.set("Bernstein inv.", forKey: "Color")
            }
        }
        if colorcheck == "2"{
        UserDefaults.standard.set("B/W", forKey: "Color")
            if lc == "de"{
                UserDefaults.standard.set("S/W", forKey: "Color")
            }
        }
        if colorcheck == "1"{
        UserDefaults.standard.set("B/W inv.", forKey: "Color")
            if lc == "de"{
                UserDefaults.standard.set("S/W inv.", forKey: "Color")
            }
        }
    }
    
    
    @IBAction func scanlines_button(_ sender: Any) {
        sound_click()
        let scanlinescheck = UserDefaults.standard.bool(forKey: "Scanlines")
        if scanlinescheck == true {
            UserDefaults.standard.set(false, forKey: "Scanlines")
            scanlines_led.image = NSImage(named: "NSStatusUnavailable")
        } else {
            UserDefaults.standard.set(true, forKey: "Scanlines")
            scanlines_led.image = NSImage(named: "NSStatusAvailable")
        }
        let scanlinescheck2 = UserDefaults.standard.bool(forKey: "Scanlines")
        if scanlinescheck2 == true {
            crt_mask.isHidden = false
        } else {
            crt_mask.isHidden = true
        }
    }
    
    @IBAction func reset_button(_ sender: Any) {
        sound_click()
        let switchcheck = UserDefaults.standard.bool(forKey: "SwitchOn")
        if switchcheck == true {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Startbutton"), object: nil, userInfo: ["name" : self.toggle_switch ?? ""])
        }
    }
    
    
    
    func sound_click() {
        let url = Bundle.main.url(forResource: "click_sound", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
  
    func sound_crt_switch_on() {
        let url = Bundle.main.url(forResource: "crt_switch_on", withExtension: "mp3")
        player3 = try! AVAudioPlayer(contentsOf: url!)
        player3.play()
    }
   
    func sound_hd_spin_up() {
        let url = Bundle.main.url(forResource: "hd_spin_up", withExtension: "mp3")
        player4 = try! AVAudioPlayer(contentsOf: url!)
        player4.play()
    }
    func sound_hd_running() {
        let url = Bundle.main.url(forResource: "hd_running", withExtension: "mp3")
        player4 = try! AVAudioPlayer(contentsOf: url!)
        player4.play()
    }
    
    func sound_hd_spin_down() {
        let url = Bundle.main.url(forResource: "hd_spin_down", withExtension: "mp3")
        player4 = try! AVAudioPlayer(contentsOf: url!)
        player4.play()
    }
    
}
