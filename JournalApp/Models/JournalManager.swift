//
//  JournalManager.swift
//  JournalApp
//
//  Created by Santo Michael Sihombing on 27/06/21.
//

import CoreData
import UIKit

struct JournalModel {
    private var id              : Int64
    private var title           : String
    private var description     : String
    private var createDate      : Date
    private var lastUpdateDate  : Date
    private var puzzle1Detail1  : String
    private var puzzle1Detail2  : String
    private var puzzle1Detail3  : String
    private var puzzle1Detail4  : String
}

class JournalManager{
    
    //MARK: - LOCAL PROPERTIES
    var managedObjectContext                                        = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    
    //MARK: - Create new journal
    static func create(title: String, details: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let entity = NSEntityDescription.entity(forEntityName: "Journal", in: managedContext)!

        do {
            let newJournal = NSManagedObject(entity: entity, insertInto: managedContext)
            newJournal.setValue(JournalManager.generateId(), forKey: "id")
            newJournal.setValue(title, forKey: "title")
            newJournal.setValue(details, forKey: "puzzle1Detail")
            newJournal.setValue(NSDate.now, forKey: "createDate")
            newJournal.setValue(NSDate.now, forKey: "lastUpdateDate")
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: - Read all data
    static func read() -> Array<Any>{
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return []}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Journal")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            return result
            
        } catch {
            
            print("Failed")
            return []
        }
    }
    
    //MARK: - Read specific data by ID
    static func read(id: Int64) -> Any {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return []}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Journal")
        
        fetchRequest.fetchLimit = 1
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "id", ascending: false)]
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            return result
            
        } catch {
            print("Failed")
            
            return []
        }
    }
    
    //MARK: - Update Journal - Title and Details
    static func updateJournal(id: Int64, title: String, detail: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "id")
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = test[0] as! NSManagedObject
            
            objectUpdate.setValue(title, forKey: title)
            
            objectUpdate.setValue(detail, forKey: detail)
            
            do{
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    //MARK: - Update Making Connections - Details of connection
    static func updateMakingConnections(id: Int64, key: String, detail: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "id")
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = test[0] as! NSManagedObject
            
            objectUpdate.setValue(detail, forKey: key)
            
            do{
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    //MARK: - Delete journal by ID
    static func delete(id: Int64) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "id")
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            
            managedContext.delete(objectToDelete)
            
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
            
        } catch {
            print(error)
        }
    }
    
    //MARK: - generate ID
    static func generateId() -> Int64 {
        if JournalManager.read().count == 0 {
            return 1
            
        } else {
            let journals = JournalManager.read().last as! NSManagedObject
            
            let lastId = journals.value(forKey: "id") as! Int
            
            return Int64(lastId + 1)
            
        }
    }
}
