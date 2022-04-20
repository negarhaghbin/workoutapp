//
//  RoutineCollectionViewController.swift
//  
//
//  Created by Negar on 2019-11-13.
//

import UIKit

protocol RoutineSelectionDelegate: AnyObject {
  func routineSelected(_ newRoutine: RoutineSection)
}

class RoutineCollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    
    private let sectionInsets = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 2.0, right: 0.0)
    var images: [Image] = []
    var sections : [RoutineSection] = []
    var cgsize : CGSize? = nil
    
    weak var delegate: RoutineSelectionDelegate?
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = false
        navigationController?.setNavigationBarHidden(false, animated: false)
        tabBarController?.tabBar.isHidden = false
        images = Image.loadRoutineSectionHeaderImages()
        sections = RoutineSection.getRoutineSections()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.showExercises, let vc = segue.destination as? RoutineViewController, let cell = sender as? UICollectionViewCell {
            if let indexPath = self.collectionView!.indexPath(for: cell), sections.indices.contains(indexPath.section) {
                vc.section = sections[indexPath.section]
            }
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.routineCell, for: indexPath) as? RoutineCollectionViewCell else { return UICollectionViewCell() }
        
        let image = images[indexPath.section]
        cell.backgroundImage.image = UIImage(named: (image.url.path))!
    
        return cell
    }

}

// MARK: - Collection View Flow Layout Delegate

extension RoutineCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 1
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let vPaddingSpace = (sectionInsets.top + sectionInsets.bottom)
        let availableWidth = view.frame.width - paddingSpace
        let availableHeight = view.frame.height - vPaddingSpace
        cgsize = CGSize(width: availableWidth, height: availableHeight / CGFloat(sections.count + 1))
        return cgsize!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

