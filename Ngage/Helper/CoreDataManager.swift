//
//  CoreDataManager.swift
//  Ngage
//
//  Created by Mary Marielle Miranda on 29/01/2018.
//  Copyright © 2018 Mark Louie Angeles. All rights reserved.
//

import UIKit
import CoreData


enum CoreDataManagerResult: String {
    case Success = "Success",
         Error = "Error"
}

enum CoreDataEntity: String {
    case User = "UserDataModel",
         Mission = "MissionDataModel",
         Task = "TaskDataModel"
}

class CoreDataManager: NSObject {
    
    //MARK: - Properties
    
    static let sharedInstance = CoreDataManager()
    
    var errorDescription = ""
    
    //MARK: - Core Data
    
    //MARK: Stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.wellbet.SportsBook" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
        
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Ngage", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("Ngage.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    //MARK: Saving Support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    //MARK: - Public Methods
    
    //MARK: Fetching
    
    func getMainUser() -> UserDataModel? {
        let entityDescription =  NSEntityDescription.entity(forEntityName: "UserDataModel",
                                                            in:managedObjectContext)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDescription
        do {
            let fetchRawResults = try managedObjectContext.fetch(fetchRequest)
            if fetchRawResults.count != 0 {
                return fetchRawResults[0] as? UserDataModel
            }
            return nil
    
        } catch let error {
            errorDescription = error.localizedDescription
        }
        
        return nil
    }
    
    func checkMissionExist(code: Int) -> Bool {
        let entityDescription =  NSEntityDescription.entity(forEntityName: "MissionDataModel",
                                                            in:managedObjectContext)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDescription
        let predicate = NSPredicate(format: "code = \(code)")
        print("Predicate = \(predicate)")
        fetchRequest.predicate = predicate
        
        do {
            let fetchRawResults = try managedObjectContext.fetch(fetchRequest)
            if fetchRawResults.count != 0 {
                print("Count = \(fetchRawResults.count)")
                return true
            }
            return false
            
        } catch let error {
            errorDescription = error.localizedDescription
        }
        return true
    }
    
    
    func fetchSavedObjects(forEntity entity: CoreDataEntity,
                           completionHandler: @escaping (_ fetchResult: CoreDataManagerResult,
                            _ results: [AnyObject]?) -> Void) {
        var result = CoreDataManagerResult.Error
        var fetchedResults: [AnyObject]?
        
        var fetchRequest: NSFetchRequest<NSFetchRequestResult>?
        
        switch entity {
        case .User:
            fetchRequest = UserDataModel.fetchRequest()
            
        case .Mission:
            fetchRequest = MissionDataModel.fetchRequest()
            
        case .Task:
            fetchRequest = TaskDataModel.fetchRequest()
        }
        
        do {
            let fetchRawResults = try managedObjectContext.fetch(fetchRequest!)
            fetchedResults = convertRawObjectsToModels(forEntity: entity, withResults: fetchRawResults)
            
            result = .Success
        } catch let error {
            errorDescription = error.localizedDescription
        }
        
        completionHandler(result, fetchedResults)
    }
    
    func fetchTaskForMission(code: Int) -> [TaskModel] {
        let entityDescription =  NSEntityDescription.entity(forEntityName: "TaskDataModel",
                                                            in:managedObjectContext)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDescription
        let predicate = NSPredicate(format: "missionCode = \(code)")
        print("Predicate = \(predicate)")
        fetchRequest.predicate = predicate
        
        do {
            let fetchRawResults = try managedObjectContext.fetch(fetchRequest)
            if fetchRawResults.count != 0 {
                if let fetchedResults = convertRawObjectsToModels(forEntity: .Task, withResults: fetchRawResults) as? [TaskModel] {
                    return fetchedResults
                }
            }
            return []
            
        } catch let error {
            errorDescription = error.localizedDescription
        }
        return []
    }
    
    //MARK: Saving
    
    func saveModelToCoreData(withModel model: AnyObject,
                             completionHandler: @escaping (_ fetchResult: CoreDataManagerResult) -> Void) {
        var result = CoreDataManagerResult.Error
        
        switch model {
        case is UserModel:
            let userModel = model as! UserModel
            saveModelAsUserEntity(withModel: userModel)
            
        case is MissionModel:
            let missionModel = model as! MissionModel
            saveModelAsMissionEntity(withModel: missionModel)
            
        case is TaskModel:
            let taskModel = model as! TaskModel
            saveModelAsTaskEntity(withModel: taskModel)
            
        default:
            break
        }
        
        do {
            try managedObjectContext.save()
            result = .Success
        } catch let error {
            errorDescription = error.localizedDescription
        }
        
        completionHandler(result)
    }
    
    func updateUserPoints(withPoints points: String,
                          completionHandler: @escaping (_ fetchResult: CoreDataManagerResult) -> Void) {
        var result = CoreDataManagerResult.Error
        
        if let user = self.getMainUser() {
            user.points = points
            
            do {
                try managedObjectContext.save()
                result = .Success
            } catch let error {
                errorDescription = error.localizedDescription
            }
        } else {
            errorDescription = "Error fetching user profile"
        }
        
        completionHandler(result)
    }
    
    //MARK: - Private Methods
    
    //MARK: Fetching
    
    private func convertRawObjectsToModels(forEntity entity: CoreDataEntity,
                                                withResults results: [Any]) -> [AnyObject] {
        var convertedResults = [AnyObject]()
        
        switch entity {
        case .User:
            let userResults = results as? [UserDataModel]
            guard userResults != nil else { break }
            
            for result in userResults! {
                var user = UserModel()
                user.userId = result.userId ?? ""
                user.facebookId = result.facebookId ?? ""
                user.age = result.age ?? ""
                user.emailAddress = result.emailAddress ?? ""
                user.gender = result.gender ?? ""
                user.image = result.image
                user.mobileNumber = result.mobileNumber ?? ""
                user.name = result.name ?? ""
                user.points = result.points ?? ""
                user.operatorID = result.operatorID ?? ""
                user.dateCreated = result.startDate ?? ""
                
                convertedResults.append(user as AnyObject)
            }
            
        case .Mission:
            let missionResults = results as? [MissionDataModel]
            guard missionResults != nil else { break }
            
            let sortedResults = missionResults!.sorted(by: { $0.code < $1.code })
            
            for result in sortedResults {
                var mission = MissionModel()
                mission.code = Int(result.code)
                mission.userId = result.userId ?? ""
                mission.brand = result.brand ?? ""
                mission.colorBackground = result.colorBackground ?? "#ffffff"
                mission.colorPrimary = result.colorPrimary ?? "#ffffff"
                mission.colorSecondary = result.colorSecondary ?? "#ffffff"
                mission.createdBy = result.createdBy ?? ""
                mission.endDate = result.endDate ?? "\(NSDate())"
                mission.imageUrl = result.imageUrl ?? ""
                mission.isClaimed = result.isClaimed
                mission.pointsRequiredToUnlock = result.pointsRequiredToUnlock ?? ""
                mission.reward = result.reward ?? "1"
                mission.rewardDetails = result.rewardDetails ?? ""
                mission.rewardInfo = result.rewardInfo ?? ""
                mission.rewardType = result.rewardType ?? "0"
                mission.startDate = result.startDate ?? "\(NSDate())"
                mission.title = result.title ?? ""
                
                convertedResults.append(mission as AnyObject)
            }
            
        case .Task:
            let taskResults = results as? [TaskDataModel]
            guard taskResults != nil else { break }
            
            let sortedResults = taskResults!.sorted(by: { $0.code < $1.code })
            
            for result in sortedResults {
                var task = TaskModel()
                task.code = Int(result.code)
                task.missionCode = Int(result.missionCode)
                task.contentId = result.contentId ?? ""
                task.detail = result.detail ?? ""
                task.instructions = result.instructions ?? ""
                task.isClaimed = result.isClaimed
                task.isReward = result.isReward ?? ""
                task.reward = result.reward ?? "1"
                task.rewardDetails = result.rewardDetails ?? ""
                task.rewardInfo = result.rewardInfo ?? ""
                task.rewardType = result.rewardType ?? "5"
                task.state = Int(result.state)
                task.title = result.title ?? ""
                task.type = Int(result.type)
                
                convertedResults.append(task as AnyObject)
            }
        }
        
        return convertedResults
    }
    
    //MARK: Saving
    
    private func saveModelAsUserEntity(withModel model: UserModel) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "UserDataModel", into: managedObjectContext) as! UserDataModel
        
        entity.userId = model.userId
        entity.facebookId = model.facebookId
        entity.age = model.age
        entity.emailAddress = model.emailAddress
        entity.gender = model.gender
        entity.image = model.image
        entity.mobileNumber = model.mobileNumber
        entity.name = model.name
        entity.points = model.points
        entity.operatorID = model.operatorID
        entity.startDate = model.dateCreated
        print(model.operatorID)
        
        for mission in model.missions {
            self.saveModelAsMissionEntity(withModel: mission)
        }
    }
    
    private func saveModelAsMissionEntity(withModel model: MissionModel) {
        let entityDescription =  NSEntityDescription.entity(forEntityName: "MissionDataModel",
                                                            in:managedObjectContext)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let predicate = NSPredicate(format: "code = \(model.code)")
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = predicate
        
        var missionEntity: MissionDataModel!
        
        do {
            let fetchRawResults = try managedObjectContext.fetch(fetchRequest) as! [MissionDataModel]
            
            if let entity = fetchRawResults.first {
                missionEntity = entity
            } else {
                missionEntity = NSEntityDescription.insertNewObject(forEntityName: "MissionDataModel", into: managedObjectContext) as! MissionDataModel
            }
        } catch let error {
            errorDescription = error.localizedDescription
            return
        }
        
        missionEntity.code = Int64(model.code)
        missionEntity.userId = model.userId
        missionEntity.brand = model.brand
        missionEntity.colorBackground = model.colorBackground
        missionEntity.colorPrimary = model.colorPrimary
        missionEntity.colorSecondary = model.colorSecondary
        missionEntity.createdBy = model.createdBy
        missionEntity.endDate = model.endDate
        missionEntity.imageUrl = model.imageUrl
        missionEntity.isClaimed = model.isClaimed
        missionEntity.pointsRequiredToUnlock = model.pointsRequiredToUnlock
        missionEntity.reward = model.reward
        missionEntity.rewardDetails = model.rewardDetails
        missionEntity.rewardInfo = model.rewardInfo
        missionEntity.rewardType = model.rewardType
        missionEntity.startDate = model.startDate
        missionEntity.title = model.title
        
        for task in model.tasks {
            self.saveModelAsTaskEntity(withModel: task)
        }
    }
    
    private func saveModelAsTaskEntity(withModel model: TaskModel) {
        print("Should save Task! \(model.missionCode)")
    
        let entityDescription =  NSEntityDescription.entity(forEntityName: "TaskDataModel",
                                                            in:managedObjectContext)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let predicate = NSPredicate(format: "code = \(model.code) && missionCode = \(model.missionCode)")
        fetchRequest.entity = entityDescription
        fetchRequest.predicate = predicate
        
        var taskEntity: TaskDataModel!
        
        do {
            let fetchRawResults = try managedObjectContext.fetch(fetchRequest) as! [TaskDataModel]
            
            if let entity = fetchRawResults.first {
                taskEntity = entity
            } else {
                taskEntity = NSEntityDescription.insertNewObject(forEntityName: "TaskDataModel", into: managedObjectContext) as! TaskDataModel
            }
        } catch let error {
            errorDescription = error.localizedDescription
            return
        }
        
        taskEntity.code = Int64(model.code)
        taskEntity.missionCode = Int64(model.missionCode)
        taskEntity.contentId = model.contentId
        taskEntity.detail = model.detail
        taskEntity.instructions = model.instructions
        taskEntity.isClaimed = model.isClaimed
        taskEntity.isReward = model.isReward
        taskEntity.reward = model.reward
        taskEntity.rewardDetails = model.rewardDetails
        taskEntity.rewardInfo = model.rewardInfo
        taskEntity.rewardType = model.rewardType
        taskEntity.state = Int64(model.state)
        taskEntity.title = model.title
        taskEntity.type = Int64(model.type)
    }
}
