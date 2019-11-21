//
//  ViewController.swift
//  StackOverflowUsers
//
//  Created by Osagie Zogie-Odigie on 20/11/2019.
//  Copyright © 2019 Osagie Zogie-Odigie. All rights reserved.
//

import UIKit

class StackOverflowUsersViewController: UIViewController, StackOverflowUsersViewModelProtocol {

    
    
    var stackOverflowUsersViewModel :StackOverflowUsersViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackOverflowUsersViewModel =  StackOverflowUsersViewModel()
        stackOverflowUsersViewModel?.usersViewModelDelegate = self
        stackOverflowUsersViewModel?.fetchStackOverflowUsers()
    }
    
    //MARK - StackOverflowUsersViewModelProtocol methods
    func userViewModelUpdatedUsersList() {
        
    }


}

