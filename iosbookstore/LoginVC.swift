//
//  ViewController.swift
//  iosbookstore
//
//  Created by Foo Chi Siong on 15/06/2020.
//  Copyright © 2020 Foo Chi Siong. All rights reserved.
//

import UIKit
import RealmSwift

class LoginVC: UIViewController
{
    
    @IBOutlet weak var txtID: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        print(Realm.Configuration.defaultConfiguration.fileURL)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnLogin(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "segueLogin", sender: self)
        /*
         if (txtID.text == "SS" && txtPassword.text == "1111")
         {
         print("OK!")
         txtID.text = ""
         txtPassword.text = ""
         self.performSegue(withIdentifier: "segueLogin", sender: self)
         
         }
         else
         {
         print("Wrong ID or Password!")
         let alertController = UIAlertController(title: nil, message: "Wrong ID or Password", preferredStyle: .alert)
         
         let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { (alert: UIAlertAction!) in
         })
         
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion: nil)
         }*/
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

