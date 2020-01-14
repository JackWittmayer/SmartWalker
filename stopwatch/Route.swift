//
//  Route.swift
//  stopwatch
//
//  Created by Wittmayer,Jack T on 1/12/20.
//  Copyright © 2020 Jack Wittmayer. All rights reserved.
//

import UIKit
import os.log

class Route: NSObject, NSCoding {
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var start: String
    var end: String
    var walks: [Walk]?
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("routes")
    
    //MARK: Types
    
    struct PropertyKey
    {
        static let name = "name"
        static let photo = "photo"
        static let start = "start"
        static let end = "end"
        static let walks = "walks"
    }
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, start: String, end: String, walks: [Walk])
    {
        //Make sure route has a name, start, and end
        if name.isEmpty || start.isEmpty || end.isEmpty
        {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.start = start
        self.end = end
        self.walks = walks
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(start, forKey: PropertyKey.start)
        aCoder.encode(end, forKey: PropertyKey.end)
        aCoder.encode(walks, forKey: PropertyKey.walks)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we canot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
        else
        {
            os_log("Unable to decode the name for a Route object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let start = aDecoder.decodeObject(forKey: PropertyKey.start) as? String
        else
        {
            os_log("Unable to decode the start for a Route object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let end = aDecoder.decodeObject(forKey: PropertyKey.end) as? String
        else
        {
            os_log("Unable to decode the end for a Route object.", log: OSLog.default, type: .debug)
            return nil
        }
        // Because photo is an optional property of Route, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let walks = aDecoder.decodeObject(forKey: PropertyKey.walks) as? [Walk]
        // Must call designated initializer.
        self.init(name: name, photo: photo, start: start, end: end, walks: walks ?? [Walk]())
    }
}
