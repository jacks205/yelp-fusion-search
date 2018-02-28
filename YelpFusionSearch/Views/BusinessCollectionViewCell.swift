//
//  BusinessCollectionViewCell.swift
//  YelpFusionSearch
//
//  Created by Mark Jackson on 2/27/18.
//  Copyright © 2018 Mark Jackson. All rights reserved.
//

import UIKit

class BusinessCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "BusinessCollectionViewCell"
    
    var business: Business?
    
    var businessImage: UIImage? {
        set { imageView.image = newValue  }
        get { return imageView.image }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = UIViewContentMode.scaleAspectFit
        iv.layer.cornerRadius = 4
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let businessNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        lbl.textColor = .white
        return lbl
    }()
    
    let distanceLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 10)
        lbl.textColor = .lightGray
        return lbl
    }()
    
    var imageViewHeightConstraint: NSLayoutConstraint?
    
    override var reuseIdentifier: String? {
        return BusinessCollectionViewCell.reuseIdentifier
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
    }
    
    func setUpViews() {
        addSubviews()
        setContraints()
    }
    
    func addSubviews() {
        addSubview(imageView)
        addSubview(businessNameLabel)
        addSubview(distanceLabel)
    }
    
    func setContraints() {
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 0)
        imageViewHeightConstraint?.isActive = true
        
        businessNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4).isActive = true
        businessNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        businessNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        distanceLabel.topAnchor.constraint(equalTo: businessNameLabel.bottomAnchor).isActive = true
        distanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        distanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set image view height constraint according to correct aspect ratio of image.
        if let businessImage = businessImage {
            let width = frame.width
            let imageWidth = businessImage.size.width
            let imageHeight = businessImage.size.height
            let newImageHeight = imageHeight / imageWidth * width
            imageViewHeightConstraint?.constant = newImageHeight
        }
        if let business = business {
            businessNameLabel.text = business.name
            distanceLabel.text = "\(business.distance) away"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        businessImage = nil
        business = nil
    }
}

