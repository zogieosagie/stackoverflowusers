//
//  ViewController.swift
//  StackOverflowUsers
//
//  Created by Osagie Zogie-Odigie on 20/11/2019.
//  Copyright © 2019 Osagie Zogie-Odigie. All rights reserved.
//

import UIKit

class StackOverflowUsersViewController: UIViewController, StackOverflowUsersViewModelProtocol, UserExpandedTableCellProtocol, UITableViewDataSource, UITableViewDelegate {

    var stackOverflowUsersViewModel :StackOverflowUsersViewModel?
    
    @IBOutlet weak var usersTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersTableView.rowHeight = UITableView.automaticDimension
        usersTableView.estimatedRowHeight = 200
        
        stackOverflowUsersViewModel =  StackOverflowUsersViewModel()
        stackOverflowUsersViewModel?.usersViewModelDelegate = self
        stackOverflowUsersViewModel?.fetchStackOverflowUsers()
    }
    
    //MARK: StackOverflowUsersViewModelProtocol methods
    func userViewModelUpdatedUsersList(withErrorMessage errorMessage: String?) {
        
        if(errorMessage == nil){
            self.usersTableView.reloadData()
        }
        else{
            
        }
    }
    
    func userModelUpdatedItem(atRow row: Int) {
        self.usersTableView.reloadRows(at: [IndexPath.init(row: row, section: 0)], with: .automatic)
    }
    
    //MARK: Tableview datasource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stackOverflowUsersViewModel?.numberOfStackOverflowUsers() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expandableCell = usersTableView.dequeueReusableCell(withIdentifier: "UserExpandedTableCell") as! UserExpandedTableCell
        
        expandableCell.configureCell(forPosition: indexPath.row, withDelegate: self)
        
        expandableCell.userName.text = stackOverflowUsersViewModel?.userName(forCellAtIndex: indexPath.row)
        if let reputation = stackOverflowUsersViewModel?.userReputation(forCellAtIndex: indexPath.row){
            expandableCell.reputation.text = String("\(reputation)")
        }
        expandableCell.loadProfileImage(fromUrl :stackOverflowUsersViewModel?.imagePath(forCellAtIndex: indexPath.row))
        expandableCell.expanded = stackOverflowUsersViewModel?.expandedStatus(forCellAtIndex: indexPath.row) ?? false
        expandableCell.isFollowed = stackOverflowUsersViewModel?.followStatus(forCellAtIndex: indexPath.row) ?? false
        expandableCell.isBlocked = stackOverflowUsersViewModel?.blockedStatus(forCellAtIndex: indexPath.row) ?? false
        
        return expandableCell
    }
    
    //MARK: Tableview delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        stackOverflowUsersViewModel?.expandCollapseRequest(forItem: indexPath.row)
    }
    
    //MARK: TableViewCell protocol
    func cellRequestsFollowForCell(atPosition index: Int?) {
        
        if let indexOfItem = index{
            stackOverflowUsersViewModel?.followUserRequest(forItem: indexOfItem)
        }
    }
    
    func cellRequestsUnfollowFollowForCell(atPosition index: Int?) {
                if let indexOfItem = index{
            stackOverflowUsersViewModel?.unFollowUserRequest(forItem: indexOfItem)
        }
    }
    
    func cellRequestsBlockForCell(atPosition index: Int?) {
                if let indexOfItem = index{
            stackOverflowUsersViewModel?.blockUserRequest(forItem: indexOfItem)
        }
    }



}

