//
//  AlphabetViewController.swift
//  DiseaseDict
//
//  Created by Currie on 11/25/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit

class AlphabetViewController: UIViewController {

    private let diseaseService = DiseaseService()
    private var diseases: [DiseaseModel] = []
    private var disease: DiseaseModel?
    var id: String?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        alphabetTable.delegate = self
        alphabetTable.dataSource = self
        alphabetTable.isHidden = true
        
        searchField.borderTextFieldStyle()
        searchField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if searchField.text!.isEmpty {
            if UserDefaults.standard.bool(forKey: UserDefaultConfig.isShowCategories) {
                DiseaseRealmService.shared.getDiseaseByCategory(id: id ?? "") { disease in
                    self.activityIndicator.stopAnimating()
                    self.alphabetTable.isHidden = false
                    self.diseases = disease
                    self.alphabetTable.reloadData()
                }
            } else {
                DiseaseRealmService.shared.fetchAll { disease in
                    self.activityIndicator.stopAnimating()
                    self.alphabetTable.isHidden = false
                    self.diseases = disease
                    self.alphabetTable.reloadData()
                }
            }
        } else {
            activityIndicator.startAnimating()
            alphabetTable.isHidden = true
            DiseaseRealmService.shared.search(searchText: searchField.text!) { diseases in
                self.diseases = diseases
                self.alphabetTable.isHidden = false
                self.alphabetTable.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var alphabetTable: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            let vc =  segue.destination as! DetailDiseaseViewController
            vc.diseaseId = disease?.id
            vc.title = disease?.name
        }
    }
}

extension AlphabetViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diseases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let disease = diseases[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "diseaseCell", for: indexPath) as! DiseaseViewCell
        cell.imageDisease.setShadowStyle()
        cell.imageDisease?.image = UIImage(named: "header-avatar")
        cell.title.text = disease.name
        cell.subTitle.text = disease.overview
        cell.selectionStyle = .none
        cell.disease = disease
        return cell
        
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.disease = diseases[indexPath.row]
        self.performSegue(withIdentifier: "goToDetail", sender: self)
    }
    
    
}

extension AlphabetViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        guard let keyword = textField.text else {
            return false
        }
        if !keyword.isEmpty {
            activityIndicator.startAnimating()
            alphabetTable.isHidden = true
            DiseaseRealmService.shared.search(searchText: keyword) { diseases in
                self.diseases = diseases
                self.alphabetTable.isHidden = false
                self.alphabetTable.reloadData()
                self.activityIndicator.stopAnimating()
            }
        } else {
            DiseaseRealmService.shared.getDiseaseByCategory(id: "") { disease in
                self.activityIndicator.stopAnimating()
                self.alphabetTable.isHidden = false
                self.diseases = disease
                self.alphabetTable.reloadData()
            }
        }
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let keyword = textField.text else {
            return
        }
        if !keyword.isEmpty {
            activityIndicator.startAnimating()
            alphabetTable.isHidden = true
            DiseaseRealmService.shared.search(searchText: keyword) { diseases in
                self.diseases = diseases
                self.alphabetTable.isHidden = false
                self.alphabetTable.reloadData()
                self.activityIndicator.stopAnimating()
            }
        } else {
            DiseaseRealmService.shared.getDiseaseByCategory(id: "") { disease in
                self.activityIndicator.stopAnimating()
                self.alphabetTable.isHidden = false
                self.diseases = disease
                self.alphabetTable.reloadData()
            }
        }
    }
}
