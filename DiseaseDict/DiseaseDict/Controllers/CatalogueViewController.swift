//
//  CatalogueViewController.swift
//  DiseaseDict
//
//  Created by Currie on 11/25/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit
import Kingfisher
import SoftUIView
import GoogleMobileAds

class CatalogueViewController: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 30
    private var categories: [CategoryModel] = []
    private var categorySelected: CategoryModel?
    private var contentWidth: CGFloat {
      guard let catalogueTable = catalogueTable else {
        return 0
      }
      let insets = catalogueTable.contentInset
        return (catalogueTable.bounds.width - (insets.left * (CGFloat(numberOfColumns)+1)))/CGFloat(numberOfColumns)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        bannerView.rootViewController = self
//        bannerView.load(GADRequest())
        
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        catalogueTable.backgroundColor = .clear
        
        catalogueTable.delegate = self
        catalogueTable.dataSource = self
        catalogueTable.contentInset = UIEdgeInsets(top: cellPadding, left: cellPadding, bottom: cellPadding, right: cellPadding)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        CategoryRealmService.shared.fetchCategories { categories in
            self.activityIndicator.stopAnimating()
            self.categories = categories
            self.catalogueTable.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBOutlet weak var catalogueTable: UICollectionView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc =  segue.destination as! AlphabetViewController
        vc.id = categorySelected?.id
        vc.title = categorySelected?.name
    }
}

extension CatalogueViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = categories[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catalogueCell", for: indexPath) as! CatalogueViewCell
        cell.contentView.layer.masksToBounds = false
        cell.contentView.clipsToBounds = false
        cell.iconImage.kf.setImage(with: URL(string: category.image!))
        cell.title.text = category.name
        cell.contentView.layer.cornerRadius = 20
        cell.softView.cornerRadius = 30
        cell.softView.mainColor = UIColor.white.cgColor
        cell.softView.isUserInteractionEnabled = false
        cell.contentView.setShadowStyle()
        cell.setShadowStyle()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.categorySelected = categories[indexPath.row]
        self.performSegue(withIdentifier: "goToAlphaBet", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentWidth, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        cellPadding
    }
}
