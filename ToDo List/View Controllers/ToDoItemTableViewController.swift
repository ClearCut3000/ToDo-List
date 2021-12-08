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
    return UITableViewCell()
  }
}
