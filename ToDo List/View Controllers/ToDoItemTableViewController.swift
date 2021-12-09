//
//  ToDoItemTableViewController.swift
//  ToDo List
//
//  Created by Николай Никитин on 05.12.2021.
//

import UIKit

class ToDoItemTableViewController: UITableViewController {

  //MARK: - Properties
  var todo = ToDo()

  // MARK: - UIViewController Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    todo.isComplete.toggle()
  }
}

// MARK: - UITableViewDataSource
extension ToDoItemTableViewController/*: UITableViewDataSource*/{
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let value = todo.values[indexPath.row]
    if let cell = tableView.cellForRow(at: indexPath) {
      return cell.isHidden ? 0 : UITableView.automaticDimension
    } else {
      // If the cells outside the TableView are all set to automaticDimension, except for the case of DatePicker
      return value is Date && indexPath.row == 1 ? 0 : UITableView.automaticDimension
    }
  }
  override func numberOfSections(in tableView: UITableView) -> Int {
    // The number of properties is equal to the number of sections
    return todo.keys.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let value = todo.values[section]
    return value is Date ? 2 : 1
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let section = indexPath.section
    let value = todo.values[section]
    let cell = getCellFor(indexPath: indexPath, with: value)
    return cell
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let key = todo.capitalizedKeys[section]
    return key
  }
}

// MARK: - Cell configurator
extension ToDoItemTableViewController {
  func getCellFor(indexPath: IndexPath, with value: Any?) -> UITableViewCell {
    if let stringValue = value as? String {
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
      cell.textField.text = stringValue
      return cell
    } else if let dateValue = value as? Date {
      switch indexPath.row {
      case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell") as! DateCell
        cell.setDate(dateValue)
        return cell
      case 1:
        let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell") as! DatePickerCell
        cell.datePicker.date = dateValue
        cell.datePicker.minimumDate = Date()
        return cell
      default:
        fatalError("Please, add more prototype cells for Date section")
      }
    } else if let imageValue = value as? UIImage {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell
      cell.largeImageView.image = imageValue
      return cell
    } else if let boolValue = value as? Bool {
      let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
      cell.switchSelector.isOn = boolValue
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
      cell.textField.text = ""
      return cell
    }
  }
}
