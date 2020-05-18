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

    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var images = ["markus-spiske-KWQ2kQtxiKE-unsplash", "victor-freitas-qZ-U9z4TQ6A-unsplash", "bruno-nascimento-PHIgYUGQPvU-unsplash", "x-N4QTBfNQ8Nk-unsplash", "marc-najera-Cj2d2IUEPDM-unsplash", "clique-images-hSB2HmJYaTo-unsplash", "engin-akyurt-yBwF4KOKwO4-unsplash", "tommy-boudreau-diO0a_ZEiEE-unsplash"]
    
    var name = ""
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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backgroundImage.image = UIImage(named: self.images.randomElement()! + ".jpg")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isNewUser(){
            askName()
        }
        else{
            let user = try! Realm().object(ofType: User.self, forPrimaryKey: UserDefaults.standard.string(forKey: "uuid"))!
            name = user.name
        }
        self.helloLabel.text = "Hello \(name)!"
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
            
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Awsome me"
        })
            
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            User.createUser(name: "Awsome me")
        }))

        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            if let name = alert.textFields?.first?.text {
                self.name = name
                User.createUser(name: name)
            }
        }))
            
        present(alert, animated: true, completion: nil)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
