//
//  SessionViewController.swift
//  Session
//
//  Created by Mesiow on 3/31/23.
//

import UIKit

class SessionViewController: UIViewController {
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var sessionNameLabel: UILabel!
    @IBOutlet weak var sessionCreatedLabel: UILabel!
    
    var session : Session!;
    var timer = Timer();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton(stopButton, label: "Stop", color: UIColor.systemRed)
        setupButton(beginButton, label: "Begin", color: UIColor.systemGreen)
        
        stopButton.isEnabled = false;
        timeLabel.text = "00hr00m00s";
        
        print("view did load");
        
        sessionNameLabel.text = session.name;
        sessionCreatedLabel.text = session.created.formatted(date: .complete, time: .omitted);
    }
    
    private func setupButton(_ button : UIButton, label : String, color: UIColor) {
        button.setTitle(label, for: .normal);
        button.frame.size.width = 75.0;
        button.frame.size.height = 75.0
        button.layer.cornerRadius = 0.5 * button.bounds.size.width;
        button.clipsToBounds = true;
        button.tintColor = color;
    }
    
    
    @IBAction func stopButtonReleased(_ sender: UIButton) {
        beginButton.isEnabled = true;
        stopButton.isEnabled = false;
        
        session.secondsCounter = 0;
        timer.invalidate();
    }
    
    @IBAction func beginButtonReleased(_ sender: UIButton) {
        stopButton.isEnabled = true;
        beginButton.isEnabled = false;
        
        timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true);
    }
    
    @objc func timerCallback() -> Void {
        session.secondsCounter += 1;
        let time = secondsToHrMinSec(seconds: session.secondsCounter);
        let timeString = makeTimeString(hours: time.hour, min: time.min, sec: time.sec);
        
        timeLabel.text = timeString;
    }
    
    func secondsToHrMinSec(seconds : Int) -> (hour : Int, min : Int, sec: Int) {
        return ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60));
    }
    
    func makeTimeString(hours : Int, min : Int, sec : Int) -> String {
        var timeStr = "";
        timeStr += String(format: "%02d", hours);
        timeStr += "hr";
        timeStr += String(format: "%02d", min);
        timeStr += "m";
        timeStr += String(format: "%02d", sec);
        timeStr += "s";
        
        return timeStr;
    }
}
