//
//  DBManager.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 3/30/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit
//import sqlite3

class DBManager: NSObject {

    var documentsDirectory:String = ""
    var databaseFilename:String = ""
    
    var arrColumnNames:[String] = []
    var arrResults:[String] = []
    var affectedRows:Int = 0
    var lastInsertedRowID: CLong = 0
    
    init (dbFilename:String) {
        
        super.init()
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        documentsDirectory = String.init(describing: paths[0])
        
        databaseFilename = dbFilename
        
        self.copyDatabaseIntoDocumentsDirectory()
    }
    
    func copyDatabaseIntoDocumentsDirectory() {
        let destinationPath = documentsDirectory.appending(databaseFilename)
        
        if (!FileManager.default.fileExists(atPath: destinationPath)) {
            let sourcepath = Bundle.main.resourcePath?.appending(databaseFilename)
            do {
                try FileManager.default.copyItem(atPath: sourcepath!, toPath: destinationPath)
            }
            catch {
                print("Something wrong")
            }
        }
    }
    
    func runQuery(query:String, queryExecutable:Bool) {
        print("Doing")
        //(query as NSString).utf8String
        
        // Create a sqlite object.
        //var sqlite3Database:sqlite3
        
        let databasePath = documentsDirectory.appending(self.databaseFilename)
        
        var sqlite3Database: OpaquePointer? = nil
        
        if sqlite3_open(databasePath, &sqlite3Database) != SQLITE_OK {
            print("error opening database")
        }
    }
        //:(const char *)query isQueryExecutable:(BOOL)queryExecutable;
    
    
    
}
