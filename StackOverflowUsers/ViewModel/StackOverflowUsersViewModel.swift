//
//  StackOverflowUsersViewModel.swift
//  StackOverflowUsers
//
//  Created by Osagie Zogie-Odigie on 21/11/2019.
//  Copyright © 2019 Osagie Zogie-Odigie. All rights reserved.
//

import Foundation

protocol StackOverflowUsersViewModelProtocol {
    func userViewModelUpdatedUsersList(withErrorMessage errorMessage :String?)
}


struct NetworkResponse :Codable {
    var fetchedUsers :[StackOverflowUser]
    
    enum CodingKeys: String, CodingKey {
        case fetchedUsers = "items"
    }
}

class StackOverflowUsersViewModel {
    
    let kResourceBaseUrl = "http://api.stackexchange.com/2.2/users?"
    let kResourceUrlQuery = "pagesize=20&order=desc&sort=reputation&site=stackoverflow"
    
    var usersViewModelDelegate :StackOverflowUsersViewModelProtocol?
    var stackOverflowUsers = [StackOverflowUser]()
    let networkQueryService = NetworkQueryService()
    let networkDownloadService = NetworkDownloadService()
    
    var networkResponse :Codable = [StackOverflowUser]()
    
    func fetchStackOverflowUsers()
    {
        networkQueryService.performNetworkQuery(withBaseUrlString: kResourceBaseUrl, andQueryString: kResourceUrlQuery, completion: processNetworkQuery(returnedData:queryError:))
    }
    
    func processNetworkQuery(returnedData data :Data?, queryError error :Error?){
        
        stackOverflowUsers = [StackOverflowUser]()
        
        if(error == nil){
            do{
                
                stackOverflowUsers = try JSONDecoder().decode(NetworkResponse.self, from: data!).fetchedUsers
                self.usersViewModelDelegate?.userViewModelUpdatedUsersList(withErrorMessage: nil)
                
            }
            catch{
                self.usersViewModelDelegate?.userViewModelUpdatedUsersList(withErrorMessage: NSLocalizedString("List of users could not be retrieved.", comment: "NEEDS_LOCALIZATION"))
            }
        }
        else{
            
            self.usersViewModelDelegate?.userViewModelUpdatedUsersList(withErrorMessage: error?.localizedDescription)
        }
        
    }
    
    func userName(forCellAtIndex cellIndex :Int) -> String
    {
        var userName = ""
        
        if(cellIndex < stackOverflowUsers.count){
            userName = stackOverflowUsers[cellIndex].userName
        }
        return userName
    }
    
    func userReputation(forCellAtIndex cellIndex :Int) -> Int?
    {
        var userReputation :Int?
        
        if(cellIndex < stackOverflowUsers.count){
            userReputation = stackOverflowUsers[cellIndex].reputation
        }
        return userReputation
    }
    
    func imagePath(forCellAtIndex cellIndex :Int) -> String?
    {
        var localImageUrl :String?
        
        if(cellIndex < stackOverflowUsers.count){
            localImageUrl = stackOverflowUsers[cellIndex].localImageUrl
            
            if(localImageUrl == nil){
                guard let remoteImageUrl = URL(string: stackOverflowUsers[cellIndex].imageUrl) else { return nil }
                networkDownloadService.startDownloading(resourceWithURL: remoteImageUrl)
            }
        }
        return localImageUrl
    }
    
    func followStatus(forCellAtIndex cellIndex :Int) -> Bool?
    {
        var followStatus :Bool?
        
        if(cellIndex < stackOverflowUsers.count){
            followStatus = stackOverflowUsers[cellIndex].isFollowed
        }
        return followStatus
    }
    
    func blockedStatus(forCellAtIndex cellIndex :Int) -> Bool?
    {
        var blockedStatus :Bool?
        
        if(cellIndex < stackOverflowUsers.count){
            blockedStatus = stackOverflowUsers[cellIndex].isBlocked
        }
        return blockedStatus
    }
    
    func expandedStatus(forCellAtIndex cellIndex :Int) -> Bool?
    {
        var expandedStatus :Bool?
        
        if(cellIndex < stackOverflowUsers.count){
            expandedStatus = stackOverflowUsers[cellIndex].isExpanded
        }
        return expandedStatus
    }
    
    
    
    
    
}
