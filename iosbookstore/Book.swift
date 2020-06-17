//
//  Book.swift
//  bookstore
//
//  Created by Foo Chi Siong on 12/06/2020.
//  Copyright © 2020 Foo Chi Siong. All rights reserved.
//

import Foundation
import RealmSwift

class Book: Object
{
    @objc dynamic var bookID = 0
    
    override static func primaryKey() -> String? {
      return "bookID"
    }
    
    @objc dynamic var title: String?
    @objc dynamic var author: String?
    @objc dynamic var desc: String?
    @objc dynamic var photo: String?
}
