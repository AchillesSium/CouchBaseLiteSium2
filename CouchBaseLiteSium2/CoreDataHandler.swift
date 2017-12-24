//
//  CoreDataHandler.swift
//  CouchBaseLiteSium2
//
//  Created by MbProRetina on 24/12/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandler: NSObject {

    
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    
    func savedObjects(id: Int, name: String, age: Int){
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObject.setValue(id, forKey: "id")
        manageObject.setValue(name, forKey: "name")
        manageObject.setValue(age, forKey: "age")
        
        do {
            try context.save()
            
        } catch {
            print(error)
        }
    }
    
    func fetchID() -> [Person]? {
        let context = getContext()
        var person: [Person]? = nil
        do {
            person = try context.fetch(Person.fetchRequest())
            return person
        } catch  {
            return person
        }
    }
    
    
    func cleanCoreData() {
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest: Person.fetchRequest())
        do {
            try context.execute(delete)
        } catch {
            print(error)
        }
    }
}
