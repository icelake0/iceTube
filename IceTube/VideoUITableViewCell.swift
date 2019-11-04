//
//  VideoUITableViewCell.swift
//  IceTube
//
//  Created by Gbemileke AJIBOYE on 10/26/19.
//  Copyright © 2019 Gbemileke AJIBOYE. All rights reserved.
//

import UIKit
import Alamofire

class VideoUITableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var thumbNailImageView: UIImageView!
    
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var topContainer: UIView!
    
    private let imageCache = NSCache<NSString, UIImage>()
    
    var video : Video? {
        didSet{
            //avatarImageView.image = UIImage(named: )
            if let thumbnailImage = video?.thumbnailImage {
                thumbNailImageView.image = UIImage(named: thumbnailImage)
            }
            
            if let thumbnailImageUrl = video?.thumbnailImageUrl {
                // get the image from the url and set it as the image on the view
                self.setImage(for: thumbNailImageView, forUrl: thumbnailImageUrl)
            }

            
            if let title = video?.title {
                titlelabel.text = title
            }
            
            
            if let numOfviews = video?.numberOfViews, let channelName = video?.channel?.name {
                let formater = NumberFormatter()
                formater.groupingSeparator = ","
                formater.numberStyle = .decimal
                let formatedNumber = formater.string(from: numOfviews) ?? "0";
                subTitleLabel.text = "\(channelName) • \(formatedNumber) views • 3 Weeks"
            }
            
            if let avatarImage = video?.channel?.profileImageName {
                avatarImageView.image = UIImage(named: avatarImage)
            }
            
            if let profileImageNameUrl = video?.channel?.profileImageNameUrl {
                self.setImage(for: avatarImageView, forUrl: profileImageNameUrl)
            }
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height/2
//        let topContainerHeight = (topContainer.frame.width * 9)/16
//        topContainer.frame.size = CGSize(width: topContainer.frame.width, height: topContainerHeight)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setImage(for imageView : UIImageView, forUrl url : String) -> Void{
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
        let tempimage = UIImage(systemName: "film")
        imageView.image = tempimage
        if  let cashedImage = self.imageCache.object(forKey: url as NSString) {
             imageView.image = cashedImage
            return
        }
        Alamofire.request(url, method: .get, parameters: nil)
         .response { (response) in
            if let data = response.data {
                if  let image =  UIImage(data: data) {
                    self.imageCache.setObject(image, forKey: url as NSString)
                    if(url == self.video?.thumbnailImageUrl || url == self.video?.channel?.profileImageNameUrl){
                        imageView.image = image
                    }
                }else{
                     print("Error : \("Unable to create image form image data goten form URL") \(url)")
                }
             }
             else{
                 print("Error : \("Unable to load image from url") \(url)")
             }
         }
    }
    
}
