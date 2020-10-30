//
//  CoreDataManager.swift
//  CoreDataDealer
//
//  Created by sergio nieto on 27/10/20.
//  Copyright © 2020 sergio nieto. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    private let container : NSPersistentContainer!
    
    init(){
        container = NSPersistentContainer(name: "Banking")
        setupDatabase()
        
    }
    
    private func setupDatabase(){
        container.loadPersistentStores{ (desc, error) in
            
            if let error = error {
                print("Error loading store \(desc) — \(error)")
                return
            }
            print("Database ready!")
        }
    }
    
    /*func createUser(name: String, age: Int16, lastName: String, email: String, initialAmount: Double, completion: @escaping() -> Void){
        let context = container.viewContext
        
        for _ in 0...100000{
            let user = User(context: context)
            user.name = name
            user.lastName = lastName
            user.email = email
            user.age = age
            
            let account = Account(context: context)
            account.name = "Cuenta de \(name)"
            account.amount = initialAmount
            account.openingDate = Date()
            account.belongsTo = user
        }
        
        do{
            try context.save()
            context.reset()
            print("Usuario \(name) guardado")
            completion()
        } catch {
            print("Error guardando usuario — \(error)")
        }
    }*/
    
    func createUser(name : String, age: Int16, lastName : String, email : String, initialAmount : Double, completion: @escaping() -> Void) {
        //1
        container.performBackgroundTask { (context) in
            for _ in 0...100000 {
                let user = User(context: context)
                user.name = name
                user.lastName = lastName
                user.email = email
                user.age = age
                let account = Account(context: context)
                account.name = "Cuenta de \(name)"
                account.amount = initialAmount
                account.openingDate = Date()
                account.belongsTo = user
            }
            do {
                try context.save()
                print("Usuario \(name) guardado")
                //2
                DispatchQueue.main.async {
                    completion()
                }
             } catch {
               print("Error guardando usuario — \(error)")
             }
           } // fin del performBackgroundTask
    }
    
    func deleteUsers() {
     
         //1
         let context = container.viewContext
         //2
         let fetchRequest : NSFetchRequest<User> = User.fetchRequest()
         //3
         let deleteBatch = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
         
        do {
         //4
         try context.execute(deleteBatch)
            print("éxito borrando usuarios")
         }catch {
            print("Error Borrando los usuarios \(error)")
        }
    }
    
    func fetchUsers() -> [User] {
        let fetchRequest : NSFetchRequest<User> = User.fetchRequest()
        
        //fetchRequest.fetchLimit = 5
        
        do{
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("El error obteniendo usuario(s) \(error)")
        }
        
        return []
    }
    
}
