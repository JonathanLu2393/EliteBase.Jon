//
//  CoreDataUtilities.swift
//  Elite Instructor
//
//  Created by Eric Heitmuller on 1/13/16.
//  Copyright © 2016 Eric Heitmuller. All rights reserved.
//


import Foundation
import CoreData

open class CoreDataUtilities {
	
	fileprivate static let entityTypes : [String] = ["MasterSubject","ChildSubject","User"]
	
	open static func fetch(_ managedContext: NSManagedObjectContext?, entity: String) -> [NSManagedObject]? {
		
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
		
		do {
			let results = try managedContext!.fetch(fetchRequest)
			let array = results as! [NSManagedObject]
			return array
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
		
		return nil
	}
	
	open static func fetchObject(_ managedContext: NSManagedObjectContext?, entity: String) -> NSManagedObject? {
		
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
		
		do {
			let results = try managedContext!.fetch(fetchRequest)
			let array = results as! [NSManagedObject]
			
			if(array.isEmpty){
				return nil
			}
			
			let object = array[0]
			
			return object
			
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
		
		return nil
	}
	
	open static func delete(_ managedContext: NSManagedObjectContext?, array: [NSManagedObject]) -> [NSManagedObject] {
		
		var mutable = array
		
		for object in mutable {
			
			managedContext!.delete(object)
			mutable.removeFirst()
			
			do {
				try managedContext!.save()
			} catch let error as NSError {
				print("Could not delete \(error), \(error.userInfo)")
			}
		}
		
		return array
	}
	
	open static func deleteObject(_ managedContext: NSManagedObjectContext?, object: NSManagedObject){
		
		managedContext!.delete(object)
		
		do {
			try managedContext!.save()
		} catch let error as NSError {
			print("Could not delete \(error), \(error.userInfo)")
		}
	}
    
    open static func deleteChildSubjects(_ masterSubjectId: String, managedContext: NSManagedObjectContext?, array: [NSManagedObject]) -> [NSManagedObject] {
        
        var index = 0
        var mutable = array
        
        for object in mutable {
            
            if(object.value(forKey: "parentSubjectId") as! String == masterSubjectId){
                managedContext!.delete(object)
                mutable.remove(at: index)
                index -= 1
            }
            
            do {
                try managedContext!.save()
            } catch let error as NSError {
                print("Could not delete \(error), \(error.userInfo)")
            }
            
            index += 1
        }
        
        return array
    }
}
