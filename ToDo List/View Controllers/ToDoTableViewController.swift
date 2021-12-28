//
//  ToDoTableViewController.swift
//  ToDo List
//
//  Created by Николай Никитин on 05.12.2021.
//

import UIKit
import UserNotifications
import EventKit

class ToDoTableViewController: UITableViewController {
  
  //MARK: - Properties
  var todos = [ToDo]()
  let eventStore: EKEventStore = EKEventStore()
  var createdEvents = [ToDo: EKEvent]()
  var createdNotofications = [ToDo: UNNotificationRequest]()
  
  //MARK: - UIViewController
  override func viewDidLoad() {
    super.viewDidLoad()
    todos = [
      ToDo(title: "Купить хлеб", isComplete: false, image: UIImage(named: "bread")),
      ToDo(title: "Записаться на курсы", isComplete: false, image: UIImage(named: "school")),
      ToDo(title: "Научиться плавать", isComplete: false, image: UIImage(named: "wave")),
    ]
    navigationItem.leftBarButtonItem = editButtonItem
  }
  
  //MARK: - Methods
  private func addNotification(for todo: ToDo) {
    let content = UNMutableNotificationContent()
    content.title = todo.title
    content.sound = .default
    content.body = todo.notes ?? "No notes!"
    let targetDate = todo.dueDate
    let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: targetDate), repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
      if error != nil {
        print (#line, #function, "Some very strange things have happened to notifications in \(#file)!")
      } else {
        print (targetDate)
        print (request)
        self.createdNotofications.updateValue(request, forKey: todo)
      }
    })
  }
  
  private func deleteNotification( for todo: ToDo) {
    guard let notoficationForDeleteing = createdNotofications.removeValue(forKey: todo) else {
      print("Couldn't find notification request")
      return }
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notoficationForDeleteing.identifier])
    print ("Notification with the request \(notoficationForDeleteing) has been successfully destroyed!")
  }
  
  private func addEvent(for eventSorce: ToDo) {
    eventStore.requestAccess(to: .event) { [weak self] success, error in
      if success, error == nil {
        DispatchQueue.main.async {
          guard let store = self?.eventStore else { return }
          let event = EKEvent(eventStore: store)
          event.title = eventSorce.title
          event.startDate = .now
          event.endDate = eventSorce.dueDate
          event.notes = eventSorce.notes ?? "No notes!"
          event.calendar = store.defaultCalendarForNewEvents
          do {
            try store.save(event, span: .thisEvent)
            self?.createdEvents.updateValue(event, forKey: eventSorce)
          } catch let error as NSError {
            print("Failed to save event with error : \(error)")
          }
          print("Event Saved")
        }
      } else {
        print ("An error occurred in the access request \(String(describing: error))")
      }
    }
  }
  
  private func deleteEvent(for eventSource: ToDo) {
    guard let deletingEvent = createdEvents.removeValue(forKey: eventSource) else { return }
    do{
      try eventStore.remove(deletingEvent, span: EKSpan.thisEvent)
    } catch let error {
      print ("Fail to delete event with errror: \(error)")
    }
  }
  
  //MARK: - UITableViewDataSource
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todos.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let todo = todos[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
    configure(cell, with: todo)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let movedTodos = todos.remove(at: sourceIndexPath.row)
    todos.insert(movedTodos, at: destinationIndexPath.row)
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    switch editingStyle{
    case .delete:
      let todo = todos.remove(at: indexPath.row)
      deleteEvent(for: todo)
      tableView.deleteRows(at: [indexPath], with: .fade)
    case .insert:
      break
    case .none:
      break
    @unknown default:
      print(#line, #function, "Some very strange things happened in \(#file)!")
      break
    }
  }
  
  //MARK: - Cell Content
  func configure(_ cell: ToDoCell, with todo: ToDo) {
    guard let stackView = cell.stackView else { return }
    stackView.arrangedSubviews.forEach{ subview in
      stackView.removeArrangedSubview(subview)
      subview.removeFromSuperview()
    }
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
      destination.navigationItem.rightBarButtonItem?.isEnabled = true
    } else if segue.identifier == "AddNewToDoItemSegue" {
      let destination = segue.destination as! ToDoItemTableViewController
      destination.todo = ToDo()
    }
  }
  
  @IBAction func unwind(_ segue: UIStoryboardSegue) {
    guard segue.identifier == "SaveSegue" else { return }
    let source = segue.source as! ToDoItemTableViewController
    addEvent(for: source.todo)
    addNotification(for: source.todo)
    if let selectedIndex = tableView.indexPathForSelectedRow {
      deleteEvent(for: todos[selectedIndex.row])
      deleteNotification(for: todos[selectedIndex.row])
      // We safely replace the new todo value in the array, and the old one is destroyed, because there are no more references to it, thanks to ARC.
      todos[selectedIndex.row] = source.todo
      tableView.reloadRows(at: [selectedIndex], with: .automatic)
    } else {
      todos.append(source.todo)
      tableView.reloadData()
    }
  }
}

//MARK: - UITableViewDelegate
extension ToDoTableViewController /*: UITableViewDelegate */ {
  override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
  }
}

