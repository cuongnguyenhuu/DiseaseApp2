//
//  DetailDiseaseViewController.swift
//  DiseaseDict
//
//  Created by Currie on 11/25/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit
import ImageSlideshow
import ScrollableSegmentedControl
import SoftUIView
import GoogleMobileAds

class DetailDiseaseViewController: UIViewController {
    
    private let diseaseService = DiseaseService()
    private var disease:DiseaseDetailModel?
    private var data = Dictionary<String, String>()
    
    @IBOutlet weak var segmentedControl: ScrollableSegmentedControl!
    @IBOutlet weak var softView: SoftUIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailTable.delegate = self
        detailTable.dataSource = self
        detailTable.isHidden = true
        detailTable.estimatedRowHeight = 10
        detailTable.rowHeight = UITableView.automaticDimension
        
        let slideShow = ImageSlideshow()
        slideShow.setImageInputs(
            [
                ImageSource(image: UIImage(named: "header-avatar")!),
                ImageSource(image: UIImage(named: "header-avatar")!),
                ImageSource(image: UIImage(named: "header-avatar")!)
            ]
        )
        
        sliderView.addSubview(slideShow)
        slideShow.translatesAutoresizingMaskIntoConstraints = false
        
        slideShow.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor).isActive = true
        slideShow.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor).isActive = true
        slideShow.topAnchor.constraint(equalTo: sliderView.topAnchor).isActive = true
        slideShow.bottomAnchor.constraint(equalTo: sliderView.bottomAnchor).isActive = true
        
        segmentView.removeAllSegments()
        
        getDisease()
        
        segmentedControl.segmentStyle = .textOnly
        segmentedControl.underlineSelected = true
        segmentedControl.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
        segmentedControl.fixedSegmentWidth = false
        
        softView.mainColor = UIColor.white.cgColor
    }
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        if self.shouldTrackingTab {
            self.detailTable.setContentOffset(self.detailTable.contentOffset, animated: false)
            DispatchQueue.main.async {
                self.detailTable.scrollToRow(at: IndexPath(row: 0, section: sender.selectedSegmentIndex), at: .top, animated: true)
            }
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var sliderView: UIView!
    
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    @IBOutlet weak var detailTable: UITableView!
    
    @IBOutlet weak var hightOfSlider: NSLayoutConstraint!
    
    @IBOutlet weak var paddingTopOfTable: NSLayoutConstraint!
    
    @IBAction func segmentDidChange(_ sender: Any) {
        self.detailTable.setContentOffset(self.detailTable.contentOffset, animated: false)
        DispatchQueue.main.async {
            self.detailTable.scrollToRow(at: IndexPath(row: 0, section: self.segmentView.selectedSegmentIndex), at: .top, animated: true)
        }
    }
    
    private var shouldTrackingTab = true
    var diseaseId: String?
    
    func getDisease(){
        guard let id  = self.diseaseId else {
            return
        }
        diseaseService.getDiseaseById(id: id) { disease in
            //            print(disease)
            self.disease = disease
            self.data = disease.prepareData()
            self.activityIndicator.stopAnimating()
            self.detailTable.isHidden = false
            self.setup()
        }
    }
    
    func setup() {
        guard let disease = self.disease else {
            return
        }
        
        self.title = disease.name
        if data.count > 0 {
            self.detailTable.reloadData()
        } else {
            self.detailTable.isHidden = true
        }
        
        for n in 0..<self.data.count {
            //            if n<4{
            self.segmentedControl.insertSegment(withTitle: self.data.keys[self.data.index(self.data.startIndex, offsetBy: n)], at: n)
            //            }
            self.segmentedControl.selectedSegmentIndex = 0
        }
    }
    
}

extension DetailDiseaseViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailViewCell
        cell.contentText.attributedText = self.data[self.data.keys[self.data.index(self.data.startIndex, offsetBy: indexPath.section)]]?.htmlToAttributedString
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = UIView()
        sectionView.backgroundColor = .white
        let sectionLabel = UILabel()
        sectionLabel.text = self.data.keys[self.data.index(self.data.startIndex, offsetBy: section)]
        sectionLabel.textColor = .green
        sectionLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        sectionLabel.backgroundColor = .white
        sectionView.addSubview(sectionLabel)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionLabel.centerYAnchor.anchorWithOffset(to: sectionView.centerYAnchor)
        sectionLabel.leadingAnchor.constraint(equalTo: sectionView.leadingAnchor, constant: 20).isActive = true
        return sectionView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.shouldTrackingTab = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.shouldTrackingTab = true
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.shouldTrackingTab = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !self.shouldTrackingTab {
            DispatchQueue.main.async {
                self.segmentedControl.selectedSegmentIndex = self.detailTable.indexPathsForVisibleRows?.first?.section as! Int
            }
        }
    }
}
