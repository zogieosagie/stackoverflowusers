//
//  NetworkDownloadService.swift
//  StackOverflowUsers
//
//  Created by Osagie Zogie-Odigie on 21/11/2019.
//  Copyright © 2019 Osagie Zogie-Odigie. All rights reserved.
//

import Foundation

class NetworkDownloadService {
    var downloadsinProgress = [URL]()
    var downloadsSession :URLSession?
    
    
    func startDownloading(resourceWithURL resourceUrl :URL){
        
        downloadsSession?.downloadTask(with: resourceUrl).resume()
        downloadsinProgress.append(resourceUrl)
        
    }
}
