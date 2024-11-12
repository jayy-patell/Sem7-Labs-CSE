//
//  AddReminderViewController.swift
//  Birthday Tracker
//

import UIKit
import CoreData

class AddReminderViewController: UIViewController {
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var prioritySegmentedControl: UISegmentedControl! // Outlet for priority selection
    
    var saveCompletion: (() -> Void)? // Completion handler to reload data in RemindersTableViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        // Ensure the title is not empty
        guard let title = titleTextField.text, !title.isEmpty else {
            print("Title cannot be empty.")
            return
        }
        
        // Get the selected date and priority from the UI
        let reminderDate = datePicker.date
        let selectedPriority = prioritySegmentedControl.selectedSegmentIndex + 1 // Assuming 1 = High, 2 = Medium, 3 = Low
        
        // Access the Core Data context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newReminder = Reminder(context: context)
        
        // Set the reminder's properties
        newReminder.title = title
        newReminder.reminderDate = reminderDate
        newReminder.priority = Int32(selectedPriority) // Save priority as Int16 for Core Data compatibility
        newReminder.statusFlag = false // New reminders are incomplete by default
        
        do {
            // Save the reminder to Core Data
            try context.save()
            print("Reminder saved successfully.")
            
            // Call saveCompletion to trigger data reload in RemindersTableViewController
            dismiss(animated: true) {
                self.saveCompletion?()
            }
        } catch let error {
            print("Failed to save reminder: \(error.localizedDescription)")
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        // Dismiss without saving if the user taps cancel
        dismiss(animated: true, completion: nil)
    }
}
