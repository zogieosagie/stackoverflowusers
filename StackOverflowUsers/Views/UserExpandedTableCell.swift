//
//  UserExpandedTableCell.swift
//  StackOverflowUsers
//
//  Created by Osagie Zogie-Odigie on 21/11/2019.
//  Copyright © 2019 Osagie Zogie-Odigie. All rights reserved.
//

import UIKit

protocol UserExpandedTableCellProtocol {
    func cellRequestsFollowForCell(atPosition index:Int?)
    func cellRequestsUnfollowFollowForCell(atPosition index:Int?)
    func cellRequestsBlockForCell(atPosition index:Int?)
}

class UserExpandedTableCell: UITableViewCell {
    
    let kCellExpandedStateOffset :CGFloat = -80.0
    let kNormalStateOffset :CGFloat = 0.0
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var reputation: UILabel!
    
    
    @IBOutlet weak var followStatusContainerView: UIView!
    @IBOutlet weak var blockedStatusContainerView: UIView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var unFollowButton: UIButton!
    @IBOutlet weak var blockButton: UIButton!
    
    @IBOutlet weak var expansionContentTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainContentBackground: UIView!
    
    @IBOutlet weak var reputationViewContainer: UIView!
    @IBOutlet weak var followStatusContainer: UIView!
    
    
    
    var expandableCellDelegate :UserExpandedTableCellProtocol?
    var myIndex :Int?
    
    var expanded :Bool = false{
        
        didSet{
            if(expanded == true){
                expansionContentTopConstraint.constant = kNormalStateOffset
            }
            else{
                expansionContentTopConstraint.constant = kCellExpandedStateOffset
            }
        }
    }
    
    var isFollowed :Bool = false{
        
        didSet{
            if(isFollowed == true){
                followStatusContainerView.isHidden = false
            }
            else{
                followStatusContainerView.isHidden = true
            }
        }
    }
    
    var isBlocked :Bool = false{
        
        didSet{
            
            if(isBlocked == true){
                blockedStatusContainerView.isHidden = false
                expanded = false
                reputationViewContainer.alpha = 0.5
                followStatusContainer.alpha = 0.5
                profileImage.alpha = 0.5
                userName.alpha = 0.5
                unFollowButton.isEnabled = false
                
            }
            else{
                blockedStatusContainerView.isHidden = true
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.cornerRadius = 40.0
        followButton.layer.cornerRadius = 5.0
        blockButton.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func requestToUnfollow(_ sender: UIButton) {
        self.expandableCellDelegate?.cellRequestsUnfollowFollowForCell(atPosition: myIndex)
    }
    
    @IBAction func requestToFollow(_ sender: UIButton) {
        self.expandableCellDelegate?.cellRequestsFollowForCell(atPosition: myIndex)
    }
    
    @IBAction func requestToBlock(_ sender: UIButton)
    {
        self.expandableCellDelegate?.cellRequestsBlockForCell(atPosition: myIndex)
    }
    
    
    func configureCell(forPosition position :Int, withDelegate delegate :UserExpandedTableCellProtocol?)
    {
        myIndex = position
        expandableCellDelegate = delegate
        
        if((position % 2) > 0)
        {
            mainContentBackground.backgroundColor = UIColor.white
        }
        else
        {
            mainContentBackground.backgroundColor = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        }
    }
    
    func loadProfileImage(fromUrl url :URL?){
        
        if let urlToLoad = url{
            let data = try? Data(contentsOf: urlToLoad)
            profileImage.image = UIImage(data: data!)
        }
    }
  
}
