//
//  RemindersTableViewController.swift
//  Birthday Tracker
//
//  Created by Student on 07/11/24.
//

import UIKit
import CoreData
import UserNotifications

class RemindersTableViewController: UITableViewController {
    
    var reminders = [Reminder]()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addReminderVC = segue.destination as? AddReminderViewController else { return }
        addReminderVC.saveCompletion = {
            self.loadData()
        }
    }
    
    func loadData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Reminder.fetchRequest() as NSFetchRequest<Reminder>
        let sortDescriptor = NSSortDescriptor(key: "reminderDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            reminders = try context.fetch(fetchRequest)
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
        
        cell.textLabel?.text = reminder.title
        if let date = reminder.reminderDate {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        } else {
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    // Deleting reminders and their notifications
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && reminders.count > indexPath.row {
            let reminder = reminders[indexPath.row]
            if let identifier = reminder.eventID {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(reminder)
            reminders.remove(at: indexPath.row)
            
            do {
                try context.save()
            } catch let error {
                print("Failed to delete reminder: \(error.localizedDescription)")
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
