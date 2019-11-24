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
    func userModelUpdatedItem(atRow row:Int)
}


struct NetworkResponse :Codable {
    var fetchedUsers :[StackOverflowUser]
    
    enum CodingKeys: String, CodingKey {
        case fetchedUsers = "items"
    }
}

class StackOverflowUsersViewModel :NSObject, URLSessionDownloadDelegate {
    
    let kResourceBaseUrl = "http://api.stackexchange.com/2.2/users?"
    let kResourceUrlQuery = "pagesize=20&order=desc&sort=reputation&site=stackoverflow"
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    var usersViewModelDelegate :StackOverflowUsersViewModelProtocol?
    var stackOverflowUsers = [StackOverflowUser]()
    let networkQueryService = NetworkQueryService()
    var networkDownloadService :NetworkDownloadService?
    
    
    var networkResponse :Codable = [StackOverflowUser]()
    
    override init() {
        super.init()
        networkDownloadService = NetworkDownloadService(withDelegate: self)
    }
    
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
    
    func imagePath(forCellAtIndex cellIndex :Int) -> URL?
    {
        var localImageUrl :URL?
        
        if(cellIndex < stackOverflowUsers.count){
            localImageUrl = stackOverflowUsers[cellIndex].localImageUrl
            
            if(localImageUrl == nil){
    
                guard let remoteImageUrl = URL(string: stackOverflowUsers[cellIndex].imageUrl) else { return nil }
                networkDownloadService?.startDownloading(resourceWithURL: remoteImageUrl, atIndex: cellIndex)
                
            }
        }
        return localImageUrl
    }
    
    func followStatus(forCellAtIndex cellIndex :Int) -> Bool
    {
        var followStatus = false
        
        if(cellIndex < stackOverflowUsers.count){
            followStatus = stackOverflowUsers[cellIndex].isFollowed
        }
        return followStatus
    }
    
    func blockedStatus(forCellAtIndex cellIndex :Int) -> Bool
    {
        var blockedStatus = false
        
        if(cellIndex < stackOverflowUsers.count){
            blockedStatus = stackOverflowUsers[cellIndex].isBlocked
        }
        return blockedStatus
    }
    
    func expandedStatus(forCellAtIndex cellIndex :Int) -> Bool
    {
        var expandedStatus = false
        
        if(cellIndex < stackOverflowUsers.count){
            expandedStatus = stackOverflowUsers[cellIndex].isExpanded
        }
        return expandedStatus
    }
    
    func numberOfStackOverflowUsers() -> Int{
        
        return stackOverflowUsers.count
    }
    
    func expandCollapseRequest(forItem itemIndex:Int)
    {
        let thisStackOverflowUser = stackOverflowUsers[itemIndex]
        thisStackOverflowUser.isExpanded = !thisStackOverflowUser.isExpanded
        
        self.usersViewModelDelegate?.userModelUpdatedItem(atRow: itemIndex)
    }
    
    func followUserRequest(forItem itemIndex:Int){
        let thisStackOverflowUser = stackOverflowUsers[itemIndex]
        thisStackOverflowUser.isFollowed = true
        
        self.usersViewModelDelegate?.userModelUpdatedItem(atRow: itemIndex)
    }
    
    func unFollowUserRequest(forItem itemIndex:Int){
        let thisStackOverflowUser = stackOverflowUsers[itemIndex]
        thisStackOverflowUser.isFollowed = false
        
        self.usersViewModelDelegate?.userModelUpdatedItem(atRow: itemIndex)
        
    }
    
    func blockUserRequest(forItem itemIndex:Int){
        let thisStackOverflowUser = stackOverflowUsers[itemIndex]
        thisStackOverflowUser.isBlocked = true
        
        self.usersViewModelDelegate?.userModelUpdatedItem(atRow: itemIndex)
    }
    
    
    
    //MARK: URLSession delegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        
        guard let sourceURL = downloadTask.originalRequest?.url else {
          return
        }
        
        let indexOfDownload = networkDownloadService?.downloadsinProgress[sourceURL]
        
        guard indexOfDownload != nil else{
            return
        }
        
        networkDownloadService?.downloadsinProgress[sourceURL] = nil
        let destinationURL = localFilePath(for: sourceURL)
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)

        do {
          try fileManager.copyItem(at: location, to: destinationURL)
        } catch let error {
          
        }
        
        guard indexOfDownload! < stackOverflowUsers.count else {
            return
        }
        
        let thisStackOverflowUser = stackOverflowUsers[indexOfDownload!]
        thisStackOverflowUser.updateLocalImageUrl(updateUrl: destinationURL)
        
      DispatchQueue.main.async { [weak self] in
        self?.usersViewModelDelegate?.userModelUpdatedItem(atRow: indexOfDownload!)
      }
        


    }
    
    func localFilePath(for url: URL) -> URL {
      return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    
    
    
    
    
}
