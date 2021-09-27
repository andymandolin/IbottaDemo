//
//  HomeViewController.swift
//  IbottaDemo
//
//  Created by Andrew Geipel on 9/22/21.
//

import UIKit
import CoreData

class OffersViewController: UIViewController, UIGestureRecognizerDelegate, RefreshDataDelegate {

    // MARK: - Delegate Methods
    
    func refreshData() {
        self.offersCollectionView.reloadData()
     }

    // MARK: - Properties
    
    lazy var arrOffers : [NSManagedObject] = []
    var offersCollectionView: UICollectionView!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupLongGestureRecognizerOnCollection()
        getOffers()
        
        view.backgroundColor = .white
    }
    
    // MARK: - Private
    
    private func setupCollectionView() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        offersCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    
        offersCollectionView.showsVerticalScrollIndicator = false
        
        offersCollectionView.register(OffersCustomCell.self, forCellWithReuseIdentifier: "Cell")
        
        offersCollectionView.dataSource = self
        offersCollectionView.delegate = self
        offersCollectionView.backgroundColor = UIColor.clear
        
        self.view.addSubview(offersCollectionView)
    }
    
    private func setupLongGestureRecognizerOnCollection() {
        
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        offersCollectionView.addGestureRecognizer(longPressedGesture)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        
        if (gestureRecognizer.state != .began) {
            return
        }
        
        let tap = gestureRecognizer.location(in: offersCollectionView)
        
        if let indexPath = offersCollectionView?.indexPathForItem(at: tap) {
            let alert = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to remove this item?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    
                    DataManager.sharedInstance.delete(object: self.arrOffers[indexPath.row])
                    self.arrOffers = DataManager.sharedInstance.fetchAllOffers()
                    self.offersCollectionView.reloadData()
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                @unknown default:
                    print("unkown default")
                }
            }))
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
            })
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func getOffers() {
        arrOffers = DataManager.sharedInstance.fetchAllOffers()
    }
}

    // MARK: - CollectionView

extension OffersViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrOffers.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! OffersCustomCell

        if let name = arrOffers[indexPath.row].value(forKey: "name") as? String {
            cell.offerNameLbl.text = name
        }
        
        if let name = arrOffers[indexPath.row].value(forKey: "currentValue") as? String {
            cell.cashBackLbl.text = name
        }
        
        if arrOffers[indexPath.row].value(forKey: "isFavorite") as? Bool == true {
            cell.favoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            cell.favoriteButton.image = nil
        }
        
        if let url = arrOffers[indexPath.row].value(forKey: "url") as? String {
            cell.offerImageView.downloaded(from: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 2
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Pass NSObject
        let vc = DetailViewController()
        vc.passedOffer = arrOffers[indexPath.row]
        vc.refreshDataDelegate = self
        present(vc, animated: true, completion: nil)
    }
}
