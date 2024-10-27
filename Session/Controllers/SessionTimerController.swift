//
//  SessionTimerController.swift
//  Session
//
//  Created by Mesiow on 6/3/23.
//

import UIKit

class SessionTimerController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var picker: UIDatePicker!
    
    @IBOutlet weak var countdownView: UIView!
    @IBOutlet weak var countdownLabel: UILabel!
    
    var delegate : SessionViewController!
    var cdTimer = Timer();
    var countdown : Int32 = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUi();
    }
    
    func setupUi() {
        countdownView.isHidden = true;
        
        delegate.setupButton(cancelButton, label: "Stop", color: UIColor.systemRed)
        delegate.setupButton(startButton, label: "Start", color: UIColor.systemGreen)
        
        cancelButton.isEnabled = false;
    }
    
    func enableCountdownView(){
        picker.isHidden = true;
        countdownView.isHidden = false;
        
        refreshTime();
    }
    
    func disableCountdownView(){
        picker.isHidden = false;
        countdownView.isHidden = true;
    }
    
    func end(){
        disableCountdownView();
        
        cancelButton.isEnabled = false;
        startButton.isEnabled = true;
        
        //renable back button
        if let nav = navigationController {
            nav.navigationBar.isUserInteractionEnabled = true;
            nav.navigationBar.tintColor = UIColor.systemTeal
        }
        
        
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        countDownTimerEnded();
    }
    
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        //disable going back to previous view while the countdown timer is running
        if let nav = navigationController {
            nav.navigationBar.isUserInteractionEnabled = false
            nav.navigationBar.tintColor = UIColor.lightGray
        }
       
        cancelButton.isEnabled = true;
        startButton.isEnabled = false;
        
        countdown = Int32(picker.countDownDuration);
        countDownTimerStarted()
        
        enableCountdownView();
    }
    
    //Countdown
    func countDownTimerStarted() {
        cdTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDownTimerUpdate), userInfo: nil, repeats: true);
        
        NotificationSystem.dispatchNotification(sessionName: delegate.session.name!, countdown)
    }
    
    func countDownTimerEnded() {
        cdTimer.invalidate();
        countdown = 0;
        
        end();
    }
    
    func refreshTime(){
        let time = delegate.secondsToHrMinSec(seconds: countdown);
        let str = delegate.makeTimeString(hours: time.hour, min: time.min, sec: time.sec);
        
        countdownLabel.text = str;
    }
    
    @objc func countDownTimerUpdate() {
        countdown -= 1;
        refreshTime();
        
        if countdown <= 0 {
            countDownTimerEnded();
        }
    }
}
