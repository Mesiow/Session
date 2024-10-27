//
//  ViewController.swift
//  Session
//
//  Created by Mesiow on 3/28/23.
//

import UIKit
import CoreData

struct Constants {
    static let cellReuseIdentifier = "ReusableSessionCell";
    static let cellNibName = "SessionCell"
}

class SessionCollectionViewController: UIViewController {
   
    @IBOutlet weak var collectionView: UICollectionView!

    var sessions : [Session] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        NotificationSystem.checkForPermission();
        
        setUpCollectionView();
        
        //load collection from core data
        loadSessionCollection();
        
        if let nc = navigationController {
            nc.navigationBar.tintColor = UIColor(hex: "0BBFF8");
        }
    }
    
    
    func setUpCollectionView(){
        //register our custom cell
        collectionView.register(SessionCell.self, forCellWithReuseIdentifier: Constants.cellReuseIdentifier);
        
        //set the delegates
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        let layout = UICollectionViewFlowLayout();
        layout.scrollDirection = .vertical;
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 1;
        
        collectionView.setCollectionViewLayout(layout, animated: true);
        collectionView.allowsSelection = true;
        collectionView.isScrollEnabled = true;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSession" {
            let destinationVC = segue.destination as! SessionViewController;
            let index = sender as! IndexPath;
            
            let session = sessions[index.row];
            destinationVC.session = session;
            destinationVC.index = index;
            destinationVC.delegate = self;
            
            print("preparing segue");
        }
    }
    
    @IBAction func newSessionPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField();
        let alert = UIAlertController(title: "Add new session", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add", style: .default) { [self]
            (action) in
            
            let newSession = Session(context: CoreDataContext.context);
            newSession.name = textField.text!;
            
            newSession.gradientFirstColor = UIColor.randomColor().toHex();
            newSession.gradientSecondColor =
                UIColor.randomColor().toHex();
            
            newSession.created = Date();
            newSession.active = false;
            newSession.totalSeconds = 0;
            
            self.sessions.append(newSession);
            self.insertSessionIntoCollection();
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default);
        
        
        alert.addTextField {
            (alertTextField) in
            alertTextField.autocapitalizationType = .sentences;
            alertTextField.placeholder = "Session Name"
            textField = alertTextField;
        }
        
       
        alert.addAction(action);
        alert.addAction(cancel);
       
        self.present(alert, animated: true, completion: nil);
    }
    
    func insertSessionIntoCollection(){
        //insert new item with fade in animation
        let insertedIndexPath = IndexPath(item: collectionView.numberOfItems(inSection: 0), section: 0);
            collectionView.insertItems(at: [insertedIndexPath]);
        
        saveSessionCollection();
    }
    
    func stopOtherActiveSessions(at indexPath: IndexPath){
        //when the user begins the timer on a new session we stop other sessions that may have been running elsewhere
        for i in 0..<sessions.count {
            if i != indexPath.row {
                let session = sessions[i];
                session.active = false;
            }
        }
        saveSessionCollection();
    }
}



//MARK: - Collection View data methods
extension SessionCollectionViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sessions.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellReuseIdentifier, for: indexPath) as! SessionCell;
        
       
        let color1 = UIColor(hex: sessions[indexPath.row].gradientFirstColor!)!;
        let color2 = UIColor(hex: sessions[indexPath.row].gradientSecondColor!)!;
        
        let gradients : [CGColor] = [color1.cgColor, color2.cgColor];
        
        cell.setBackgroundGradient(gradients);
        
        cell.title.text = sessions[indexPath.row].name;
        cell.hours.text = String(Int32(sessions[indexPath.row].totalSeconds / 3600)) + " hours";
    
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)

            //Animate cell selection
        UIView.animate(withDuration: 0.1,
                           animations: {
                        //Fade-out
                        cell?.alpha = 0.7
                        cell!.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { (completed) in
                UIView.animate(withDuration: 0.1,
                               animations: {
                        //Fade-in
                        cell?.alpha = 1
                        cell!.transform = CGAffineTransform(scaleX: 1, y: 1)
                    
                        self.performSegue(withIdentifier: "goToSession", sender: indexPath);
            })
        }
    }
}


extension SessionCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20.0, left: 10.0, bottom: 1.0, right: 10.0);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            //let layout = collectionViewLayout as! UICollectionViewFlowLayout;
            let widthPerItem = collectionView.frame.width /// 2 - layout.minimumInteritemSpacing;
           
            return CGSize(width: widthPerItem, height: 85)
    }
}


