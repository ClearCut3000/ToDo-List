//
//  ToDo.swift
//  ToDo List
//
//  Created by Николай Никитин on 04.12.2021.
//

import UIKit
@objcMembers class ToDo: NSObject {
  //var childer
  // weak var parent

  var title: String
  var isComplete: Bool
  var dueDate: Date
  var notes: String?
  var image: UIImage?
  init(
    title: String = "",
    isComplete: Bool = false,
    dueDate: Date = Date(),
    notes: String? = nil,
    image: UIImage? = nil
  ) {
    self.title = title
    self.isComplete = isComplete
    self.dueDate = dueDate
    self.notes = notes
    self.image = image
  }

  var capitalizedKeys: [String] {
    return keys.map { $0.capitalizedWithSpaces }
  }

  // Allows you to get a list of the names of the properties of an instance of a class
  var keys: [String]{
    return Mirror(reflecting: self).children.compactMap { $0.label }
  }

  // Allows you to get a list of property values of an instance of a class
  var values: [Any?]{
    return Mirror(reflecting: self).children.map { $0.value }
  }

  override func copy() -> Any{
    // Type Any is specified for matching NSObject
    let newTodo = ToDo(
      title: title,
      isComplete: isComplete,
      dueDate: dueDate,
      notes: notes,
      image: image?.copy() as? UIImage )
    return newTodo
  }
}
