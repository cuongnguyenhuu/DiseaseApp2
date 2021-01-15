//
//  HomeViewController.swift
//  DiseaseDict
//
//  Created by Currie on 11/25/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit
import ImageSlideshow
import SoftUIView

class HomeViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var sliderView: UIView!
    
//    @IBOutlet weak var functionCollectionView: UICollectionView!
    
    private var currentIndex = 0
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 15
//    private var contentWidth: CGFloat {
//      guard let catalogueTable = functionCollectionView else {
//        return 0
//      }
//      let insets = catalogueTable.contentInset
//        return (catalogueTable.bounds.width - (insets.left * (CGFloat(numberOfColumns)+1)))/CGFloat(numberOfColumns)
//    }
    @IBOutlet weak var dictionaryView: UIView!
    @IBOutlet weak var reminderView: UIView!
    @IBOutlet weak var predictView: UIView!
    @IBOutlet weak var bookmarkView: UIView!
    
    @IBOutlet weak var dicSoftView: SoftUIView!
    @IBOutlet weak var reminderSoftView: SoftUIView!
    @IBOutlet weak var predictSoftView: SoftUIView!
    @IBOutlet weak var bookmarkSoftView: SoftUIView!
    
    private var listFunction: [FunctionModel] = [
        FunctionModel(icon: UIImage(named: "dictionary-1")!, title: "Dictionary"),
        FunctionModel(icon: UIImage(named: "reminder")!, title: "Reminder"),
        FunctionModel(icon: UIImage(named: "search-1")!, title: "Prediction"),
        FunctionModel(icon: UIImage(named: "bookmark-1")!, title: "Bookmark")
    ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
        
//        functionCollectionView.delegate = self
//        functionCollectionView.dataSource = self
//        functionCollectionView.contentInset = UIEdgeInsets(top: cellPadding, left: cellPadding, bottom: cellPadding, right: cellPadding)
//        functionCollectionView.backgroundColor = .clear
        
        addSlider()

        sliderView.setShadowStyle()
        searchView.layer.cornerRadius = 30
        searchView.setShadowStyle()
        searchView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchViewDidTap)))
        
        dicSoftView.mainColor = UIColor(named: "orange")!.cgColor
        bookmarkSoftView.mainColor = UIColor(named: "orange")!.cgColor
        reminderSoftView.mainColor = UIColor.white.cgColor
        predictSoftView.mainColor = UIColor.white.cgColor
        
        dictionaryView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDictionary)))
        reminderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapReminder)))
        predictView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPrediction)))
        bookmarkView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBookmark)))
    }
    
    @objc func didTapDictionary(){
        self.performSegue(withIdentifier: "goToCatalogue", sender: self)
    }
    
    @objc func didTapReminder(){
        self.performSegue(withIdentifier: "goToReminder", sender: self)
    }
    
    @objc func didTapPrediction(){
        self.performSegue(withIdentifier: "goToCatalogue", sender: self)
    }
    
    @objc func didTapBookmark(){
        self.performSegue(withIdentifier: "goToBookmark", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.tintColor = .gray
    }
    
    private func addSlider(){
        let slideShow = ImageSlideshow()
        slideShow.setImageInputs(
            [
                ImageSource(image: UIImage(named: "slider")!),
                ImageSource(image: UIImage(named: "slider1")!),
                ImageSource(image: UIImage(named: "slider2")!)
            ]
        )
        
        sliderView.layer.cornerRadius = 15.0
        slideShow.layer.cornerRadius = 15.0
        slideShow.contentScaleMode = .scaleAspectFill
        
        sliderView.addSubview(slideShow)
        slideShow.translatesAutoresizingMaskIntoConstraints = false
        
        slideShow.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor).isActive = true
        slideShow.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor).isActive = true
        slideShow.topAnchor.constraint(equalTo: sliderView.topAnchor).isActive = true
        slideShow.bottomAnchor.constraint(equalTo: sliderView.bottomAnchor).isActive = true
    }
    
    @objc func searchViewDidTap(_ sender: UITextField) {
        self.performSegue(withIdentifier: "goToSearch", sender: self)
    }
    
    @IBAction func didTapNotification(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToSearch", sender: self)
    }
    
}

//extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return listFunction.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let fun = listFunction[indexPath.row]
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "functionCell", for: indexPath) as! FunctionViewCell
//        cell.contentView.layer.masksToBounds = false
//        cell.contentView.clipsToBounds = false
//        cell.imageFunction.image = fun.icon
//        cell.titleLabel.text = fun.title
//        cell.layer.cornerRadius = 30.0
//        cell.softView.cornerRadius = 30
//        cell.softView.isUserInteractionEnabled = false
////        cell.bgView.layer.cornerRadius = 30.0
////        cell.layer.borderWidth = 2
////        cell.layer.borderColor = UIColor(white: 0, alpha: 0.05).cgColor
//        if currentIndex == indexPath.row {
//            cell.softView.mainColor = UIColor(named: "orange")!.cgColor
//            cell.titleLabel.textColor = .white
//            currentIndex += 3
//        } else {
//            cell.softView.mainColor = UIColor(named: "white")!.cgColor
//            cell.titleLabel.textColor = .black
//        }
//        cell.setShadowStyle()
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            self.performSegue(withIdentifier: "goToCatalogue", sender: self)
//        case 1:
//            self.performSegue(withIdentifier: "goToReminder", sender: self)
//        case 3:
//            self.performSegue(withIdentifier: "goToBookmark", sender: self)
//        default:
//            break
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: contentWidth, height: 150)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        cellPadding
//    }
//}
