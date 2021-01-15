//
//  DetailDiseaseViewController.swift
//  DiseaseDict
//
//  Created by Currie on 11/25/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit
import ImageSlideshow

class DetailDiseaseViewController: UIViewController {

    private let diseaseService = DiseaseService()
    private var disease:DiseaseDetailModel?
    private var data = Dictionary<String, String>()
//    private var isFinis: Int = 0
    
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
        
        segmentView.isHidden = true
        segmentView.removeAllSegments()
        
        getDisease()
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
        shouldTrackingScrolling = false
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.shouldTrackingScrolling = true
//        }
        
    }
    
    private var shouldTrackingScrolling = true
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
            if n<4{
                self.segmentView.insertSegment(withTitle: self.data.keys[self.data.index(self.data.startIndex, offsetBy: n)], at: n, animated: true)
            }
        }
    }
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//    }
    
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.segmentView.selectedSegmentIndex == self.detailTable.indexPathsForVisibleRows?.first?.section as! Int {
            shouldTrackingScrolling = true
        }
        if shouldTrackingScrolling {
            DispatchQueue.main.async {
                self.segmentView.selectedSegmentIndex = self.detailTable.indexPathsForVisibleRows?.first?.section as! Int
//                self.oldSegmentIndex = self.detailTable.indexPathsForVisibleRows?.first?.section as! Int
            }
        }
        hightOfSlider.constant = (200 - scrollView.contentOffset.y) > 200 ? 200 : (200 - scrollView.contentOffset.y) < 0 ? 0 : (200 - scrollView.contentOffset.y)
        
        if (20 + scrollView.contentOffset.y)/70 > 1 {
            paddingTopOfTable.constant = 70
        } else if (20 + scrollView.contentOffset.y)/70 < 0 {
            paddingTopOfTable.constant = 20
        } else {
            paddingTopOfTable.constant = (20 + scrollView.contentOffset.y)
        }
        
        if scrollView.contentOffset.y > 200 {
            segmentView.isHidden = false
        } else {
            segmentView.isHidden = true
        }
    }
    
}
