//
//  UserCoreData.swift
//  Restaurant
//
//  Created by Mahmoud Nagdy on 23/01/2026.
//

import Foundation
import CoreData


class UserCoreData {
    
    static let instance = UserCoreData()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private init() {
        container = CoreDataManager.instance.container
        context = CoreDataManager.instance.context
    }
    
    
    func saveUserToCoreData(user: UserModel) {
        print("save user to core data")
        let newUser = UserEntity(context: context)
        newUser.id = user.id
        newUser.name = user.name
        newUser.email = user.email
        newUser.isVerified = user.isVerified
        newUser.phone = user.phone
        newUser.role = user.role
        let profileImage = UserImageEntity(context: context)
        profileImage.public_id = user.profileImage?.public_id
        profileImage.secure_url = user.profileImage?.secure_url
        newUser.profileImage = profileImage
        
        print(newUser)
        save()
    }
    
    func updateUserProfileImageInCoreData(userId: String, profileImage: UserImage) {
        print("update user profile image to core data")
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        request.predicate = NSPredicate(format: "id == %@", userId)
        
        do {
            let user = try context.fetch(request).first
            let userProfileImage = UserImageEntity(context: context)
            userProfileImage.public_id = profileImage.public_id
            userProfileImage.secure_url = profileImage.secure_url
            user?.profileImage = userProfileImage
            
            print(user ?? "no user")
            
            save()
        } catch  {
            print("Error fetching user entity from core data", userId)
        }
    }
    
    func getUserFromCoreData() -> UserModel? {
        print("get user from core data")
        guard let userId = UserDefaults.standard.string(forKey: "loggedInUserId") else {
            print("user id not found in user defaults")
            return nil
        }
        
        let request = NSFetchRequest<UserEntity>(entityName: "UserEntity")
        request.predicate = NSPredicate(format: "id == %@", userId) // filter
        
        do {
            let userData = try context.fetch(request).first
            if let user = userData {
                
                return UserModel(id: user.id ?? "", name: user.name ?? "", email: user.email ?? "", password: "", phone: user.phone ?? "", role: user.role ?? "", profileImage: UserImage(public_id: user.profileImage?.public_id ?? "", secure_url: user.profileImage?.secure_url ?? ""), isVerified: user.isVerified)
            }
        } catch {
            print("Error fetching from core data: \(error)")
        }
        
        return nil
    }
    
    private func save() {
        do {
            try context.save()
        } catch {
            print("Error saving in core data: \(error)")
        }
    }
    
}
