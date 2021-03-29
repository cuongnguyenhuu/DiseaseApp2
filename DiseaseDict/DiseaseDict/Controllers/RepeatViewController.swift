//
//  RepeatViewController.swift
//  DiseaseDict
//
//  Created by Currie on 1/18/21.
//  Copyright © 2021 Currie. All rights reserved.
//

import UIKit
import SoftUIView

protocol RepeatDelegate {
    func selectedIndexes(indexes: [Int])
}

class RepeatViewController: UIViewController {

    private var indexSelected = [0,0,0,0,0,0,0]
    var delegate: RepeatDelegate?
    
    @IBOutlet weak var repeatTable: UITableView!
    @IBOutlet weak var softView: SoftUIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        repeatTable.delegate = self
        repeatTable.dataSource = self
        softView.mainColor = UIColor(named: "orange")?.cgColor ?? UIColor.orange.cgColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.selectedIndexes(indexes: indexSelected)
    }

    @IBAction func didTapDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension RepeatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserDefaultConfig.repeatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatCell") as! RepeatCell
        cell.repeatLabel.text = UserDefaultConfig.repeatList[indexPath.row]
        if indexSelected[indexPath.row] == 0 {
            cell.imgCheck.isHidden = true
        } else {
            cell.imgCheck.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexSelected[indexPath.row] = indexSelected[indexPath.row] == 0 ? 1 : 0
        tableView.reloadData()
    }
}
