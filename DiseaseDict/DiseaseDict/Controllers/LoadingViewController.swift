//
//  LoadingViewController.swift
//  DiseaseDict
//
//  Created by Currie on 1/18/21.
//  Copyright © 2021 Currie. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    private let categoryService = CategoryService()
    private let diseaseService = DiseaseService()
    private let settingService = SettingService()
    var isCategoryLoaded = false
    var isDiseaseLoaded = false
    var isCloseAlert = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var isFirstTime: Bool = true
        
        if let isft = UserDefaults.standard.object(forKey: UserDefaultConfig.isFirstTime) as? Bool {
            isFirstTime = isft
            isCloseAlert = !isft
        }
        
        if isFirstTime {
            
            let alert = UIAlertController(title: "Alert", message: "This app just provides the information for you. It's not recommendation or suggestion.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "I got it", style: .cancel, handler: { action in
                self.dismiss(animated: true, completion: nil)
                self.isCloseAlert = true
                if self.isCategoryLoaded && self.isDiseaseLoaded && self.isCloseAlert {
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                }
            }))
            
            
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            UserDefaults.standard.setValue(false, forKey: UserDefaultConfig.isFirstTime)
        }
        
        self.settingService.getSettings { [self] setting, error in
            guard let setting = setting else {
                self.loadNewData(idNewData: nil)
                return
            }
            UserDefaults.standard.set(setting.isShowCategories, forKey: UserDefaultConfig.isShowCategories)
            UserDefaults.standard.set(setting.isShowAds, forKey: UserDefaultConfig.isShowAds)

            let oldHasNewData = UserDefaults.standard.string(forKey: UserDefaultConfig.hasNewData)
            if setting.hasNewData != oldHasNewData {
                print("Load new data")
                
                self.loadNewData(idNewData: setting.hasNewData)
            } else {
                print("This is newest data")
                self.isCategoryLoaded = true
                self.isDiseaseLoaded = true
                if self.isCategoryLoaded && self.isDiseaseLoaded && self.isCloseAlert {
                    performSegue(withIdentifier: "goToHome", sender: self)
                }
            }
        }
    }
    
    func loadNewData(idNewData: String?){
        let concurrentQueue = DispatchQueue(label: "com.some.concurrentQueue", attributes: .concurrent)
        
        concurrentQueue.sync {
            self.categoryService.getCategories { categories, error in
                
                if !error {
                    CategoryRealmService.shared.saveCategories(categories: categories) { finished in
                        self.isCategoryLoaded = true
                        if self.isCategoryLoaded && self.isDiseaseLoaded && self.isCloseAlert {
                            if idNewData != nil {
                                UserDefaults.standard.set(idNewData, forKey: UserDefaultConfig.hasNewData)
                            }
                            self.performSegue(withIdentifier: "goToHome", sender: self)
                        }
                    }
                } else {
                    self.isCategoryLoaded = true
                    if self.isCategoryLoaded && self.isDiseaseLoaded && self.isCloseAlert {
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                }
            }
        }
        concurrentQueue.sync {
            self.diseaseService.getAllDiseases { diseases, error in
                if !error {
                    DiseaseRealmService.shared.saveAll(diseases: diseases) {  finished in
                        self.isDiseaseLoaded = true
                        if self.isCategoryLoaded && self.isDiseaseLoaded && self.isCloseAlert {
                            if idNewData != nil {
                                UserDefaults.standard.set(idNewData, forKey: UserDefaultConfig.hasNewData)
                            }
                            self.performSegue(withIdentifier: "goToHome", sender: self)
                        }
                    }
                } else {
                        self.isDiseaseLoaded = true
                    if self.isCategoryLoaded && self.isDiseaseLoaded && self.isCloseAlert {
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    }
                }
            }
        }
    }

}
