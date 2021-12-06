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
