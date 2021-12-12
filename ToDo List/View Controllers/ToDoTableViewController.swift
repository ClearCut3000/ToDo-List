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

  //MARK: - UITableViewDataSource
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todos.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
    let todo = todos[indexPath.row]
    configure(cell, with: todo)
    return cell
  }

  //MARK: - Cell Content
  func configure(_ cell: ToDoCell, with todo: ToDo){
    guard let stackView = cell.stackView else { return }
    guard stackView.arrangedSubviews.count == 0 else { return }
    for index in 0 ..< todo.keys.count {
      let key = todo.capitalizedKeys[index]
      let value = todo.values[index]
      if let stringValue = value as? String {
        let label = UILabel()
        label.text = "\(key): \(stringValue)"
        stackView.addArrangedSubview(label)
      } else if let dateValue = value as? Date {
        let label = UILabel()
        label.text = "\(key): \(dateValue.formattedDate)"
        stackView.addArrangedSubview(label)
      } else if let boolValue = value as? Bool {
        let label = UILabel()
        label.text = "\(key): \(boolValue ? "✅" : "🅾️")"
        stackView.addArrangedSubview(label)
      } else if let imageValue = value as? UIImage {
        let imageView = UIImageView(image: imageValue)
        imageView.contentMode = .scaleAspectFit
        let heightConstaint = NSLayoutConstraint(
          item: imageView,
          attribute: .height,
          relatedBy: .equal,
          toItem: nil,
          attribute: .height,
          multiplier: 1,
          constant: 200
        )
        imageView.addConstraint(heightConstaint)

        stackView.addArrangedSubview(imageView)
      }
    }
  }

  //MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ToDoItemSegue"{
      guard let selectedIndex = tableView.indexPathForSelectedRow else{ return }
      let destination = segue.destination as! ToDoItemTableViewController
      // Creating a new instance of the ToDo class
      destination.todo = todos[selectedIndex.row].copy() as! ToDo
    } else if segue.identifier == "AddNewToDoItemSegue" {
      let destination = segue.destination as! ToDoItemTableViewController
      destination.todo = ToDo()

    }
  }

  @IBAction func unwind(_ segue: UIStoryboardSegue){
    guard segue.identifier == "SaveSegue" else { return }
    let source = segue.source as! ToDoItemTableViewController
    if let selectedIndex = tableView.indexPathForSelectedRow {
      // We safely replace the new todo value in the array, and the old one is destroyed, because there are no more references to it, thanks to ARC.
      todos[selectedIndex.row] = source.todo
      if let toDoCell = tableView.cellForRow(at: selectedIndex) as? ToDoCell {
        if let stackView = toDoCell.stackView {
          stackView.arrangedSubviews.forEach{ subview in
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
          }
        }
      }
      tableView.reloadRows(at: [selectedIndex], with: .automatic)
    } else {
      todos.append(source.todo)
      tableView.reloadData()
    }
  }
}

  //MARK: - UITableViewDelegate
  extension ToDoTableViewController/*: UITableViewDelegate */{
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      switch editingStyle{
      case .delete:
        todos.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
      case .insert:
        break
      case .none:
        break
      @unknown default:
        print("Some weird shit is about to happen!")
        break
      }
    }
  }
