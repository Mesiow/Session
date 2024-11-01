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
    
    @IBOutlet weak var bottomNavBar: UINavigationBar!
    
    var session : Session!
    var timer = Timer();
    var cdTimer = Timer();
    var countdownTimerEnabled : Bool = false;
    
    var delegate : SessionCollectionViewController!
    var index : IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUi();
        updateTime();
        
        //setup notification callback to detect when app is being minimized
        let notificationCenter = NotificationCenter.default;
        notificationCenter.addObserver(self, selector: #selector(viewGoingIntoBackground), name: UIApplication.willResignActiveNotification, object: nil);
        
        notificationCenter.addObserver(self, selector: #selector(viewEnteringForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        resumeSessionIfActive();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("view dissappearing");
        stopSessionIfActive();
        delegate.collectionView.reloadData();
    }
    
    @objc private func viewGoingIntoBackground(){
        print("view going into background");
       stopSessionIfActive()
    }
    
    @objc private func viewEnteringForeground() {
        print("view entering foreground");
        resumeSessionIfActive();
    }

    
    func secondsToHrMinSec(seconds : Int32) -> (hour : Int32, min: Int32, sec: Int32) {
        return ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60));
    }
    
    private func setupUi() {
        //transluscent nav bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundImage = UIImage();
        appearance.backgroundColor = UIColor.clear;
        appearance.shadowImage = UIImage();
        appearance.shadowColor = UIColor.clear
        appearance.backgroundEffect = nil
        
        bottomNavBar.standardAppearance = appearance;
        
        setupButton(stopButton, label: "End", color: UIColor.systemRed)
        setupButton(beginButton, label: "Begin", color: UIColor.systemGreen)
        
        stopButton.isEnabled = false;
        
        sessionNameLabel.text = session.name;
        sessionNameLabel.textColor = UIColor(hex: session.gradientFirstColor!);
        sessionCreatedLabel.text = session.created!.formatted(date: .complete, time: .omitted);
    }
    
    func setupButton(_ button : UIButton, label : String, color: UIColor) {
        button.setTitle(label, for: .normal);
        button.frame.size.width = 75.0;
        button.frame.size.height = 75.0
        button.layer.cornerRadius = 0.5 * button.bounds.size.width;
        button.clipsToBounds = true;
        button.tintColor = color;
    }
    
   
    @IBAction func stopButtonReleased(_ sender: UIButton) {
        session.active = false;
        
        beginButton.isEnabled = true;
        stopButton.isEnabled = false;
        
        //save time to core data
        saveSessionData();
        
        timer.invalidate();
    }
    
    @IBAction func beginButtonReleased(_ sender: UIButton) {
        activate();
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Delete this session?", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Delete", style: .destructive) { [self]
            (action) in
            self.delegate.deleteSessionFromCollection(at: index);
            self.navigationController?.popViewController(animated: true);
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default);
    
    
        alert.addAction(action);
        alert.addAction(cancel);
       
        self.present(alert, animated: true, completion: nil);
        
    }
    
   
    @IBAction func timerButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToTimer", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToTimer" {
            let destination = segue.destination as! SessionTimerController;
            destination.delegate = self;
        }
    }
    
    
    func activate(){
        session.active = true;
        delegate.stopOtherActiveSessions(at: index);
        
        stopButton.isEnabled = true;
        beginButton.isEnabled = false;
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true);
    }
    
    func stopSessionIfActive(){
        if session.active {
            session.timeBackground = Date()
            
            saveSessionData();
            timer.invalidate();
        }
    }
    
    func resumeSessionIfActive(){
        if session.active {
            if let timeLeft = session.timeBackground {
                
                let curr = Date();
                let secdiff = Int(curr.timeIntervalSince1970 - timeLeft.timeIntervalSince1970)
                
                
                print("prev: \(session.totalSeconds)")
                print("difference: \(secdiff)");
             
                session.totalSeconds += Int32(secdiff);
                print("new: \(session.totalSeconds)")
            }
            activate();
        }
    }
    
    @objc func timerCallback() -> Void {
        session.totalSeconds += 1;
        updateTime();
    }
    
    func updateTime(){
        let time = secondsToHrMinSec(seconds: session.totalSeconds);
        let timeString = makeTimeString(hours: time.hour, min: time.min, sec: time.sec);
        
        timeLabel.text = timeString;
    }
    
    func makeTimeString(hours : Int32, min : Int32, sec : Int32) -> String {
        var timeStr = "";
        //String(hours);
        timeStr += String(hours) + "hr ";
        timeStr += String(min) + "m ";
        timeStr += String(sec) + "s ";
        /*timeStr += String(format: "%02d", hours);
        timeStr += "hr";
        timeStr += String(format: "%02d", min);
        timeStr += "m";
        timeStr += String(format: "%02d", sec);
        timeStr += "s";*/
        
        return timeStr;
    }
}
