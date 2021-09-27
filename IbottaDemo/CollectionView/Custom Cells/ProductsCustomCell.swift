//
//  OffersCustomCell.swift
//  IbottaDemo
//
//  Created by Andrew Geipel on 9/22/21.
//

import UIKit

class ProductsCustomCell: UICollectionViewCell {

    // MARK: - Properties
    
    var favoriteButton: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .systemRed
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let cashBackLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 12)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let productNameLbl: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = UIFont(name: "AvenirNext-Regular", size: 11)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let background: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.00)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
    }()

    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private
    
    private func addViews(){
        
        addSubview(productNameLbl)
        addSubview(cashBackLbl)
        addSubview(background)
        addSubview(productImageView)
        addSubview(favoriteButton)

        productNameLbl.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        productNameLbl.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        productNameLbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        cashBackLbl.leftAnchor.constraint(equalTo: productNameLbl.leftAnchor).isActive = true
        cashBackLbl.rightAnchor.constraint(equalTo: productNameLbl.rightAnchor).isActive = true
        cashBackLbl.bottomAnchor.constraint(equalTo: productNameLbl.topAnchor, constant: -3).isActive = true
        
        background.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        background.topAnchor.constraint(equalTo: topAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: cashBackLbl.topAnchor, constant: -8).isActive = true
        
        productImageView.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 6).isActive = true
        productImageView.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -6).isActive = true
        productImageView.topAnchor.constraint(equalTo: background.topAnchor, constant: 6).isActive = true
        productImageView.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -6).isActive = true
        productImageView.contentMode = .scaleAspectFit

        favoriteButton.rightAnchor.constraint(equalTo: rightAnchor, constant: 2).isActive = true
        favoriteButton.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        favoriteButton.heightAnchor.constraint(equalToConstant: 36).isActive = true
        favoriteButton.widthAnchor.constraint(equalToConstant: 36).isActive = true
    }
}

