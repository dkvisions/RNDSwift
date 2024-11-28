//
//  CoreDataHelper.swift
//  WebViewTestJS
//
//  Created by Rahul Vishwakarma on 27/11/24.
//

import CoreData
import UIKit

class CoreDataHelper: NSObject {
    
    
    var context: NSManagedObjectContext!
    
    static let shared = CoreDataHelper()
    
    
    override init() {
        super.init()
        
        context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    }
    
    func saveData() {
        
        guard context != nil else { return }
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "EmployeeDetails", into: context) as? EmployeeDetails
        
        entity?.id = 3
        entity?.name = "Rahul"
        entity?.occupution = "Developer"
        entity?.address = "Mumbai"
        
        do {
            try context.save()
            
        } catch {
            print("Error in saving Data")
        }
    }
    
    func updateData() {
        guard context != nil else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeDetails")
        
//        request.predicate = NSPredicate(format: "attribute = %@", "Value")
        
        do {
            let result = try context.fetch(request)
            
            if let resultFirst = result.last as? EmployeeDetails  {
                resultFirst.id = 2
                resultFirst.name = "Navneet"
                
                do {
                    try context.save()
                    
                } catch {
                    print("Error in Updating Data")
                }
            }
            
        } catch {
            print("Error in retriving Data")
        }
    }
    
    
    func fetchData() {
        guard context != nil else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeDetails")
//        request.predicate = NSPredicate(format: "attribute = %@", "Value")
        
        do {
            let result = try context.fetch(request)
            
            print(result.count)
            
            
            for data in result {
                
                if let data = data as? EmployeeDetails {
                    print(data.id, data.name, data.address)
                }
            }
            
            
        } catch {
            print("Error in retriving Data")
        }
    }
    
}
