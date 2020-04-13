//
//  ViewController.swift
//  GenericUITableView
//
//  Created by apple on 13/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

struct UserModel:Hashable {
    var name = ""
}

enum TableSection{
    case first
}

class ViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    var addUserArr = [UserModel]()
    let searchController = UISearchController(searchResultsController: nil)
    var dataSource:UITableViewDiffableDataSource<TableSection,UserModel>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        addUserArr = getAllData()
        createSnapshot(users: addUserArr)
        addSearchBar()
       
    }
    
    
    func addSearchBar(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search user"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
    
    func configureDataSource(){
        dataSource = UITableViewDiffableDataSource<TableSection, UserModel>(tableView: tblView, cellProvider: { (tableview, indexpath, usermodel) -> UITableViewCell? in
            let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexpath)
            cell.textLabel?.text = usermodel.name
            return cell
        })
    }
    
    func createSnapshot(users: [UserModel]){
        var snapshot = NSDiffableDataSourceSnapshot<TableSection,UserModel>()
        snapshot.appendSections([.first])
        snapshot.appendItems(users)
        dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    

    @IBAction func buttonAddAction(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(title: "", message: "Add User detail", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default) { (okTarget) in
            if let textName = alertVC.textFields?.first?.text{
                self.addUser(name: textName)
            }
        }
        alertVC.addTextField { (textField) in
                     textField.placeholder = "Enter Usernmae"
                 }
        
        alertVC.addAction(ok)
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    
    func addUser(name:String){
        addUserArr.append(UserModel(name: name))
        createSnapshot(users: addUserArr)
    }
    
    
    func getAllData() -> [UserModel]{
        return [
            UserModel(name: "Meenal"),
            UserModel(name: "Rahul"),
            UserModel(name: "Mayank"),
            UserModel(name: "Sourabh")
        ]
    }
    
}

extension ViewController:UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        if searchText == ""{
            addUserArr = getAllData()
        }else{
            addUserArr = addUserArr.filter{$0.name.contains(searchText!)}
        }
        
       createSnapshot(users: addUserArr)
    }
}

