//
//  ToDoTableViewController.swift
//  ToDo List
//
//  Created by Николай Никитин on 05.12.2021.
//

import UIKit

class ToDoTableViewController: UITableViewController {

  var todos = [ToDo]()


  //MARK: - UIViewController
  override func viewDidLoad(){
    super.viewDidLoad()
    todos = [
      ToDo(title: "Купить хлеб", isComplete: false, image: UIImage(named: "bread")),
      ToDo(title: "Записать ребенка в школу", isComplete: false, image: UIImage(named: "school")),
      ToDo(title: "Поймать волну", isComplete: false, image: UIImage(named: "wave")),
    ]
  }
}
