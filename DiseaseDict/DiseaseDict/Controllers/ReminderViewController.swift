 //
//  ReminderViewController.swift
//  DiseaseDict
//
//  Created by Currie on 11/25/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit
import SoftUIView

class ReminderViewController: UIViewController, UITextViewDelegate {
    
    private var datePicker = UIDatePicker()
    private var timePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
        dateField.borderTextFieldStyle()
        dateField.delegate = self
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        dateField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        addToolBar(textField: dateField)
        dateField.tag = 0
        dateField.text = dateFormart(date: Date())
        
        timeField.borderTextFieldStyle()
        timeField.delegate = self
        timePicker.datePickerMode = .time
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
    }
    
    func setupNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
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
        if timeInterval > 0 && !contentTextView.text.isEmpty {
            let content = UNMutableNotificationContent()
            content.title = "REMINDER!"
            content.subtitle = "Take a look."
            content.body = contentTextView.text
            content.sound = UNNotificationSound.default
            let badgeNumber = UserDefaults.standard.integer(forKey: "bagdeNumber") + 1
            content.badge = NSNumber(value: badgeNumber)
            UserDefaults.standard.set(badgeNumber, forKey: "bagdeNumber")
        // show this notification five seconds from now
        
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            // choose a random identifier
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            // add our notification request
            UNUserNotificationCenter.current().add(request)
            
            navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Invalid Error!", message: "Please fill correctly!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

 extension ReminderViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
//        navigationController?.popViewController(animated: true)
        return false
    }
 }
