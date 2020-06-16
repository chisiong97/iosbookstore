//
//  AddBookVC.swift
//  iosbookstore
//
//  Created by Foo Chi Siong on 15/06/2020.
//  Copyright © 2020 Foo Chi Siong. All rights reserved.
//

import UIKit
import RealmSwift

class AddBookVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    //MARK: Properties
    @IBOutlet weak var btnImg: UIButton!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtAuthor: UITextField!
    @IBOutlet weak var txtDesc: UITextField!
    let picker = UIImagePickerController()
    
    let realm = try! Realm()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func btnImg(_ sender: Any)
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
            print("Camera clicked")
        })
        
        alert.addAction(UIAlertAction(title: "Library", style: .default) { _ in
            print("Library clicked")
            
            
            self.picker.allowsEditing = true
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = ["public.image"]
            self.picker.delegate = self
            self.present(self.picker, animated: true)
            
            print("Pick complete")
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel clicked")
        })
        
        present(alert, animated: true)
        
    }
    
    
    /*
     func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!)
     {
     print("PickerController")
     imagePicker.dismiss(animated: true, completion: nil)
     btnImg.setImage(editingInfo[UIImagePickerController.InfoKey.originalImage] as? UIImage, for: .normal)
     }*/
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        /*
         let imageName = UUID().uuidString
         let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
         
         if let jpegData = image.jpegData(compressionQuality: 0.8) {
         try? jpegData.write(to: imagePath)
         }*/
        
        
        dismiss(animated: true)
        
        btnImg.setImage(image, for: .normal)
        print("Button picture set")
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @IBAction func btnDone(_ sender: Any)
    {
        let newBook = Book()
        
        newBook.title = txtTitle.text!
        newBook.author = txtAuthor.text!
        newBook.desc = txtDesc.text!
        
        //Generate photo path
        let currentTimeStamp = String(Int(NSDate().timeIntervalSince1970))
        let imageName = currentTimeStamp
        
        //getDocumentsDirectory return unique path every time its launched, thus saving imageName only
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        let image = btnImg.currentImage!
        
        //Save photo path as string
        newBook.photo = imageName
        print("newBook pathX \(String(describing: newBook.photo))")
        
        
        //Save image data to photo path
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        print("Img pathX written \(imagePath)")
        
        try! self.realm.write
        {
            realm.add(newBook)
            print("Book added: " + newBook.title! + " " + newBook.author!)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
