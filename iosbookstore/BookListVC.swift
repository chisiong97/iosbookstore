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
    
    let realm = try! Realm()
    
    var bookQuery: Results<Book> {
      get {
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BookTableViewCell
        
        // Configure the cell...
        
        let bookItem = bookQuery[indexPath.row]
        cell.lblTitle?.text = bookItem.title
        cell.lblAuthor?.text = bookItem.author
        cell.imgPhoto?.image = UIImage(contentsOfFile: bookItem.photo!)
        
        print("CellX: " + bookItem.photo!)
        
        return cell
    }
    
    //Swipe to delete
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
                realm.delete(delItem)
            }
            bookList.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            bookList.reloadData()
        }
    }
}
