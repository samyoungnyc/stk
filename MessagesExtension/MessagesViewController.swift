//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Computer on 9/18/16.
//  Copyright © 2016 Computer. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    var stickerBrowserVC: StickerBrowser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stickerBrowserVC = StickerBrowser(stickerSize: .regular)
        stickerBrowserVC.view.frame = self.view.frame
        self.addChildViewController(stickerBrowserVC)
        stickerBrowserVC.didMove(toParentViewController: self)
        self.view.addSubview(stickerBrowserVC.view)
//        stickerBrowserVC.createAndLoadStickersFromWeb()
//        stickerBrowserVC.stickerBrowserView.reloadData()
        
    }
    
}
