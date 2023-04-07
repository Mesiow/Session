//
//  SessionCoreData.swift
//  Session
//
//  Created by Mesiow on 4/3/23.
//

import Foundation
import CoreData
import UIKit

struct CoreDataContext {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
}

extension SessionCollectionViewController {
    func saveSessionCollection() {
        do {
            try CoreDataContext.context.save();
        }catch {
            print("(Core data) Error saving session \(error)");
        }
    }
    
    func loadSessionCollection() {
        let request : NSFetchRequest<Session> = Session.fetchRequest();
        do{
            sessions = try CoreDataContext.context.fetch(request);
        }catch {
            print("(Core data) Error loading categories \(error)");
        }
    }
    
    func reloadSessionCollection(){
        loadSessionCollection();
        collectionView.reloadData();
    }
    
    func deleteSessionFromCollection(at indexPath: IndexPath){
        CoreDataContext.context.delete(sessions[indexPath.row]); //implicity saves the changes of deletion to core data
        reloadSessionCollection();
    }
    
}

extension SessionViewController {
    func saveSessionData() {
        do {
            try CoreDataContext.context.save();
        }catch {
            print("(Core data) Error saving session data \(error)");
        }
    }
}
