//
//  GamesProgressViewController.swift
//  Sunetra
//
//  Created by Kajal Choudhary on 01/06/24.
//

import UIKit

class GamesProgressViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Properties
    
    var givenGameData: [secondData] = DataController.shared.section2
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return givenGameData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Fourth", for: indexPath) as! FourthCollectionViewCell
        let item = givenGameData[indexPath.item]
        cell.gameNameLabel.text = item.game
        cell.timeLabelOutlet.text = "\(item.timing) mins"
        cell.imageNameOutlet.image = UIImage(named: item.imageName)
        cell.remainingPercentageLabel?.text = String(format: "%.1f%%", item.remainingPercentage)
        cell.configure(progress: Float(item.progress))
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedGame = givenGameData[indexPath.item]
        
        if selectedGame.progress < 100 {
            let storyboardName = selectedGame.storyboardName
            let gamesStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
            if let gameVC = gamesStoryboard.instantiateInitialViewController() {
                navigationController?.pushViewController(gameVC, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Completed", message: "This game is already completed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell nib
        let fourthNib = UINib(nibName: "Fourth", bundle: nil)
        collectionView.register(fourthNib, forCellWithReuseIdentifier: "Fourth")
        
        // Set collection view layout
        collectionView.setCollectionViewLayout(generateLayout(), animated: true)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        givenGameData = DataController.shared.section2
        collectionView.reloadData()
    }
    
    // MARK: - Helper Methods
    
    func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.90), heightDimension: .absolute(CGFloat(165 * self.givenGameData.count)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: self.givenGameData.count)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(15.0)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return UICollectionViewCompositionalLayout(section: section)
    }

}
