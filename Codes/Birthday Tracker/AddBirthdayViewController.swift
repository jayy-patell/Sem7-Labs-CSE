import UIKit
import CoreData
import UserNotifications

class AddBirthdayViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var eventDatePicker: UIDatePicker!
    @IBOutlet weak var pickerView: UIPickerView!
    var selectedEvent: String?
    @IBOutlet var venueField: UITextField!
    
    let data = ["Birthday", "Wedding", "Reception", "Festival", "Get-together", "Reunion", "Convocation"]
    var saveCompletion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventDatePicker.maximumDate = Date()
        pickerView.delegate = self
        pickerView.dataSource = self
        eventDatePicker.setValue(UIColor.white, forKey: "textColor")
        pickerView.setValue(UIColor.white, forKey: "textColor")
    }
    
    // Picker view functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return data.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return data[row] }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedEvent = data[row]
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        let firstName = firstNameTextField.text?.isEmpty == false ? firstNameTextField.text : "(No name)"
        let eventDate = eventDatePicker.date
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newEvent = Birthday(context: context)
        
        newEvent.firstName = firstName
        newEvent.eventDate = eventDate
        newEvent.eventID = UUID().uuidString
        newEvent.venue = venueField.text
        newEvent.event = selectedEvent
        
        do {
            try context.save()
            
            // Notification content setup
            let content = UNMutableNotificationContent()
            content.title = "Event Reminder!"
            content.body = "\(firstName ?? "") - \(selectedEvent ?? "No event") at \(venueField.text ?? "")!"
            content.sound = UNNotificationSound.default

            // Determine the trigger time
            let calendar = Calendar.current
            let currentDate = Date()
            let isSameDay = calendar.isDate(currentDate, inSameDayAs: eventDate)

            var trigger: UNNotificationTrigger

            if isSameDay {
                // Set trigger to 1 minute from now
                let triggerDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate) ?? currentDate
                let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
                trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            } else {
                // Set trigger to 10:15 AM on the event date
                var dateComponents = calendar.dateComponents([.year, .month, .day], from: eventDate)
                dateComponents.hour = 10
                dateComponents.minute = 15
                trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            }

            // Schedule the notification
            if let identifier = newEvent.eventID {
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
            print("Failed to save event: \(error.localizedDescription)")
        }
        
        dismiss(animated: true, completion: saveCompletion)
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
