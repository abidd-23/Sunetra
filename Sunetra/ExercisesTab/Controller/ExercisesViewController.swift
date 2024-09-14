//
//  ExercisesViewController.swift
//  Sunetra
//
//  Created by Kajal Choudhary on 26/05/24.
//

import UIKit

class ExercisesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var givenData : [secondData] = DataController.shared.section2
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            
            return givenData.count
        default:
            return 0
        }
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "First", for: indexPath)
            // Configure your cell for the first section if needed
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Third", for: indexPath)
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Second", for: indexPath) as! SecondCollectionViewCell
            let item = givenData[indexPath.item]
            cell.gameNameLabel.text = item.game
            cell.timeLabel.text = "\(item.timing) mins"
            cell.gameIamgeLabel.image = UIImage(named: item.imageName)
            cell.timeLabel.backgroundColor = UIColor(hex: item.imageName)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "First", for: indexPath)
            // Configure your default cell if needed
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0{
            let gamesStoryboard = UIStoryboard(name: "FirstSection", bundle: nil)
            if let gamesVC = gamesStoryboard.instantiateInitialViewController(){
                navigationController?.pushViewController(gamesVC, animated: true)
            }
        } else if indexPath.section == 2{
        let selectedGame = givenData[indexPath.item]
        let storyboardName = selectedGame.storyboardName
        let gamesStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
            if let gameVC = gamesStoryboard.instantiateInitialViewController(){
                navigationController?.pushViewController(gameVC, animated: true)
            }
        }
    }
    


    
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let firstNib = UINib(nibName: "First", bundle: nil)
        collectionView.register(firstNib, forCellWithReuseIdentifier: "First")
        
        let secondNib = UINib(nibName: "Second", bundle: nil)
        collectionView.register(secondNib, forCellWithReuseIdentifier: "Second")
        
        let thirdNib = UINib(nibName: "Third", bundle: nil)
        collectionView.register(thirdNib, forCellWithReuseIdentifier: "Third")
        
        
        collectionView.setCollectionViewLayout(generateLayout(), animated: true)
        collectionView.dataSource = self
        
        collectionView.delegate = self
    }
    
    func generateLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout{
            (section, env) -> NSCollectionLayoutSection? in switch section{
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .absolute(234))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
                return section
                
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .absolute(50))
                                                       let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
              
                return section
                
            case 2:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .absolute(CGFloat(73 * self.givenData.count)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: self.givenData.count)
                group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10.0)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
              
                return section
                
            default:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.90), heightDimension: .absolute(300))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                return section
            }
        }
        return layout
    }
    
//

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
