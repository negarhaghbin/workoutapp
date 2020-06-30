//
//  WelcomeViewController.swift
//  workoutapp
//
//  Created by Negar on 2020-05-17.
//  Copyright © 2020 Negar. All rights reserved.
//

import UIKit
import RealmSwift

class WelcomeViewController: UIViewController {
    let realm = try! Realm()
    
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var images = ["markus-spiske-KWQ2kQtxiKE-unsplash", "victor-freitas-qZ-U9z4TQ6A-unsplash", "bruno-nascimento-PHIgYUGQPvU-unsplash", "x-N4QTBfNQ8Nk-unsplash", "marc-najera-Cj2d2IUEPDM-unsplash", "clique-images-hSB2HmJYaTo-unsplash", "engin-akyurt-yBwF4KOKwO4-unsplash", "tommy-boudreau-diO0a_ZEiEE-unsplash"]
    
    var user : User?{
        didSet{
            refreshUI()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let getRequest = APIRequest()
        getRequest.save(completion: {
            result in
            switch result{
            case .success(let message):
                DispatchQueue.main.async {
                    self.quoteLabel.text = "\"\((message.contents?.quotes![0])?.quote ?? "")\""
                    self.authorLabel.text = "-- \((message.contents?.quotes![0])?.author ?? "")"
                }
            
            case .failure(let error):
                print("An error occured: \(error)")
            }
        })
        self.backgroundImage.image = UIImage(named: self.images.randomElement()! + ".jpg")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isNewUser(){
            askName()
        }
        else{
            let u = realm.object(ofType: User.self, forPrimaryKey: UserDefaults.standard.string(forKey: "uuid"))!
            self.user = u
        }
    }
    
    func refreshUI(){
        self.helloLabel.text = "Hello \(user!.name)!"
        user!.manageStreak{ () -> () in
            var badge : Badge?
            switch user!.streak {
            case 3:
                badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.streak3.rawValue)
            case 7:
                badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.streak7.rawValue)
            case 14:
                badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.streak14.rawValue)
            case 30:
                badge = realm.object(ofType: Badge.self, forPrimaryKey: BadgeTitle.streak30.rawValue)
            default:
                print("No badge available")
            }
            
            if (badge != nil){
                badge!.achieved()
            }
        }
    }
    
    func isNewUser()->Bool{
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil{
            return false
        }
        return true
    }
            
        
    func askName(){
        let alert = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
          
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { action in
            if let name = alert.textFields?.first?.text {
                self.user = User(n: name)
                self.user?.add()
            }
        })
        saveAction.isEnabled = false
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Awsome me"
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:
                {_ in
                    let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    let textIsNotEmpty = textCount > 0
                    
                    saveAction.isEnabled = textIsNotEmpty
                
            })
        })
            
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.user = User(n: "Awsome me")
            self.user!.add()
        }))

        alert.addAction(saveAction)
            
        present(alert, animated: true)
    }

}
