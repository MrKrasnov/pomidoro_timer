//
//  ViewController.swift
//  Pomidoro Timer
//
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var textHint: NSTextField!
    @IBOutlet weak var inputMinutes: NSTextField!
    
    @IBOutlet weak var pauseBtn: NSButton!
    @IBOutlet weak var stopBtn: NSButton!
    @IBOutlet weak var playBtn: NSButton!
    @IBOutlet weak var resetBtn: NSButton!
    
    @IBOutlet weak var timerRecords: NSStackView!
    
    let minimumRequiredMinutes: Int = 1
    let maximumRequiredMinutes: Int = 120
    
    var initialMinutes: Int = 0
    var remainingSeconds: Int = 0
    var timer: Timer?
    var isPause: Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func playBtnEvent(_ sender: Any) {
        if isPause {
            isPause = false
            pauseBtn.isEnabled = true;
            playBtn.isEnabled  = false;
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(doStepTimer), userInfo: nil, repeats: true)
            return;
        }
        
        let inputMinutesValue: String = inputMinutes.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !inputMinutesValue.isEmpty else {
            textHint.stringValue = "input блок с минутами пустой!"
            return
        }
    
        guard let minutes:Int = Int(inputMinutesValue) else {
            textHint.stringValue = "input блок должен содержать только цифры!"
            return
        }
        
        guard minutes >= minimumRequiredMinutes && minutes <= maximumRequiredMinutes else {
            textHint.stringValue = "в input минимально допустимое число \(minimumRequiredMinutes) и максимально \(maximumRequiredMinutes)!"
            return
        }

        initialMinutes       = minutes
        textHint.stringValue = "Включили таймер"
        
        playBtn.isEnabled  = false;
        inputMinutes.isEnabled = false;
        stopBtn.isEnabled  = true;
        pauseBtn.isEnabled = true;
        
       remainingSeconds = minutes * 60
       timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(doStepTimer), userInfo: nil, repeats: true)
    }
    
    @IBAction func resetBtnEvent(_ sender: Any) {
        if isPause {
            isPause = false
            stopBtn.isEnabled    = false;
            inputMinutes.isEnabled = true;
        }
        
        remainingSeconds = 0
        textHint.stringValue = ""
        resetBtn.isEnabled = false
        timerRecords.subviews.forEach { $0.removeFromSuperview() }
    }
    
    @IBAction func stopBtnEvent(_ sender: Any) {
        let remainingMinutes: Int = remainingSeconds / 60;
        initialMinutes   = initialMinutes - remainingMinutes;
        remainingSeconds = 0;
        
        if isPause {
            isPause = false
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(doStepTimer), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func pauseBtnEvent(_ sender: Any) {
        isPause = true
        pauseBtn.isEnabled  = false;
        playBtn.isEnabled  = true;
        timer?.invalidate()
    }
    
    
    @objc func doStepTimer(){
        
        if(remainingSeconds > 0) {
            remainingSeconds -= 1
            textHint.stringValue = updateTextHint();
        } else {
            stopTimer()
        }
        
    }
    
    private func updateTextHint() -> String {
        let hours = remainingSeconds / 3600
        let minutes = (remainingSeconds % 3600) / 60
        let seconds = remainingSeconds % 60

        let timeString = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        return "Осталось времени: \(timeString)"
    }
    
    private func stopTimer() {
        textHint.stringValue = "Таймер завершил работу!";
        
        pauseBtn.isEnabled = false;
        stopBtn.isEnabled = false;
        playBtn.isEnabled = true;
        inputMinutes.isEnabled = true;
        resetBtn.isEnabled = true;
        
        let label = NSTextField(labelWithString: "- Завершен таймер длинной в \(initialMinutes) минут")
        timerRecords.addArrangedSubview(label)
        
        timer?.invalidate()
    }
    
}
