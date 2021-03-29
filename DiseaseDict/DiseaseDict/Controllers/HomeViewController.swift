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
import GoogleMobileAds

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var dictionaryView: UIView!
    @IBOutlet weak var reminderView: UIView!
    @IBOutlet weak var predictView: UIView!
    @IBOutlet weak var bookmarkView: UIView!
    @IBOutlet weak var dicSoftView: SoftUIView!
    @IBOutlet weak var reminderSoftView: SoftUIView!
    @IBOutlet weak var predictSoftView: SoftUIView!
    @IBOutlet weak var bookmarkSoftView: SoftUIView!
    @IBOutlet weak var username: UILabel!
    
    private var currentIndex = 0
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 15
    var isFirstTime: Bool = true
    let bannerView2 = GADBannerView()
    let alertName = UIAlertController(title: "Your nick name", message: "Set a nick name", preferredStyle: .alert)
    
    private var listFunction: [FunctionModel] = [
        FunctionModel(icon: UIImage(named: "dictionary-1")!, title: "Dictionary"),
        FunctionModel(icon: UIImage(named: "reminder")!, title: "Reminder"),
        FunctionModel(icon: UIImage(named: "search-1")!, title: "Prediction"),
        FunctionModel(icon: UIImage(named: "bookmark-1")!, title: "Bookmark")
    ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        bannerView2.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView2.rootViewController = self
        bannerView2.load(GADRequest())
        
        self.navigationController?.isNavigationBarHidden = true
        
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
        
        if let name = UserDefaults.standard.string(forKey: UserDefaultConfig.username) {
            if !name.isEmpty {
                self.username.text = name
            }
        }
        
        alertName.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Optional"
        }
        
        alertName.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            let textfield = self.alertName.textFields![0]
            if !textfield.text!.trimmingCharacters(in: .whitespaces).isEmpty {
                UserDefaults.standard.set(textfield.text, forKey: UserDefaultConfig.username)
                self.username.text = textfield.text
            } else {
                UserDefaults.standard.set("Guest!", forKey: UserDefaultConfig.username)
                self.username.text = "Guest!"
            }
            self.isFirstTime = false
            
        }))
        
        alertName.addAction(UIAlertAction(title: "Skip", style: .destructive, handler: { action in
            if self.isFirstTime {
                UserDefaults.standard.set("Guest!", forKey: UserDefaultConfig.username)
            }
        }))
        
        if let isft = UserDefaults.standard.string(forKey: UserDefaultConfig.username) {
            isFirstTime = isft.isEmpty
        }
        
        if isFirstTime {
            present(alertName, animated: true, completion: nil)
        }
        
        username.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapChangeName)))
    }
    
    @objc func didTapChangeName(sender: UILabel){
        present(alertName, animated: true, completion: nil)
    }
    
    @objc func didTapDictionary(){
        if UserDefaults.standard.bool(forKey: UserDefaultConfig.isShowCategories) {
            self.performSegue(withIdentifier: "goToCatalogue", sender: self)
        } else {
            let vc = UIStoryboard(name: "Catalogue", bundle: nil).instantiateViewController(withIdentifier: "Alphabet") as! AlphabetViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func didTapReminder(){
//        self.performSegue(withIdentifier: "goToReminder", sender: self)
    }
    
    @objc func didTapPrediction(){
//        self.performSegue(withIdentifier: "goToCatalogue", sender: self)
        self.performSegue(withIdentifier: "goToReminder", sender: self)
    }
    
    @objc func didTapBookmark(){
        self.performSegue(withIdentifier: "goToBookmark", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.tintColor = .gray
    }
    
    private func addSlider(){
        
        sliderView.layer.cornerRadius = 15.0
        bannerView2.layer.cornerRadius = 15.0
        
        sliderView.addSubview(bannerView2)
        bannerView2.translatesAutoresizingMaskIntoConstraints = false
        
        bannerView2.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor).isActive = true
        bannerView2.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor).isActive = true
        bannerView2.topAnchor.constraint(equalTo: sliderView.topAnchor).isActive = true
        bannerView2.bottomAnchor.constraint(equalTo: sliderView.bottomAnchor).isActive = true
    }
    
    @objc func searchViewDidTap(_ sender: UITextField) {
        self.performSegue(withIdentifier: "goToSearch", sender: self)
    }
    
    @IBAction func didTapNotification(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToSearch", sender: self)
    }
    
}

extension HomeViewController: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Did receive ad")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Error")
        print(error)
    }
}
