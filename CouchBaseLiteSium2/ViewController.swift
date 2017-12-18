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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addItemTextField.delegate = self
        self.numberOfItemTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
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
        
       /* let properties: [String : AnyObject] = [
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
        }*/
        return
    }
    
    


    
    var appDelegate : AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

