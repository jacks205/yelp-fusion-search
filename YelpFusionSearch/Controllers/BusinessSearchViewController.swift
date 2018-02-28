//
//  ViewController.swift
//  YelpFusionSearch
//
//  Created by Mark Jackson on 2/27/18.
//  Copyright © 2018 Mark Jackson. All rights reserved.
//

import UIKit

class BusinessSearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let topRefreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.tintColor = .black
        return rc
    }()
    
    private let viewModel = BusinessSearchViewModel()
    private var businesses: [Business] {
        return viewModel.businesses
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureCollectionView()
        topRefreshControl.addTarget(self, action: #selector(BusinessSearchViewController.refreshNearbyBusinessesList), for: UIControlEvents.valueChanged)
        collectionView.refreshControl = topRefreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.requestLocation()
        viewModel.search(withTerm: "sushi") { [weak self] (result, error) in
            self?.collectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        imageCache.removeAllObjects()
        viewModel.buisinessSearchResults = nil
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(BusinessCollectionViewCell.self, forCellWithReuseIdentifier: BusinessCollectionViewCell.reuseIdentifier)
    }
    
    @objc func refreshNearbyBusinessesList() {
        viewModel.search(withTerm: "sushi") { [weak self] (result, error) in
            self?.topRefreshControl.endRefreshing()
            self?.collectionView.reloadData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // For pushing UIRefreshControl to the back of subviews
        collectionView.sendSubview(toBack: topRefreshControl)
    }
}

// MARK: - UICollectionViewDelegate

extension BusinessSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return businesses.count
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

// MARK: - UICollectionViewDataSource

extension BusinessSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: BusinessCollectionViewCell.reuseIdentifier, for: indexPath) as! BusinessCollectionViewCell
        let business = businesses[indexPath.row]
        
//        collectionViewCell.backgroundColor = Colors.Purple.dark
        collectionViewCell.business = business
        
        // Download and cache image, then set to cv image view.
        DispatchQueue.global().async {
            if  let imageURL = business.imageURL {
                UIImage.downloadImage(fromURL: imageURL, useCache: true, completion: { image in
                    DispatchQueue.main.sync {
                        collectionViewCell.businessImage = image
                    }
                })
            }
        }
        return collectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // If the last cell shows, load in more top games.
//        if indexPath.row == businesses.count - 1 {
//            refreshNearbyBusinessesList()
//        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension BusinessSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 3 games per row, divide cv width by 3 minus edge insets
        let width = collectionView.bounds.width / 3.0 - 16
        // If cell doesn't exist yet, set default size
        guard   let cell = collectionView.cellForItem(at: indexPath) as? BusinessCollectionViewCell,
            let imageHeight = cell.imageViewHeightConstraint?.constant else {
                let height = width * 1.7
                return CGSize(width: width, height: height)
        }
        // Set size according to content in cell
        let businessNameLabelHeight = cell.businessNameLabel.frame.height
        let distanceLabelHeight = cell.distanceLabel.frame.height
        let newSize = CGSize(width: width, height: imageHeight + businessNameLabelHeight + distanceLabelHeight)
        
        return newSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

// MARK: - Utilities

extension BusinessSearchViewController {
    

}


