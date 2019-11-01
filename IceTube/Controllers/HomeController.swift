//
//  ViewController.swift
//  IceTube
//
//  Created by Gbemileke AJIBOYE on 10/26/19.
//  Copyright © 2019 Gbemileke AJIBOYE. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeController: UIViewController {

    @IBOutlet weak var videosTableView: UITableView!
    
    @IBOutlet weak var menuItem1: UIView!
    
    @IBOutlet weak var menuItem2: UIView!
    
    @IBOutlet weak var menuItem3: UIView!
    
    @IBOutlet weak var menuItem4: UIView!
    
    @IBOutlet weak var menuItem1Icon: UIImageView!
    
    @IBOutlet weak var menuItem2Icon: UIImageView!
    
    @IBOutlet weak var menuItem3Icon: UIImageView!
    
    @IBOutlet weak var menuItem4Icon: UIImageView!
    
    private var menueItems : [UIView]?
    
    private var menueItemIcons : [UIImageView]?
    
    private let videosApiUrl : String = "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json";
    
    private var videos : [Video] =  [Video]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videosTableView.register(UINib(nibName: "VideoUITableViewCell", bundle : nil), forCellReuseIdentifier: "videoUITableViewCell");
        videosTableView.dataSource = self;
        menueItems = [menuItem1, menuItem2, menuItem3, menuItem4];
        menueItemIcons = [menuItem1Icon, menuItem2Icon, menuItem3Icon, menuItem4Icon]
        for menueItem in menueItems! {
            menueItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.changeSelectedMenuItem (_:))))
        }
        loadVideosFromUrl()
    }
    
    @objc func changeSelectedMenuItem(_ sender:UITapGestureRecognizer){
        let selectedMenuItem = sender.view! as UIView;
        for menuIcon in menueItemIcons! {
            menuIcon.tintColor = menuIcon === menueItemIcons![selectedMenuItem.tag] ?
                   UIColor.white :  UIColor.tertiaryLabel
        }
    }
    
    private func loadVideosFromUrl(){
        Alamofire.request(self.videosApiUrl, method: .get, parameters: nil)
               .responseJSON { (response) in
                   if response.result.isSuccess {
                    let videosJSON : JSON = JSON(response.value!)
                    for (_ , videoJSON) in videosJSON {
                        let video : Video = Video();
                        video.title = videoJSON["title"].stringValue
                        video.numberOfViews = videoJSON["number_of_views"].intValue as NSNumber
                        video.thumbnailImageUrl = videoJSON["thumbnail_image_name"].stringValue
                        let channel : Channel = Channel()
                        channel.name = videoJSON["channel"]["name"].stringValue;
                        channel.profileImageNameUrl = videoJSON["channel"]["profile_image_name"].stringValue;
                        video.channel = channel;
                        self.videos.append(video)
                    }
                    self.videosTableView.reloadData()
                   }
                   else{
                       print("Error : \("Currently cant cast error")")
                   }
               }
    }
}

extension HomeController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoUITableViewCell", for: indexPath) as! VideoUITableViewCell
        cell.video = videos[indexPath.row]
        cell.isHidden = indexPath.row > 5;
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
}

