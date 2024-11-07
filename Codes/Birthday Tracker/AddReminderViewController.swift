//
//  AddReminderViewController.swift
//  Birthday Tracker
//
//  Created by Student on 07/11/24.
//

import UIKit
import CoreData
import UserNotifications

class AddReminderViewController: UIViewController {
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    var saveCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty else {
            print("Title cannot be empty.")
            return
        }
        
        let reminderDate = datePicker.date
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newReminder = Reminder(context: context)
        
        newReminder.title = title
        newReminder.reminderDate = reminderDate
        newReminder.eventID = UUID().uuidString
        
        do {
            try context.save()
            
            // Notification content setup
            let content = UNMutableNotificationContent()
            content.title = "Reminder Alert!"
            content.body = title
            content.sound = UNNotificationSound.default
            
            // Determine the trigger time
            let calendar = Calendar.current
            let currentDate = Date()
            let isSameDay = calendar.isDate(currentDate, inSameDayAs: reminderDate)
            
            var trigger: UNNotificationTrigger
            if isSameDay {
                // Set trigger to 1 minute from now
                let triggerDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate) ?? currentDate
                let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
                trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            } else {
                // Set trigger for a specific time on the reminder date (e.g., 10:15 AM)
                var dateComponents = calendar.dateComponents([.year, .month, .day], from: reminderDate)
                dateComponents.hour = 10
                dateComponents.minute = 15
                trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            }
            
            // Schedule the notification
            if let identifier = newReminder.eventID {
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error adding notification: \(error.localizedDescription)")
                    } else {
                        print("Notification added successfully.")
                    }
                }
            }
        } catch let error {
            print("Failed to save reminder: \(error.localizedDescription)")
        }
        
        dismiss(animated: true, completion: saveCompletion)
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

