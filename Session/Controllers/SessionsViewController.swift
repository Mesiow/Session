//
//  ViewController.swift
//  Session
//
//  Created by Mesiow on 3/28/23.
//

import UIKit

struct Constants {
    static let cellReuseIdentifier = "ReusableSessionCell";
    static let cellNibName = "SessionCell"
}

struct Session {
    var name : String!
    var color : UIColor!
    var created = Date();
    var minutes : Int = 0;
    var hours : Int = 0;
    var seconds : Int = 0;
    var secondsCounter : Int = 0;
}

class SessionsViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var sessions : [Session] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView();
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
        layout.minimumInteritemSpacing = 4;
        
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
            print("preparing segue");
        }
    }
    
    @IBAction func newSessionPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField();
        let alert = UIAlertController(title: "Add new session", message: "", preferredStyle: .alert);
        
        let action = UIAlertAction(title: "Add", style: .default) { [self]
            (action) in
            var newSession = Session();
            newSession.name = textField.text!;
            newSession.color = UIColor.randomColor();
            
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
    }
}



//MARK: - Collection View data methods
extension SessionsViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sessions.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellReuseIdentifier, for: indexPath) as! SessionCell;
        
        cell.title.text = sessions[indexPath.row].name;
        cell.setBackgroundColor(sessions[indexPath.row].color);
        
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


extension SessionsViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        print("inset set");
        return UIEdgeInsets(top: 20.0, left: 10.0, bottom: 1.0, right: 10.0);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let layout = collectionViewLayout as! UICollectionViewFlowLayout;
            let widthPerItem = collectionView.frame.width / 2 - layout.minimumInteritemSpacing;
           
            return CGSize(width: widthPerItem - 10, height: 85)
    }
}


