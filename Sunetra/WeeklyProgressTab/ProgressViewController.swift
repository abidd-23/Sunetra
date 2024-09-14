import UIKit

class ProgressViewController: UIViewController, UICollectionViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var profileIcon: UIButton!
    
    var givenWeekData: [weekData] = DataController.shared.weekDataPass

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.setCollectionViewLayout(generateLayout(), animated: true)
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTrackButtonText()
    }
    
    // MARK: - IBActions
    @IBAction func unwindToProgressPage(segue: UIStoryboardSegue) {
        updateTrackButtonText()
    }
    
    // Update track button text based on detection results availability
    func updateTrackButtonText() {
        if DataController.shared.detectionImages.indices.contains(1) {
            if let trackButton = collectionView.viewWithTag(103) as? UIButton {
//                trackButton.setTitle("Show Results", for: .normal)
                setButtonTitleFont(trackButton, title: "Show Results")
            }
        } else {
            if let trackButton = collectionView.viewWithTag(103) as? UIButton {
//                trackButton.setTitle("Detect", for: .normal)
                setButtonTitleFont(trackButton, title: "Detect")
            }
        }
    }
    
    // Function to cutomize button style
    func setButtonTitleFont(_ button: UIButton, title: String) {
        let font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        let attributedTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: font])
        button.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    @IBAction func trackButtonTapped(_ sender: UIButton) {
        // Handling track button tap based on detection results availability
        if DataController.shared.detectionImages.indices.contains(1) {
            sender.setTitle("Show Results", for: .normal)
            let storyboard = UIStoryboard(name: "WeeklyDetection", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "WeeklyDetectionResult") as! WeeklyDetectionResultViewController
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        } else {
            sender.setTitle("Detect", for: .normal)
            let storyboard = UIStoryboard(name: "WeeklyDetection", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "detectionAvatar")
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        }
    }
    
    // MARK: - UICollectionViewDataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return givenWeekData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let week = givenWeekData[indexPath.row]
        
        // changes for labels inside collection view
        if let weekTitles = cell.contentView.viewWithTag(101) as? UILabel, let weekDetails = cell.contentView.viewWithTag(102) as? UILabel {
           
            weekTitles.text = week.week
            weekDetails.text = week.weekDetails
        }
        
        // changes for track button inside collection view
        if let trackButton = cell.contentView.viewWithTag(103) as? UIButton {
            trackButton.configuration?.cornerStyle = .large
            setButtonTitleFont(trackButton, title: trackButton.title(for: .normal) ?? "Detect")
        }
        
        // Cell styling
        cell.contentView.layer.cornerRadius = 14
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.blue.cgColor
        cell.layer.shadowOpacity = 0.4
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.layer.shadowRadius = 2
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    func generateLayout() -> UICollectionViewLayout {
        // creating the item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // creating the group size
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150.0))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10.0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
