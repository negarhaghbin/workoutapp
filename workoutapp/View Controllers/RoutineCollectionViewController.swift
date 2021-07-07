//
//  RoutineCollectionViewController.swift
//  
//
//  Created by Negar on 2019-11-13.
//

import UIKit

private let reuseIdentifier = "RoutineCell"

protocol RoutineSelectionDelegate: AnyObject {
  func routineSelected(_ newRoutine: RoutineSection)
}

class RoutineCollectionViewController: UICollectionViewController {
    private let sectionInsets = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 2.0, right: 0.0)
    private let itemsPerRow: CGFloat = 1
    var images: [Image] = []
    var sections : [RoutineSection] = []
    var cgsize : CGSize? = nil
    
    weak var delegate: RoutineSelectionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = false
        navigationController?.setNavigationBarHidden(false, animated: false)
        tabBarController?.tabBar.isHidden = false
        images=Image.loadRoutineSectionHeaderImages()
        sections = RoutineSection.getCollectionRoutineSections()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showExercises" {
            let vc = segue.destination as! RoutineViewController
            let cell = sender as! UICollectionViewCell
            let indexPath = self.collectionView!.indexPath(for: cell)
            vc.section = sections[indexPath!.section]
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! RoutineCollectionViewCell
        
        let image = images[indexPath.section]
        cell.backgroundImage.image = imageWithImage(image: UIImage(named: (image.url.path))!, scaledToSize:cgsize!)
    
        return cell
    }

}

// MARK: - Collection View Flow Layout Delegate
extension RoutineCollectionViewController : UICollectionViewDelegateFlowLayout {
    
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    cgsize=CGSize(width: widthPerItem, height: widthPerItem/3)
    return cgsize!
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}

