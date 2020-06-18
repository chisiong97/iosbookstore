//
//  BookListVC.swift
//  iosbookstore
//
//  Created by Foo Chi Siong on 15/06/2020.
//  Copyright © 2020 Foo Chi Siong. All rights reserved.
//

import UIKit
import RealmSwift

class BookTableViewCell: UITableViewCell
{
    //MARK: TableViewCell Properties
    @IBOutlet weak var imgPhoto: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    
}

class BookListVC: UITableViewController
{
    //MARK: TableView Properties
    @IBOutlet var bookList: UITableView!
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    var navTitle = ""
    var currentBook = Book()
    
    let realm = try! Realm()
    
    var bookQuery: Results<Book>
    {
        get
        {
            return realm.objects(Book.self)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        bookList.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return bookQuery.count
    }
    
    func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BookTableViewCell
        
        // Configure the cell...
        let bookItem = bookQuery[indexPath.row]
        cell.lblTitle?.text = bookItem.title
        cell.lblAuthor?.text = bookItem.author
        
        let imagePath = getDocumentsDirectory().appendingPathComponent(bookItem.photo!)
        
        cell.imgPhoto?.image = UIImage(contentsOfFile: imagePath.path)
        
        print("CellX: " + bookItem.photo!)
        
        return cell
    }
    
    //MARK: Cell actions
    ///Cell selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("You selected cell number: \(indexPath.row)!")
        
        let selectedBook = bookQuery[indexPath.row]
        navTitle = selectedBook.title!
        currentBook = selectedBook
        self.performSegue(withIdentifier: "segueAddBook", sender: self)
        
    }
    
    ///Swipe to delete
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if (editingStyle == .delete)
        {
            // handle delete (by removing the data from your array and updating the tableview)
            let delItem = bookQuery[indexPath.row]
            try! self.realm.write
            {
                let imageName = delItem.photo
                let imagePath = getDocumentsDirectory().appendingPathComponent(imageName!)
                let fileManager = FileManager.default
                
                //delete actual photo in directory
                try fileManager.removeItem(atPath: imagePath.path)
                
                //delete item in realmdb
                realm.delete(delItem)
                
            }
            bookList.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            bookList.reloadData()
        }
    }
    
    //MARK: Navbar Actions
    
    @IBAction func btnAdd(_ sender: Any )
    {
        navTitle = "Add Book"
        
        self.performSegue(withIdentifier: "segueAddBook", sender: self)
    }
    
    //MARK: Pass data to AddBookVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        let viewController = segue.destination as! AddBookVC
        
        viewController.navTitle = navTitle
        
        viewController.currentBook = currentBook
        
    }
}
