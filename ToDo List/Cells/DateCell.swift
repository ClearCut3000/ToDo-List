//
//  DateCell.swift
//  ToDo List
//
//  Created by Николай Никитин on 08.12.2021.
//

import UIKit

class DateCell: UITableViewCell {
  
  @IBOutlet weak var dateLabel: UILabel!
  
  func setDate(_ date: Date) {
    dateLabel.text = date.formattedDate
  }
  
}
