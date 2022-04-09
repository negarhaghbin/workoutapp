//
//  WelcomeViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-05-17.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            refreshUI()
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let getRequest = APIRequest()
        getRequest.save(completion: { result in
            switch result {
            case .success(let message):
                DispatchQueue.main.async {
                    self.quoteLabel.text = "\"\((message.contents?.quotes![0])?.quote ?? "")\""
                    self.authorLabel.text = "-- \((message.contents?.quotes![0])?.author ?? "")"
                }
                
            case .failure(let error):
                print("An error occured: \(error)")
            }
        })
        if let randomImageName = Constants.images.randomElement() {
            backgroundImage.image = UIImage(named: randomImageName + ".jpg")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isNewUser() {
            self.user = User(name: "Awsome me")
            self.user!.add()
            showWalkthrough()
        } else {
            let user = RealmManager.getUser()
            self.user = user
        }
    }
    
    // MARK: - Helpers
    
    func refreshUI() {
        guard let user = user else { return }

        helloLabel.text = "Hello \(user.name)!"
        user.manageStreak{ () -> () in
            var badge : Badge?
            switch user.streak {
            case 3:
                badge = RealmManager.getBadge(primaryKey: BadgeTitle.streak3.rawValue)
            case 7:
                badge = RealmManager.getBadge(primaryKey: BadgeTitle.streak7.rawValue)
                
            case 14:
                badge = RealmManager.getBadge(primaryKey: BadgeTitle.streak14.rawValue)
            case 30:
                badge = RealmManager.getBadge(primaryKey: BadgeTitle.streak30.rawValue)
            default:
                print("No badge available")
            }
            
            if let badge = badge {
                badge.achieved()
            }
        }
    }
    
    func isNewUser() -> Bool {
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
            return false
        }
        return true
    }
    
    func showWalkthrough() {
        let storyboard = UIStoryboard(name: "Walkthrough", bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(identifier: "WalkthroughViewController") as? WalkthroughViewController {
            present(walkthroughViewController, animated: true)
        }
    }

}
