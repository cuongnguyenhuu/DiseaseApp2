//
//  BookmarkViewController.swift
//  DiseaseDict
//
//  Created by Currie on 11/25/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController {

    private var diseases: [DiseaseModel] = [DiseaseModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        
        bookmarkTable.delegate = self
        bookmarkTable.dataSource = self
        // Do any additional setup after loading the view.
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        getData()
    }
    
    @IBOutlet weak var bookmarkTable: UITableView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func getData() {
        DiseaseRealmService.shared.getBookmarkDiseases { diseases in
            self.diseases = diseases
            bookmarkTable.reloadData()
        }
    }
    
    
}

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diseases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let disease = diseases[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "boolmarkCell", for: indexPath) as! BoolmarkViewCell
        cell.imageDisease?.image = UIImage(named: "header-avatar")
        cell.title.text = disease.name
        cell.subTitle.text = disease.overview
        cell.disease = disease
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToDetail", sender: self)
    }
}
