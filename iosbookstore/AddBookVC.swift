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
    @IBOutlet weak var btnDone: UIBarButtonItem!
    let picker = UIImagePickerController()
    var oriImage : UIImage!
    var navTitle = "Add Book"
    var currentBook = Book()
    var edit = false
    
    //MARK: Realm query
    let realm = try! Realm()
    
    var bookQuery: Results<Book>
    {
        get
        {
            return realm.objects(Book.self)
        }
    }
    
    //MARK: View
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationItem.title = navTitle
        
        //View & Edit mode
        if (navTitle != "Add Book")
        {
            let imagePath = getDocumentsDirectory().appendingPathComponent(currentBook.photo!)
            btnImg.setImage(UIImage(contentsOfFile: imagePath.path), for: .normal)
            oriImage = btnImg.currentImage
            
            txtTitle.text = currentBook.title
            txtAuthor.text = currentBook.author
            txtDesc.text = currentBook.desc
            
            btnImg.isUserInteractionEnabled = false
            txtTitle.isUserInteractionEnabled = false
            txtAuthor.isUserInteractionEnabled = false
            txtDesc.isUserInteractionEnabled = false
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: UIBarButtonItem.SystemItem.edit,
                target: self,
                action: #selector(editMode)
            )
        }
    }
    
    @objc func editMode()
    {
        btnImg.isUserInteractionEnabled = true
        txtTitle.isUserInteractionEnabled = true
        txtAuthor.isUserInteractionEnabled = true
        txtDesc.isUserInteractionEnabled = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.done,
            target: self,
            action: #selector(updateBook)
        )
    }
    
    @objc func updateBook ()
    {
        edit = true
        let update = Book()
        query(bookItem : update)
        endView()
    }
    
    @objc func endView()
    {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnImg(_ sender: Any)
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default)
        { _ in
            print("Camera clicked")
            
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                self.picker.allowsEditing = true
                self.picker.sourceType = .camera
                self.picker.mediaTypes = ["public.image"]
                self.picker.delegate = self
                self.present(self.picker, animated: true)
            }
            else
            {
                let alertController = UIAlertController(title: nil, message: "Device has no camera.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { (alert: UIAlertAction!) in
                })
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        btnImg.setImage(image, for: .normal)
        print("Button picture set")
    }
    
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @IBAction func btnDone(_ sender: Any)
    {
        //If title is empty
        if (txtTitle.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            print("Title is empty!")
            
            let alertController = UIAlertController(title: nil, message: "Title cannot be empty!", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { (alert: UIAlertAction!) in
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
            //If image is empty
        else if(btnImg.currentImage == nil)
        {
            print("Photo is empty!")
            
            let alertController = UIAlertController(title: nil, message: "Photo cannot be empty!", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { (alert: UIAlertAction!) in
            })
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let newBook = Book()
            
            query(bookItem : newBook)
            
            endView()
        }
    }
    
    func query(bookItem : Book)
    {
        bookItem.title = txtTitle.text!
        bookItem.author = txtAuthor.text!
        bookItem.desc = txtDesc.text!
        
        if btnImg.currentImage != oriImage
        {
            print("Image different!")
            //Delete original image
            if edit
            {
                let oriImageName = currentBook.photo
                let oriImagePath = getDocumentsDirectory().appendingPathComponent(oriImageName!)
                let fileManager = FileManager.default
                
                //delete actual photo in directory
                try! fileManager.removeItem(atPath: oriImagePath.path)
            }
            
            //Generate photo path
            let currentTimeStamp = String(Int(NSDate().timeIntervalSince1970))
            let imageName = currentTimeStamp
            
            //getDocumentsDirectory return unique path every time its launched, thus saving imageName only
            let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
            let image = btnImg.currentImage!
            
            //Save photo path as string
            bookItem.photo = imageName
            print("newBook pathX \(String(describing: bookItem.photo))")
            
            //Save image data to photo path
            if let jpegData = image.jpegData(compressionQuality: 0.8)
            {
                try? jpegData.write(to: imagePath)
            }
            
            print("Img pathX written \(imagePath)")
        }
        else
        {
            bookItem.photo = currentBook.photo
        }
        
        if edit == true
        {
            let realm = try! Realm()
            let updateBook = realm.object(ofType: Book.self, forPrimaryKey: currentBook.bookID)
            print("Update: " + (updateBook?.title)!)
            
            try! self.realm.write
            {
                updateBook?.title = bookItem.title
                updateBook?.author = bookItem.author
                updateBook?.desc = bookItem.desc
                updateBook?.photo = bookItem.photo
                print("Book updated:\(updateBook!.bookID)" + " " + updateBook!.title! + " " + updateBook!.author!)
            }
        }
        else
        {
            if (bookQuery.count > 0)
            {
                let last = bookQuery.last
                let lastID = last?.bookID
                let currentID = lastID! + 1
                bookItem.bookID = currentID
            }
            else
            {
                bookItem.bookID = 0
            }
            
            try! self.realm.write
            {
                realm.add(bookItem)
                print("Book added:\(bookItem.bookID)" + " " + bookItem.title! + " " + bookItem.author!)
            }
        }
        
    }
}
