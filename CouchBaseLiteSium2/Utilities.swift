//
//  Utilities.swift
//  CouchBaseLiteSium2
//
//  Created by MbProRetina on 18/12/17.
//  Copyright © 2017 MbProRetina. All rights reserved.
//

import Foundation
import CouchbaseLite


extension CBLView {
    // Just reorders the parameters to take advantage of Swift's trailing-block syntax.
    func setMapBlock(version: String, mapBlock: @escaping CBLMapBlock) -> Bool {
        return setMapBlock(mapBlock, version: version)
    }
}



extension NSDate {
    class func withJSONObject(jsonObj: AnyObject) -> NSDate? {
        return CBLJSON.date(withJSONObject: jsonObj)! as NSDate
    }
}
