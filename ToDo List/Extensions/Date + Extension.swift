//
//  Date - Extension.swift
//  ToDo List
//
//  Created by Николай Никитин on 06.12.2021.
//

import Foundation
extension Date {
  var formattedDate: String {
    let formatter = DateFormatter()
    formatter.locale = Locale.current
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: self)
  }
}
