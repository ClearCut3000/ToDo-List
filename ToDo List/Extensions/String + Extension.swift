//
//  String.swift
//  ToDo List
//
//  Created by Николай Никитин on 06.12.2021.
//

extension String {
  var capitalizedWithSpaces: String {
    //Converts a string to a string with spaces
    let withSpaces = reduce ("") { result, character in
      character.isUppercase ? "\(result) \(character)" : "\(result)\(character)"
    }
    return withSpaces.capitalized
  }
}
