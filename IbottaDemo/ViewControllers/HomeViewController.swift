//
//  HomeViewController.swift
//  IbottaDemo
//
//  Created by Andrew Geipel on 9/22/21.
//

import UIKit
import CoreData

class ProductsViewController: UIViewController, UIGestureRecognizerDelegate, RefreshDataDelegate {

    // MARK: - Delegate Method(s)
    func refreshData() {
        self.offersCollectionView.reloadData()
     }

    // MARK: - Properties
    lazy var arrUsersLists : [NSManagedObject] = []
    
    var offersCollectionView: UICollectionView!

    private var cellId = "Cell"

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        offersCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    
        offersCollectionView.showsVerticalScrollIndicator = false
        
        offersCollectionView.register(OffersCustomCell.self, forCellWithReuseIdentifier: "Cell")
        
        offersCollectionView.dataSource = self
        offersCollectionView.delegate = self
        offersCollectionView.backgroundColor = UIColor.clear
        
        self.view.addSubview(offersCollectionView)

        view.backgroundColor = .white
        
        
        setupLongGestureRecognizerOnCollection()

        
        
        arrUsersLists = DataLayer.sharedInstance.initialLoadFetch()
        
    }
}

extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrUsersLists.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! OffersCustomCell
        
 
        cell.productNameLbl.text = arrUsersLists[indexPath.row].value(forKey: "name") as? String
        
        
        if arrUsersLists[indexPath.row].value(forKey: "isFavorite") as? Bool == true {
            cell.favoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            cell.favoriteButton.image = nil
        }
        
        if let url = arrUsersLists[indexPath.row].value(forKey: "url") as? String {
            cell.productImageView.downloaded(from: url)
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
        let page = DetailViewController()
        page.passedProduct = arrUsersLists[indexPath.row]
        page.refreshDataDelegate = self
        present(page, animated: true, completion: nil)
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
    
            let p = gestureRecognizer.location(in: offersCollectionView)
    
            if let indexPath = offersCollectionView?.indexPathForItem(at: p) {
                print("Long press at item: \(indexPath.row)")
    
                let alert = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to remove this item?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                        case .default:
                        print("default")
    
                            DataLayer.sharedInstance.delete(object: self.arrUsersLists[indexPath.row])
                            self.arrUsersLists = DataLayer.sharedInstance.initialLoadFetch()
    
                            self.offersCollectionView.reloadData()
    
                        case .cancel:
                        print("cancel")
    
                        case .destructive:
                        print("destructive")
    
                    }
                }))
                let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
                     })
                     alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
