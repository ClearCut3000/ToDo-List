//
//  ToDo.swift
//  ToDo List
//
//  Created by Николай Никитин on 04.12.2021.
//

import UIKit
class ToDo {
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
}
