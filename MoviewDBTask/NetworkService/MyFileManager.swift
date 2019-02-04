//
//  FileManager.swift
//  MoviewDBTask
//
//  Created by Asim Karel on 04/02/19.
//  Copyright © 2019 Asim. All rights reserved.
//

import Foundation
class MyFileManager{
    
    private static var _instance:MyFileManager!;
    let fileManager = FileManager.default
    
    public static func sharedInstance() -> MyFileManager{
        
        if(_instance == nil){
            _instance = MyFileManager();
        }
        return self._instance;
    }
    
    private init(){}
    
    public func fileExists(path:String) -> Bool{
        return fileManager.fileExists(atPath:path);
    }
    
    public func fileExistsAtLocalDocumentDirectory(path:String) -> Bool{
        let localPath:String = getDocumentsDirectory()+path;
        return fileManager.fileExists(atPath:localPath);
    }
    
    public func fileExistsAtLocal(path:String) -> Bool{
        return fileManager.fileExists(atPath:path);
    }
    
    public func getFilePathAtLocalDocumentDirectory(path:String) -> String{
        return getDocumentsDirectory()+path;
    }
    
    public func getFilePathAtLocalDirectory(path:String) -> String{
        return path;
    }
    
    public func getUsersDefaultDirectory() -> String{
        return fileManager.currentDirectoryPath;
    }
    
    public func getUsersTempDirectory() -> URL{
        return fileManager.temporaryDirectory;
    }
    
    public func getDocumentsDirectory() -> String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return String(documentsDirectory.relativePath[..<documentsDirectory.relativePath.endIndex]) //documentsDirectory.relativePath.substring(to: documentsDirectory.relativePath.endIndex)
    }
    
    
    public func saveFileAtLocalDocumentDirectory(relativePath:String!, data:Data){
        createFolderIfNotExist( path: getDocumentsDirectory() + NSString(string:  relativePath).deletingLastPathComponent)
        fileManager.createFile(atPath: getDocumentsDirectory()+relativePath, contents: data, attributes: nil)
    }
    
    public func deleteFileFromLocalDocumentDirectory(relativePath:String!){
        do{
            try fileManager.removeItem(atPath: getDocumentsDirectory()+relativePath);
        }
        catch{
            print("Unable to delete files");
        }
        
    }
    
    func copyFile(source:String, destination:String){
        do{
            try fileManager.copyItem(at: URL(fileURLWithPath: source), to: URL(fileURLWithPath: destination))
        }
        catch{
            print("failed to copy");
        }
    }
    
    public func createFolderIfNotExist(path:String){
        var isDir : ObjCBool = true
        if !fileManager.fileExists(atPath: path, isDirectory: &isDir){
            do {
                try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Unable to create directory \(error.debugDescription)")
            }
        }
    }
    
    
}
