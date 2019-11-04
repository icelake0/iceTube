//
//  SettingUIView.swift
//  IceTube
//
//  Created by Gbemileke AJIBOYE on 11/2/19.
//  Copyright © 2019 Gbemileke AJIBOYE. All rights reserved.
//

import UIKit

@IBDesignable
class SettingUIView: UIView {
    
    @IBOutlet var settingView: UIView!
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    private static let shared : SettingUIView = {
        let view = SettingUIView();
        return view
    }()
    
    //var contentView:UIView?
    
    let nibName = "SettingUIView"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector (self.hide(_:))))
        self.addSubview(view)
        //contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
         let bundle = Bundle(for: type(of: self))
         let nib = UINib(nibName: nibName, bundle: bundle)
         return nib.instantiate(withOwner: self, options: nil).first as? UIView
     }
    
    static func show() -> Void {
        if let window = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
            .filter({$0.isKeyWindow}).first {
            self.shared.frame = window.frame
            self.shared.settingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            self.shared.settingsTableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 0)
                //CGRect(x: window.frame.height, y: 0, width: window.frame.width, height: 300)
            self.shared.alpha = 0
            window.addSubview(self.shared)
            UIView.animate(withDuration: 0.5) {
                self.shared.alpha = 1
                let settingsTableViewHeight : CGFloat = 300
                let y = window.frame.height - settingsTableViewHeight
                self.shared.settingsTableView.frame = CGRect(x: 0, y: y, width: window.frame.width, height: settingsTableViewHeight)
            }
        }
    }
    
    @objc func hide(_ sender:UITapGestureRecognizer){
        let settingView = sender.view as! SettingUIView
        settingView.alpha = 0
    }
    
}
