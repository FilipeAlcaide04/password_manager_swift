//
//  AccountValue+CoreDataProperties.swift
//  password_manager
//
//  Created by Filipe Alcaide on 08/03/2025.
//
//

import Foundation
import CoreData


extension AccountValue {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AccountValue> {
        return NSFetchRequest<AccountValue>(entityName: "AccountValue")
    }

    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var email: String?

}

extension AccountValue : Identifiable {

}
