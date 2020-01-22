//
//  Walk.swift
//  stopwatch
//
//  Created by Wittmayer,Jack T on 1/6/20.
//  Copyright © 2020 Jack Wittmayer. All rights reserved.
//

import UIKit
import os.log

class Walk: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    //var photo: UIImage?
    var time: Double
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("walks")
    //MARK: Types
    
    struct PropertyKey
    {
        static let name = "name"
        //static let photo = "photo"
        static let time = "time"
    }
    //MARK: Initialization
    
    init?(name: String, time: Double)
    {
        //Make sure walk has a name and nonnegative time
        if name.isEmpty || time < 0
        {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        //self.photo = photo
        self.time = time
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        //aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(time, forKey: PropertyKey.time)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we canot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
        else
        {
            os_log("Unable to decode the name for a Walk object.", log: OSLog.default, type: .debug)
            return nil
        }
        // Because photo is an optional property of Walk, just use conditional cast.
        //let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let time = aDecoder.decodeDouble(forKey: PropertyKey.time)
        
        // Must call designated initializer.
        self.init(name: name, time: time)
    }
}
