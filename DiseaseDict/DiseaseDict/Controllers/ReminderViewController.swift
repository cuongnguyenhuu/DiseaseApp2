 //
//  ReminderViewController.swift
//  DiseaseDict
//
//  Created by Currie on 11/25/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit
import SoftUIView
import Schedule
import BackgroundTasks

class ReminderViewController: UIViewController, UITextViewDelegate {
    
    private var datePicker = UIDatePicker()
    private var timePicker = UIDatePicker()
    private var indexRepeat: [Int] = [0,0,0,0,0,0,0]
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var switchButton: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
        dateField.borderTextFieldStyle()
        dateField.delegate = self
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.minimumDate = Date()
        dateField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        addToolBar(textField: dateField)
        dateField.tag = 0
        dateField.text = dateFormart(date: Date())
        
        timeField.borderTextFieldStyle()
        timeField.delegate = self
        timePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        timePicker.minimumDate = Date()
        timeField.inputView = timePicker
        timePicker.addTarget(self, action: #selector(handleTimePicker), for: .valueChanged)
        addToolBar(textField: timeField)
        timeField.tag = 1
        timeField.text = timeFormart(date: Date())
        
        contentTextView.layer.cornerRadius = 10
        contentTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        reminderButton.layer.cornerRadius = 10
        
        //notification
        setupNotification()
        
        contentTextView.text = "Write content here..."
        contentTextView.textColor = UIColor.lightGray
        contentTextView.delegate = self
        
        titleField.borderTextFieldStyle()
        self.repeatLabel.text = "Once"
    }
    
    func setupNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if error != nil {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write content here..."
            textView.textColor = UIColor.lightGray
        }
    }

    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(named: "orange")
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()

        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed(_ sender: UIDatePicker){
        view.endEditing(true)
    }
    
    @objc func cancelPressed(_ sender: UIDatePicker){
        view.endEditing(true) // or do something
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBOutlet weak var dateField: UITextField!
    
    @IBOutlet weak var timeField: UITextField!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var reminderButton: UIButton!
    
    @IBAction func reminderButtonDidTap(_ sender: Any) {
        
        let timeInterval = calculateTime()
        if timeInterval > 0 && !contentTextView.text.isEmpty && !titleField.text!.isEmpty {
            var ids = ""

            var c = 0
            
            indexRepeat.forEach { (i) in
                if i == 1 {
                    c += 1
                }
            }
            
            if c == 0 || c == 7 {
                ids = UUID().uuidString + ","
                let content = UNMutableNotificationContent()
                content.title = "REMINDER!"
                content.subtitle = titleField.text ?? "Take a look"
                content.body = contentTextView.text
                content.sound = UNNotificationSound.default
                let badgeNumber = UserDefaults.standard.integer(forKey: "bagdeNumber") + 1
                content.badge = NSNumber(value: badgeNumber)
                UserDefaults.standard.set(badgeNumber, forKey: "bagdeNumber")
                let firstFireDateComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: Date(timeIntervalSinceNow: timeInterval))
                let trigger = UNCalendarNotificationTrigger(dateMatching: firstFireDateComponents, repeats: c == 0 ? false : true)

                let request = UNNotificationRequest(identifier: ids, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { _ in
                    
                }
            } else {
                var weekday = Calendar.current.component(.weekday, from: Date())
                weekday = weekday - 2
                if weekday < 0 {
                    weekday = weekday + 8
                }
                var index = 0
                indexRepeat.forEach { i in
                    if i == 1 {
                        switch index {
                        case 0:
                            let id = UUID().uuidString
                            ids = ids + id + ","
                            createSingleReminder(timeInterval: Int(timeInterval), weekday: weekday, index: 0, id: id)
                        case 1:
                            let id = UUID().uuidString
                            ids = ids + id + ","
                            createSingleReminder(timeInterval: Int(timeInterval), weekday: weekday, index: 1, id: id)
                        case 2:
                            let id = UUID().uuidString
                            ids = ids + id + ","
                            createSingleReminder(timeInterval: Int(timeInterval), weekday: weekday, index: 2, id: id)
                        case 3:
                            let id = UUID().uuidString
                            ids = ids + id + ","
                            createSingleReminder(timeInterval: Int(timeInterval), weekday: weekday, index: 3, id: id)
                        case 4:
                            let id = UUID().uuidString
                            ids = ids + id + ","
                            createSingleReminder(timeInterval: Int(timeInterval), weekday: weekday, index: 4, id: id)
                        case 5:
                            let id = UUID().uuidString
                            ids = ids + id + ","
                            createSingleReminder(timeInterval: Int(timeInterval), weekday: weekday, index: 5, id: id)
                        case 6:
                            let id = UUID().uuidString
                            ids = ids + id + ","
                            createSingleReminder(timeInterval: Int(timeInterval), weekday: weekday, index: 6, id: id)
                        default:
                            print("")
                        }
                    }
                    index += 1
                }
            }
            
            let reminder = ReminderModel(id: ids, date: dateField.text!, time: timeField.text!, repeats: Util.share.convertArrayToString(ar: indexRepeat), title: titleField.text!, content: contentTextView.text)
            ReminderRealmService.shared.saveReminder(reminder: reminder) { (finish) in
                
            }
            self.navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Invalid Error!", message: "Please fill correctly!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func createSingleReminder(timeInterval: Int, weekday: Int, index: Int, id: String){
        var tI = 0
        if weekday > index {
            tI = timeInterval + (index - weekday + 7)*24*60*60
        } else {
            tI = timeInterval + (index - weekday)*24*60*60
        }
        print("weekday: \(weekday)")
        print("index: \(index)")
        print("AAAA: \(tI)")
        let content = UNMutableNotificationContent()
        content.title = "REMINDER!"
        content.subtitle = titleField.text ?? "Take a look"
        content.body = contentTextView.text
        content.sound = UNNotificationSound.default
        let badgeNumber = UserDefaults.standard.integer(forKey: "bagdeNumber") + 1
        content.badge = NSNumber(value: badgeNumber)
        UserDefaults.standard.set(badgeNumber, forKey: "bagdeNumber")
        let firstFireDateComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(timeIntervalSinceNow: TimeInterval(tI)))
        let trigger = UNCalendarNotificationTrigger(dateMatching: firstFireDateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { _ in
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @objc func handleDatePicker(_ sender: UIDatePicker){
        dateField.text = dateFormart(date: sender.date)
    }
    
    @objc func handleTimePicker(_ sender: UIDatePicker){
        timeField.text = timeFormart(date: sender.date)
    }
    
    func calculateTime() -> TimeInterval{
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMM-dd-yyyy hh:mm a"
        let dateStr = dateField.text! + " " + timeField.text!
        let date = dateFormater.date(from: dateStr)!
        return -Date().timeIntervalSince(date)
    }
    
    func dateFormart(date: Date) -> String{
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMM-dd-yyyy"
        return dateFormater.string(from: date)
    }
    
    func timeFormart(date: Date) -> String{
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "hh:mm a"
        return dateFormater.string(from: date)
    }
    @IBAction func switchRepeat(_ sender: UISwitch) {
        if sender.isOn {
            let actionSheet = UIAlertController(title: "Repeat", message: "Choose one option", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Once", style: .default, handler: { action in
                self.switchButton.setOn(false, animated: true)
                self.repeatLabel.text = "Once"
                self.indexRepeat = [0,0,0,0,0,0,0]
            }))
            actionSheet.addAction(UIAlertAction(title: "Daily", style: .default, handler: { action in
                self.repeatLabel.text = "Daily"
                self.indexRepeat = [1,1,1,1,1,1,1]
            }))
            actionSheet.addAction(UIAlertAction(title: "Mon to Fri", style: .default, handler: { action in
                self.repeatLabel.text = "Mon to Fri"
                self.indexRepeat = [1,1,1,1,1,0,0]
            }))
            actionSheet.addAction(UIAlertAction(title: "Custom", style: .default, handler: { action in
                self.performSegue(withIdentifier: "goToRepeatList", sender: self)
            }))
            self.present(actionSheet, animated: true, completion: nil)
        } else {
            self.repeatLabel.text = "Once"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRepeatList" {
            (segue.destination as! RepeatViewController).delegate = self
        }
    }

}

 extension ReminderViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
 }

 extension ReminderViewController: RepeatDelegate {
    func selectedIndexes(indexes: [Int]) {
        var str = ""
        for i in 0..<indexes.count{
            if indexes[i] == 1 {
                str += UserDefaultConfig.repeatList[i] + " "
            }
        }
        self.indexRepeat = indexes
        repeatLabel.text = str
        if str.trimmingCharacters(in: .whitespaces).isEmpty {
            switchButton.setOn(false, animated: true)
            self.repeatLabel.text = "Once"
        }
        
        var c = 0
        indexes.forEach { i in
            if i == 1 {
                c += 1
            }
        }
        if c == 7 {
            repeatLabel.text = "Daily"
        }
    }
    
 }
