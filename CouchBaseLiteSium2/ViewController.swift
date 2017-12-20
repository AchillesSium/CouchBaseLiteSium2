//
//  ViewController.swift
//  CouchBaseLiteSium2
//
//  Created by MbProRetina on 12/12/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import UIKit
import CouchbaseLite

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var addItemTextField: UITextField!
    
    @IBOutlet weak var numberOfItemTextField: UITextField!
    
    @IBOutlet weak var couChTableView: UITableView!
    
    
    
    
    var database: CBLDatabase!
    let inputs = Inputs()
    var parse = [datas]()
    var cell = CustomTableViewCell()
    var rowCount: Int!
    
   
    var liveQuery: CBLLiveQuery!
    var query: CBLQuery!
    
    var docsEnumerator: CBLQueryEnumerator? {
        didSet {
            self.couChTableView.reloadData()
        }
    }
    
    var normalQueryEnumerator: CBLQueryEnumerator? {
        didSet {
            self.couChTableView.reloadData()
        }
    }
   
    
    
    enum datas: String {
        case texts = "text"
        case nums = "number"
    }
    
    
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
        
        
        
        self.couChTableView.delegate = self
        self.couChTableView.dataSource = self
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
        
            query = database.viewNamed("byNum").createQuery().asLive()
            query.descending = true
            guard self.query != nil else {
                return
            }
            
            self.query.startKey = "2"
            self.query.endKey = "0"
            
            
            self.query?.limit = UInt(UINT32_MAX)
           // self.dataSource.query = query2
          //  self.dataSource.labelProperty = "number"
            //print(docu)
            //print(query2.rows)
            self.addNormalLiveQueryObserverAndStartObserving()
    
            self.query?.runAsync({ (enumerator, error) in
                switch error {
                case nil:
                    // 5: The "enumerator" is of type CBLQueryEnumerator and is an enumerator for the results
                    self.normalQueryEnumerator = enumerator
                    
                default:
                    //self.showAlertWithTitle(NSLocalizedString("Data Fetch Error!", comment: ""), message: error.localizedDescription)
                    print(error)
                }
            })
            
            
        }
       // getAllDocumentForUserDatabase()
        
    }
    
    
    func addNormalLiveQueryObserverAndStartObserving() {
        self.query.addObserver(self, forKeyPath: "rows", options: NSKeyValueObservingOptions.new, context: nil)
        
        do {
            try query.run()
        } catch {
            print(error)
        }
    }
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.couChTableView.reloadData()
    }
    
    
    
    
    func getAllDocumentForUserDatabase() {
        self.liveQuery = self.database?.createAllDocumentsQuery().asLive()
        
        guard self.liveQuery != nil else {
            return
        }
        
        // 2: You can optionally set a number of properties on the query object.
        // Explore other properties on the query object
        self.liveQuery?.limit = UInt(UINT32_MAX) // All documents
        
        //   query.postFilter =
        
        //3. Start observing for changes to the database
        self.addLiveQueryObserverAndStartObserving()
        
        
        // 4: Run the query to fetch documents asynchronously
        self.liveQuery?.runAsync({ (enumerator, error) in
            switch error {
            case nil:
                // 5: The "enumerator" is of type CBLQueryEnumerator and is an enumerator for the results
                self.docsEnumerator = enumerator
                print("fuffuguyg")
                print("live enumerator \(self.docsEnumerator)")
            default:
                //self.showAlertWithTitle(NSLocalizedString("Data Fetch Error!", comment: ""), message: error.localizedDescription)
                print(error)
            }
        })
    }
    
    func addLiveQueryObserverAndStartObserving(){
        
        self.liveQuery.addObserver(self, forKeyPath: "rows", options: NSKeyValueObservingOptions.new, context: nil)
    
       
        
    // 2. Start observing changes
         self.liveQuery.start()
        
        
        /*if keyPath == "rows" {
            self.docsEnumerator = self.liveQuery.rows
            couChTableView.reloadData()
        }*/
}
    //Table View delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.rowCount != nil {
            self.rowCount = self.rowCount + 1
        }
        
        
        return (Int(self.normalQueryEnumerator?.count ?? 0))
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        
        print("this is number of row \(String(describing: self.docsEnumerator?.count))")
        
        if let queryRow = normalQueryEnumerator?.row(at: UInt(indexPath.row)) {
            print ("row is \(String(describing: queryRow.document))")
            if let userProps = queryRow.document?.userProperties, let text = userProps[datas.texts.rawValue] as? String, let number = userProps[datas.nums.rawValue] as? String {
                self.rowCount = userProps.count
                cell.itemText.text = text
                cell.numberOfItemText.text = number
                print("this is index path \(indexPath.row)")
            }
        }
        return cell
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rows" {
            //self.docsEnumerator = self.liveQuery?.rows
            //self.normalQueryEnumerator = self.query.row
            self.query?.runAsync({ (enumerator, error) in
                switch error {
                case nil:
                    // 5: The "enumerator" is of type CBLQueryEnumerator and is an enumerator for the results
                    self.normalQueryEnumerator = enumerator
                    
                default:
                    //self.showAlertWithTitle(NSLocalizedString("Data Fetch Error!", comment: ""), message: error.localizedDescription)
                    print(error)
                }
            })
            self.couChTableView.reloadData()
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

        self.couChTableView.reloadData()
        return
    }
    
    


    
    var appDelegate : AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

