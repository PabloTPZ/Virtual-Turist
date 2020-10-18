//
//  DataController.swift
//  TuristV
//
//  Created by Pablo Perez Zeballos on 10/17/20.
//

import Foundation
import CoreData

class DataController {
  
  static let shared = DataController(modelName: "Tourist")
  
  let persistentContainer: NSPersistentContainer
  
  var viewContext: NSManagedObjectContext {
    return persistentContainer.viewContext
  }
  let backgroundContext:NSManagedObjectContext!
  
  
  init(modelName: String) {
    persistentContainer = NSPersistentContainer(name: modelName)
    
    backgroundContext = persistentContainer.newBackgroundContext()
  }
  
  
  func configureContexts() {
    viewContext.automaticallyMergesChangesFromParent = true
    backgroundContext.automaticallyMergesChangesFromParent = true
    
    backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
  }
  
  func load(completion: (() -> Void)? = nil) {
    persistentContainer.loadPersistentStores { (storeDescription, error) in
      guard error == nil else {
        fatalError(error!.localizedDescription)
      }
      
      self.autoSaveViewContext()
      self.configureContexts()
      completion?()
    }
  }
  
  func fetchMark() -> [Mark] {
    let fetchRequest : NSFetchRequest<Mark> = Mark.fetchRequest()
    do {
      let result = try persistentContainer.viewContext.fetch(fetchRequest)
      return result
    } catch {
      print("El error obteniendo usuario(s) \(error)")
    }
    return []
  }
  
}

extension DataController {
  func autoSaveViewContext(interval:TimeInterval = 30) {
    print("autosaving")
    
    guard interval > 0 else {
      print("cannot set negative autosave interval")
      return
    }
    
    if viewContext.hasChanges {
      try? viewContext.save()
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
      self.autoSaveViewContext(interval: interval)
    }
  }
}

