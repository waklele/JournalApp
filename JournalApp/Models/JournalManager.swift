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

struct Response {
    
    static func success() -> Dictionary<String, Any> {
        return [
            "success" : true
        ]
    }
    
    static func success(data: Any) -> Dictionary<String, Any> {
        return [
            "success" : true,
            "data" : data
        ]
    }
    
    static func error(error: Any) -> Dictionary<String, Any> {
        return [
            "success" : false,
            "error" : error
        ]
    }
}

class JournalManager{
    
    //MARK: - LOCAL PROPERTIES
    var managedObjectContext                                        = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    //MARK: - Create new journal
    static func create(title: String, details: String) -> Dictionary<String, Any> {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [:]}
        
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
            return Response.success()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return Response.error(error: error)
        }
    }
    
    //MARK: - Read all data
    static func read() -> Dictionary<String, Any> {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [:]}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Journal")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            return Response.success(data: result)
            
        } catch {
            
            print("Failed")
            return Response.error(error: error)
        }
    }
    
    //MARK: - Read specific data by ID
    static func read(id: Int64) -> Dictionary<String, Any>  {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [:]}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Journal")
        
        fetchRequest.fetchLimit = 1
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "id", ascending: false)]
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            return Response.success(data: result)
            
        } catch {
            print("Failed")
            
            return Response.error(error: error)
        }
    }
    
    //MARK: - Update Journal - Title and Details
    static func updateJournal(id: Int64, title: String, detail: String) -> Dictionary<String, Any>  {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [:] }
        
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
                return Response.success()
            } catch {
                print(error)
                return Response.error(error: error)
            }
        } catch {
            print(error)
            return Response.error(error: error)
        }
    }
    
    //MARK: - Update Making Connections - Details of connection
    static func updateMakingConnections(id: Int64, key: String, detail: String) -> Dictionary<String, Any> {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [:] }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Journal")
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = test[0] as! NSManagedObject
            
            objectUpdate.setValue(detail, forKey: key)
            
            do{
                try managedContext.save()
                return Response.success()
            } catch {
                print(error)
                return Response.error(error: error)
            }
        } catch {
            print(error)
            return Response.error(error: error)
        }
    }
    
    //MARK: - Delete journal by ID
    static func delete(id: Int64) -> Dictionary<String, Any> {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [:] }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "id")
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            
            managedContext.delete(objectToDelete)
            
            do {
                try managedContext.save()
                return Response.success()
            } catch {
                print(error)
                return Response.error(error: error)
            }
            
        } catch {
            print(error)
            return Response.error(error: error)
        }
    }
    
    //MARK: - generate ID
    static func generateId() -> Int64 {
        
        let journals = JournalManager.read()["data"] as! [NSManagedObject]
        
        if journals.count == 0 {
            return 1
            
        } else {
            var ids: [Int64] = []
            for data in journals {
                ids.append(data.value(forKey: "id") as! Int64)
            }
            
            let max = ids.max()!

            return Int64(max + 1)
        }
    }
}
