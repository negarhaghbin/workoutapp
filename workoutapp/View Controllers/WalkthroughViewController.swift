//
//  WalkthroughViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-08-13.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!{
        didSet{
            nextButton.layer.cornerRadius = 25.0
            nextButton.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var skipButton: UIButton!
    
    var walkthroughPageViewController : WalkthroughPageViewController?
    var textField : UITextField?
    
    let SET_NAME_INDEX = 3
     
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        //UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        if let index = walkthroughPageViewController?.currentIndex{
            switch index {
            case 0...SET_NAME_INDEX-1:
                walkthroughPageViewController?.forwardPage()
            case SET_NAME_INDEX:
                saveName()
                walkthroughPageViewController?.forwardPage()
            default:
                //UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
                dismiss(animated: true, completion: nil)
            }
        }
        updateUI()
    }
    
    func updateUI(){
        if let index = walkthroughPageViewController?.currentIndex{
            switch index {
            case 0...SET_NAME_INDEX-1:
                nextButton.setTitle("NEXT", for: .normal)
                nextButton.isEnabled = true
                nextButton.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.3137254902, blue: 0.6666666667, alpha: 1)
                skipButton.isHidden = false
            case SET_NAME_INDEX:
                nextButton.setTitle("SAVE", for: .normal)
                nextButton.backgroundColor = UIColor.systemGray3
                nextButton.isEnabled = false
                skipButton.isHidden = false
                textField = walkthroughPageViewController!.contentViewController(at: index)?.textField
                NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:
                {_ in
                    let textCount = self.textField!.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    let textIsNotEmpty = textCount > 0
                    
                    self.nextButton.isEnabled = textIsNotEmpty
                })
            default:
                nextButton.setTitle("GET STARTED", for: .normal)
                nextButton.isEnabled = true
                nextButton.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.3137254902, blue: 0.6666666667, alpha: 1)
                skipButton.isHidden = true
            }
            pageControl.currentPage = index
        }
    }
    
    func saveName(){
        if let contentViewController = walkthroughPageViewController?.contentViewController(at: SET_NAME_INDEX){
            if let name = contentViewController.textField.text {
                let specificPerson = User.getUser(uuid: UserDefaults.standard.string(forKey: "uuid")!)
                specificPerson.changeName(newName: name)
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController{
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
        }
    }

}

extension WalkthroughViewController: WalkthroughPageViewControllerDelegate{
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    
}

