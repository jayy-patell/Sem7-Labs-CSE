//
//  RemindersTableViewController.swift
//  Birthday Tracker
//

import UIKit
import CoreData

class RemindersTableViewController: UITableViewController {
    
    var reminders = [Reminder]()
    let dateFormatter = DateFormatter()
    var showCompleted = false // Track whether to show completed or incomplete reminders
    
    @IBOutlet weak var statusSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addReminderVC = segue.destination as? AddReminderViewController {
            addReminderVC.saveCompletion = {
                self.loadData() // Reload data after saving a new reminder
            }
        }
    }
    
    @IBAction func statusSegmentChanged(_ sender: UISegmentedControl) {
        // Toggle the showCompleted flag based on the selected segment
        showCompleted = sender.selectedSegmentIndex == 1
        print("\(showCompleted) changedddddd")
        loadData()
    }
    
    func loadData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Reminder.fetchRequest() as NSFetchRequest<Reminder>
        
        // Filter reminders based on the showCompleted flag
        let statusPredicate = NSPredicate(format: "statusFlag == %@", NSNumber(value: showCompleted))
        fetchRequest.predicate = statusPredicate
        
        print(statusPredicate)
        
        // Sort by priority and date
        let sortDescriptor1 = NSSortDescriptor(key: "priority", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "reminderDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1, sortDescriptor2]
        
        do {
            // Fetch the reminders and assign to the reminders array
            reminders = try context.fetch(fetchRequest)
            
            // Print fetched reminders for debugging
            print("Fetched reminders:")
            for reminder in reminders {
                print("Title: \(reminder.title ?? "No Title"), Date: \(reminder.reminderDate ?? Date()), Priority: \(reminder.priority), Status: \(reminder.statusFlag ? "Completed" : "Incomplete")")
            }
            
        } catch let error {
            print("Failed to load reminders: \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }

    
    // Table View Data Source Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCellIdentifier", for: indexPath)
        let reminder = reminders[indexPath.row]
        
        // Display title and priority
        let priorityString: String
        switch reminder.priority {
        case 1: priorityString = "High Priority"
        case 2: priorityString = "Medium Priority"
        case 3: priorityString = "Low Priority"
        default: priorityString = "No Priority"
        }
        
        cell.textLabel?.text = "\(reminder.title ?? "Untitled") - \(priorityString)"
        
        // Display only the reminder date in the subtitle
        if let date = reminder.reminderDate {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        } else {
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    // Swipe action to toggle the completion status
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let reminder = reminders[indexPath.row]
        
        if reminder.statusFlag {
            // If the reminder is completed, provide a delete action
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
                // Delete the reminder from Core Data
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                context.delete(reminder)
                
                // Remove the reminder from the array and save changes
                self.reminders.remove(at: indexPath.row)
                
                do {
                    try context.save()
                    print("Reminder deleted successfully.")
                } catch let error {
                    print("Failed to delete reminder: \(error.localizedDescription)")
                }
                
                // Reload the table view data to reflect the deletion
                self.loadData()
                
                completionHandler(true)
            }
            deleteAction.backgroundColor = .systemRed
            return UISwipeActionsConfiguration(actions: [deleteAction])
            
        } else {
            // If the reminder is incomplete, provide a mark complete action
            let markCompleteAction = UIContextualAction(style: .normal, title: "Mark Complete") { action, view, completionHandler in
                // Mark the reminder as complete by toggling the statusFlag
                reminder.statusFlag = true
                
                // Save the updated status in Core Data
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                do {
                    try context.save()
                    print("Reminder marked as complete.")
                } catch let error {
                    print("Failed to update reminder status: \(error.localizedDescription)")
                }
                
                // Reload the data to reflect the change
                self.loadData()
                
                completionHandler(true)
            }
            markCompleteAction.backgroundColor = .systemGreen
            return UISwipeActionsConfiguration(actions: [markCompleteAction])
        }
    }

}
