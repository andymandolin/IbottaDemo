//
//  DetailViewController.swift
//  IbottaDemo
//
//  Created by Andrew Geipel on 9/22/21.
//

import UIKit
import CoreData

protocol RefreshDataDelegate: AnyObject {
  func refreshData()
}

class DetailViewController: UIViewController {
    
    weak var refreshDataDelegate: RefreshDataDelegate?
    
    // MARK: - Properties
    var passedOffer: NSManagedObject?
    
    private let background: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.00)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let offerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.image = UIImage(named: "Profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let cashBackLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants().boldFont, size: 20.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.font = UIFont(name: Constants().regularFont, size: 16.0)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailsLbl: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 18
        label.font = UIFont(name:Constants().boldFont, size: 20.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Details"
        return label
    }()
    
    private let descriptionNameLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.textColor = UIColor.lightGray
        label.font = UIFont(name: Constants().regularFont, size: 16.0)
        label.textColor = Constants().greyTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let termsNameLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.textColor = UIColor.lightGray
        label.font = UIFont(name: Constants().regularFont, size: 16.0)
        label.textColor = Constants().greyTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
      
        return label
    }()
    
    private let favoriteBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private let dismissBtn: UIButton = {
        let button = UIButton()
        button.tintColor = .blue
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        setupInfo()
    }
    
    // MARK: - Actions
    
    @objc func buttonAction(sender: UIButton!) {
        
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)

        UIView.animate(withDuration: 2.0,
                                   delay: 0,
                                   usingSpringWithDamping: CGFloat(0.20),
                                   initialSpringVelocity: CGFloat(6.0),
                                   options: UIView.AnimationOptions.allowUserInteraction,
                                   animations: {
                                    sender.transform = CGAffineTransform.identity
            },
                                   completion: { Void in()  }
        )
        
        DataManager.sharedInstance.updateFavorite(product: passedOffer!)
        checkAndUpdateFavoritesButton()
        refreshDataDelegate?.refreshData()
    }
    
    @objc func dismissAction(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Private
    private func setupInfo() {
        
        if let cashBack = passedOffer?.value(forKey: "currentValue") as? String {
            cashBackLbl.text = cashBack
        }
        
        if let productName = passedOffer?.value(forKey: "name") as? String {
            nameLbl.text = productName
        }
        
        if let description = passedOffer?.value(forKey: "descript") as? String {
            descriptionNameLbl.text = description
        }
        
        if let terms = passedOffer?.value(forKey: "terms") as? String {
            termsNameLbl.text = terms
        }
        
        if let url = passedOffer?.value(forKey: "url") as? String {
            let pathURL = URL(string: url)
            self.offerImageView.downloaded(from: pathURL!)
        }
    }

    private func addViews(){
        
        view.backgroundColor = .white
        
        view.addSubview(background)
        view.addSubview(dismissBtn)
        view.addSubview(favoriteBtn)
        view.addSubview(nameLbl)

        view.addSubview(offerImageView)
        view.addSubview(cashBackLbl)
        view.addSubview(descriptionNameLbl)
        view.addSubview(detailsLbl)
        view.addSubview(termsNameLbl)
        
        favoriteBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        favoriteBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        favoriteBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1).isActive = true
        favoriteBtn.heightAnchor.constraint(equalTo: favoriteBtn.widthAnchor).isActive = true
        checkAndUpdateFavoritesButton()
        
        dismissBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        dismissBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        dismissBtn.widthAnchor.constraint(equalTo: favoriteBtn.widthAnchor, multiplier: 0.7).isActive = true
        dismissBtn.heightAnchor.constraint(equalTo: dismissBtn.widthAnchor).isActive = true
        
        nameLbl.leftAnchor.constraint(equalTo: dismissBtn.rightAnchor, constant: 4).isActive = true
        nameLbl.rightAnchor.constraint(equalTo: favoriteBtn.leftAnchor, constant: -4).isActive = true
        nameLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        
        background.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        background.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        background.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4).isActive = true
        
        offerImageView.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 6).isActive = true
        offerImageView.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -6).isActive = true
        offerImageView.topAnchor.constraint(equalTo: favoriteBtn.bottomAnchor, constant: 26).isActive = true
        offerImageView.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -16).isActive = true
        
        offerImageView.contentMode = .scaleAspectFit

        cashBackLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        cashBackLbl.topAnchor.constraint(equalTo: background.bottomAnchor, constant: 15).isActive = true

        descriptionNameLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        descriptionNameLbl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        descriptionNameLbl.topAnchor.constraint(equalTo: cashBackLbl.bottomAnchor, constant: 5).isActive = true
        
        detailsLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        detailsLbl.topAnchor.constraint(equalTo: descriptionNameLbl.bottomAnchor, constant: 12).isActive = true
        
        termsNameLbl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        termsNameLbl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        termsNameLbl.topAnchor.constraint(equalTo: detailsLbl.bottomAnchor, constant: 5).isActive = true
    }
    
    private func checkAndUpdateFavoritesButton() {
        let favoriteState = DataManager.sharedInstance.checkIsFavorite(product: passedOffer!)
        var action = UIImage()
        var tintColor = UIColor()
        
        if favoriteState == true {
            action = UIImage(systemName: "heart.fill")!
            tintColor = .systemRed
        } else {
            action = UIImage(systemName: "heart")!
            tintColor = Constants().greyTextColor
        }
        
        favoriteBtn.setBackgroundImage(action, for: .normal)
        favoriteBtn.tintColor = tintColor
    }
}


