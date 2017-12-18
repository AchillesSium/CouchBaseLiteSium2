//
//  ViewController.swift
//  CouchBaseLiteSium2
//
//  Created by MbProRetina on 12/12/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import UIKit
import CouchbaseLite

class ViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var addItemTextField: UITextField!
    
    @IBOutlet weak var numberOfItemTextField: UITextField!
    
    @IBOutlet weak var couChTableView: UITableView!
    
    
    var database: CBLDatabase!
    let inputs = Inputs()
    
    //MARK: - Initialization
    func useDatabase(database: CBLDatabase!) -> Bool {
        guard database != nil else {return false}
        self.database = database
        // Define a view with a map function that indexes to-do items by creation date:
        /*database.viewNamed("byDate").setMapBlock("2") {
         (doc, emit) in
         if let date = doc["created_at"] as? String {
         emit(date, doc)
         }
         }*/
        
        database.viewNamed("byDate").setMapBlock({ (doc, emit) in
            if let date = doc["created_at"] as? String {
                emit(date, doc)
                
            }
        }, reduce: nil, version: "2")
        
        database.viewNamed("byNum").setMapBlock({ (doc, emit) in
            if let num = doc["number"] as? String {
                
                
                emit(num, doc)
                
                
            }
        }, reduce: nil, version: "2")
        
        /*let view = database?.viewNamed("byNum")
         if view?.mapBlock == nil {
         view?.setMapBlock({ (doc, emit) in
         if let type: String = doc["number"] as? String{
         self.doc1 = type
         print(type)
         emit(type, nil)
         }
         },reduce: nil, version: "2")
         }*/
        
        /*database.viewNamed("byDate").setMapBlock(version: "2") { (doc, emit) in
         if let date = doc["created_at"] as? String {
         emit(date, doc)
         }
         }*/
        
        // ...and a validation function requiring parseable dates:
        database.setValidationNamed("created_at") {
            (newRevision, context) in
            if !newRevision.isDeletion,
                let date = newRevision.properties?["created_at"] as? String
                , NSDate.withJSONObject(jsonObj: date as AnyObject) == nil {
                context.reject(withMessage: "invalid date \(date)")
            }
        }
        return true
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addItemTextField.delegate = self
        self.numberOfItemTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        inputs.text = addItemTextField.text as AnyObject
        inputs.number = numberOfItemTextField.text as AnyObject
        
        
        // Database-related initialization:
        if useDatabase(database: appDelegate.database) {
            // Create a query sorted by descending date, i.e. newest items first:
            /*let query = database.viewNamed("byDate").createQuery().asLive()
             query.descending = true
             
             // Plug the query into the CBLUITableSource, which will use it to drive the table view.
             // (The CBLUITableSource uses KVO to observe the query's .rows property.)
             self.dataSource.query = query
             //docu = self.dataSource.labelProperty = "text"
             self.dataSource.labelProperty = "number"// Document property to display in the cell label*/
            
            let query2 = database.viewNamed("byNum").createQuery().asLive()
            query2.descending = true
           // self.dataSource.query = query2
          //  self.dataSource.labelProperty = "number"
            //print(docu)
        }
    }

    
    //TextField Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        addItemTextField.resignFirstResponder()
        numberOfItemTextField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if addItemTextField.text == "" {
            return
        }
        
        if numberOfItemTextField.text == "" {
            return
        }
        
        inputs.text = addItemTextField.text as AnyObject
        inputs.number = numberOfItemTextField.text as AnyObject
        
        addItemTextField.text = nil
        numberOfItemTextField.text = nil
        
        let properties: [String : AnyObject] = [
            "text": inputs.text as AnyObject,
            "number": inputs.number as AnyObject,
            "check": false as AnyObject,
            "created_at": CBLJSON.jsonObject(with: NSDate() as Date) as AnyObject
        ]
        
        // Save the document:
        let doc = database.createDocument()
        do {
            try doc.putProperties(properties)
            print("Database Created")
        } catch let error as NSError {
            print("jyfufgv")
            //self.appDelegate.showAlert(message: "Couldn't save new item", error)
            print("this is \(error)")
        }
        return
    }
    
    


    
    var appDelegate : AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

