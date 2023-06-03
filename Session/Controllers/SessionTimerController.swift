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
    
    var delegate : SessionViewController!;
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUi();
    }
    
    func setupUi() {
        delegate.setupButton(cancelButton, label: "Stop", color: UIColor.systemRed)
        delegate.setupButton(startButton, label: "Start", color: UIColor.systemGreen)
        
        cancelButton.isEnabled = false;
    }

}
