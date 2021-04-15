//
//  SearchViewController.swift
//  DiseaseDict
//
//  Created by Currie on 12/3/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SearchViewController: UIViewController {


    @IBOutlet var searchBarView: UISearchBar!
    @IBOutlet weak var resultTable: UITableView!
    
    private var diseases: [DiseaseModel] = []
    private var disease: DiseaseModel?
    private var bannerView = GADBannerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = " "
        
        searchBarView.delegate = self
        resultTable.delegate = self
        resultTable.dataSource = self
        
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
        
        getAllDiseases()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.titleView = searchBarView
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetail" {
            let vc =  segue.destination as! DetailDiseaseViewController
            vc.diseaseId = disease?.id
            vc.title = disease?.name
            navigationItem.backBarButtonItem?.title = " "
            navigationController?.navigationItem.backBarButtonItem?.title = " "
        }
    }
    
    func getAllDiseases() {
        DiseaseRealmService.shared.fetchAll { (diseases) in
            self.diseases = diseases
            self.resultTable.reloadData()
        }
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DiseaseRealmService.shared.search(searchText: searchBar.text!) { diseases in
            self.diseases = diseases
            self.resultTable.reloadData()
        }
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            getAllDiseases()
        } else {
            DiseaseRealmService.shared.search(searchText: searchText) { diseases in
                        self.diseases = diseases
                        self.resultTable.reloadData()
                    }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diseases.count + diseases.count/10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let disease = diseases[indexPath.row - indexPath.row/10]
//        if indexPath.row%10 == 0 && indexPath.row != 0{
//            let cell = UITableViewCell()
//            cell.contentView.addSubview(bannerView)
//            bannerView.translatesAutoresizingMaskIntoConstraints = false
//
//            bannerView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor).isActive = true
//            bannerView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor).isActive = true
//            bannerView.topAnchor.constraint(equalTo: cell.contentView.topAnchor).isActive = true
//            bannerView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
//            return cell
//        } else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "diseaseCell", for: indexPath) as! DiseaseViewCell
//            cell.imageDisease.setShadowStyle()
//            cell.imageDisease?.image = UIImage(named: "header-avatar")
//            cell.title.text = disease.name
//            cell.subTitle.text = disease.overview
//            cell.selectionStyle = .none
//            cell.disease = disease
//            return cell
//        }
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
        self.disease = diseases[indexPath.row - indexPath.row/10]
        self.performSegue(withIdentifier: "goToDetail", sender: self)
    }
}
