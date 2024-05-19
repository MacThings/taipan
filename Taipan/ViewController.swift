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
    
    @IBOutlet var font_toggle_switch: NSSlider!

    @IBOutlet var language_toggle_switch: NSSlider!
    
    @IBOutlet weak var color_label: NSTextField!
    @IBOutlet var color_label_stepper: NSStepper!
    
    @IBOutlet weak var scanlines_led: NSImageView!
    @IBOutlet weak var scanlines_button: NSButton!
    
    
    @IBOutlet var harddisk_sfx_button: NSButton!
    
    @IBOutlet weak var harddisk_sfx_led: NSImageView!
    
    @IBOutlet weak var reset_button: NSButton!
    
    var player: AVAudioPlayer!
    var player2: AVAudioPlayer!
    var player3: AVAudioPlayer!
    var player4: AVAudioPlayer!
    var player5: AVAudioPlayer!
    var player6: AVAudioPlayer!
    
    let lc = Locale.current.languageCode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height);

        let fontcheck = UserDefaults.standard.string(forKey: "Font")
        if fontcheck == nil{
            UserDefaults.standard.set("1", forKey: "Font")
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
        let scanlinescheck = UserDefaults.standard.string(forKey: "Scanlines")
        if scanlinescheck == nil {
            UserDefaults.standard.set(true, forKey: "Scanlines")
        }
        
        let scanlinescheck2 = UserDefaults.standard.bool(forKey: "Scanlines")
        if scanlinescheck2 == true {
            crt_mask.isHidden = false
            self.scanlines_button.image = NSImage(named: "scanlines_on")
        } else {
            crt_mask.isHidden = true
            self.scanlines_button.image = NSImage(named: "scanlines_off")
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
        
        let harddiskfxscheck = UserDefaults.standard.string(forKey: "HarddiskSfx")
            if harddiskfxscheck == nil {
                UserDefaults.standard.set(false, forKey: "HarddiskSfx")
                harddisk_sfx_button.image = NSImage(named: "harddisk_sfx_off")
        }
        
        let harddiskfxscheck2 = UserDefaults.standard.bool(forKey: "HarddiskSfx")
            if harddiskfxscheck2 == true {
                harddisk_sfx_button.image = NSImage(named: "harddisk_sfx_on")
            } else {
                harddisk_sfx_button.image = NSImage(named: "harddisk_sfx_off")
            }
        
        self.toggle_switch.image = NSImage(named: "power_off")
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
            self.toggle_switch.image = NSImage(named: "power_on")
            self.power_led.image = NSImage(named: "NSStatusAvailable")
            //self.font_toggle_switch.isEnabled = false
            //self.language_toggle_switch.isEnabled = false
            //self.color_label_stepper.isEnabled = false
            UserDefaults.standard.set(true, forKey: "SwitchOn")
            if switchcheck == false {
                player.play()
                self.crt_black_screen.isHidden = true
                self.container_view.isHidden = false
            }
            let harddiskfxscheck = UserDefaults.standard.bool(forKey: "HarddiskSfx")
            if harddiskfxscheck == true {
                sound_hd_spin_up()
                startLoop()
            }
        } else {
            player.play()
            self.power_led.image = NSImage(named: "NSStatusUnavailable")
            self.toggle_switch.image = NSImage(named: "power_off")
            //self.font_toggle_switch.isEnabled = true
            //self.language_toggle_switch.isEnabled = true
            //self.color_label_stepper.isEnabled = true
            UserDefaults.standard.set(false, forKey: "SwitchOn")
            self.crt_black_screen.isHidden = false
            self.container_view.isHidden = true
            let harddiskfxscheck = UserDefaults.standard.bool(forKey: "HarddiskSfx")
            if harddiskfxscheck == true {
                sound_hd_spin_down()
            }
        }
    }
    
    @IBAction func font_switch(_ sender: Any) {
        sound_click()
    }

    @IBAction func language_toggle(_ sender: Any) {
        sound_click()
        let languagecheck = UserDefaults.standard.string(forKey: "Language")
        if languagecheck == "2" {
            print("nun de")
            UserDefaults.standard.set("2", forKey: "Language")
        } else {
            UserDefaults.standard.set("1", forKey: "Language")
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
            self.scanlines_button.image = NSImage(named: "scanlines_off")
        } else {
            UserDefaults.standard.set(true, forKey: "Scanlines")
            self.scanlines_button.image = NSImage(named: "scanlines_on")
        }
        let scanlinescheck2 = UserDefaults.standard.bool(forKey: "Scanlines")
        if scanlinescheck2 == true {
            crt_mask.isHidden = false
        } else {
            crt_mask.isHidden = true
        }
    }
    
    
    @IBAction func harddisk_sfx_button(_ sender: Any) {
        sound_click()
        let harddiskfxscheck = UserDefaults.standard.bool(forKey: "HarddiskSfx")
            if harddiskfxscheck == true {
                UserDefaults.standard.set(false, forKey: "HarddiskSfx")
                harddisk_sfx_button.image = NSImage(named: "harddisk_sfx_off")
                switch_off_hd_sound()
            } else {
                UserDefaults.standard.set(true, forKey: "HarddiskSfx")
                harddisk_sfx_button.image = NSImage(named: "harddisk_sfx_on")
                switch_on_hd_sound()
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
        player5?.stop()
        let url = Bundle.main.url(forResource: "hd_start", withExtension: "m4a")
        player4 = try! AVAudioPlayer(contentsOf: url!)
        player4?.play()
        
        // Preloading der sound_hd_running Funktion
        preloadSound_hd_running()
    }

    func sound_hd_running() {
        player5?.play()
    }

    // Preloading der sound_hd_running Funktion
    func preloadSound_hd_running() {
        let url = Bundle.main.url(forResource: "hd_running", withExtension: "m4a")
        player5 = try! AVAudioPlayer(contentsOf: url!)
        player5?.prepareToPlay()
    }

    // Schleife für wiederholtes Abspielen der sound_hd_running Funktion
    func startLoop() {
        // Starte einen Timer, der nach 116 Sekunden abläuft
        DispatchQueue.global().asyncAfter(deadline: .now() + 73) {
            // Starte die Schleife nach Ablauf des Timers
            DispatchQueue.global().async {
                while true {
                    // Warte für eine Weile, bevor die Funktion wieder aufgerufen wird
                    Thread.sleep(forTimeInterval: 43) // Ändere die Zeitintervall nach Bedarf
                    
                    // Führe die Funktion im Hauptthread aus, um Änderungen an der Benutzeroberfläche durchzuführen
                    DispatchQueue.main.async {
                        self.sound_hd_running()
                    }
                }
            }
        }
    }

    func sound_hd_spin_down() {
        player4.stop()
        player5.stop()
        player4.currentTime = 0
        player5.currentTime = 0
        let url = Bundle.main.url(forResource: "hd_stop", withExtension: "m4a")
        player6 = try! AVAudioPlayer(contentsOf: url!)
        player6.play()
    }
    
    func switch_off_hd_sound() {
        if let player4 = player4 {
            player4.stop()
        } else {
            print("player4 ist nicht verfügbar.")
        }
        
        if let player5 = player5 {
            player5.stop()
        } else {
            print("player5 ist nicht verfügbar.")
        }
    }

    func switch_on_hd_sound() {
        if let player4 = player4 {
            let harddiskfxscheck = UserDefaults.standard.bool(forKey: "HarddiskSfx")
            if harddiskfxscheck == true {
                sound_hd_spin_up()
                startLoop()
                player4.play()

            }
            } else {
                print("player4 ist nicht verfügbar.")
            }
            
            if let player5 = player5 {
                let harddiskfxscheck = UserDefaults.standard.bool(forKey: "HarddiskSfx")
                if harddiskfxscheck == true {
                    player5.play()
                }
            } else {
                print("player5 ist nicht verfügbar.")
            }
    }
    
}
