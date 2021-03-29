//
//  ReminderListViewController.swift
//  DiseaseDict
//
//  Created by Currie on 1/18/21.
//  Copyright © 2021 Currie. All rights reserved.
//

import UIKit

class ReminderListViewController: UIViewController {

    @IBOutlet weak var ReminderTable: UITableView!
    
    private var reminders = [ReminderModel]()
    private var listRequest:[UNNotificationRequest] = [UNNotificationRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ReminderTable.delegate = self
        ReminderTable.dataSource = self
        ReminderTable.estimatedRowHeight = 120
        ReminderTable.rowHeight = UITableView.automaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Reminders"
        UNUserNotificationCenter.current().getPendingNotificationRequests{ (notifies) in
            self.listRequest = notifies
        }
        
        DispatchQueue.main.async {
            ReminderRealmService.shared.fetchReminders(notifis: self.listRequest) { (reminders) in
                self.reminders = reminders
                self.ReminderTable.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
    }
}

extension ReminderListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reminder = reminders[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell") as! ReminderCell
        cell.title.text = reminder.title
        cell.notes.text = reminder.content
        cell.time.text = reminder.time
        cell.day.text = String(reminder.date.split(separator: "-")[1])
        cell.monthAndYear.text = String(reminder.date.split(separator: "-")[0]) + "-" + String(reminder.date.split(separator: "-")[2])
        let ar = Util.share.convertStringToArray(str: reminder.repeats)
        var string = ""
        for i in 0..<ar.count{
            if ar[i] == 1 {
                string += UserDefaultConfig.repeatList[i] + " "
            }
        }
        if string.split(separator: " ").count == 7 {
            string = "Daily"
        }
        if string.isEmpty {
            string = "Once"
        }
        cell.repeats.text = string
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let ids = reminders[indexPath.row].id.split(separator: ",").map{String($0)}
            print(ids)
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
            ReminderRealmService.shared.removeReminder(reminder: reminders[indexPath.row]) { _ in
                
            }
            reminders.remove(at: indexPath.row)
            ReminderTable.reloadData()
        }
    }
    
}
