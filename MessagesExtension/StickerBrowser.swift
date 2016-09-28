//
//  StickerBrowser.swift
//  stk
//
//  Created by Computer on 9/18/16.
//  Copyright © 2016 Computer. All rights reserved.
//

import Foundation
import UIKit
import Messages
import Kingfisher

class StickerBrowser: MSStickerBrowserViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAndLoadStickersFromWeb()
    }
    
    var stickers = [MSSticker]()
    var stickerWebURL =  URL(string: "https://s3.amazonaws.com/sticker-bucket/lion.png")
    
    func setImageID() -> String {
        let imageID = UUID().uuidString
        return imageID
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    func convertToSticker(filename: URL) {
        let stickerURL = filename.absoluteURL
        let sticker: MSSticker
        do {
            try sticker = MSSticker(contentsOfFileURL: stickerURL, localizedDescription: "description")
            self.stickers.append(sticker)
            print("STICKER WAS APPENDED TO ARRAY: \(self.stickers)")
        } catch {
            print("THERE WAS AN ERROR: \(error)")
        }
    }
    
    func createAndLoadStickersFromWeb()  {
        print("CREATE FUNC STARTED")
        let dataTask = URLSession.shared.dataTask(with: stickerWebURL!) {
            data, response, error in
            if error == nil {
                let data = data
                if let image = UIImage(data: data!) {
                    if let pngData = UIImagePNGRepresentation(image) {
                        let filename = self.getDocumentsDirectory().appendingPathComponent((self.stickerWebURL?.absoluteString)!)
                        try? pngData.write(to: filename)
                        print("THE FILE HAS BEEN WRITTEN AND IS NAMED \(filename.absoluteURL)")
                        let stickerURL = filename.absoluteURL
                        let sticker: MSSticker
                        do {
                            try sticker = MSSticker(contentsOfFileURL: stickerURL, localizedDescription: "description")
                            self.stickers.append(sticker)
                            print("STICKER WAS APPENDED TO ARRAY: \(self.stickers)")
                        } catch {
                            print("THERE WAS AN ERROR: \(error)")
                        }
                    }
                }
            } else {
                print("THE ERROR IS: \(error)")
            }
        }
        dataTask.resume()
    }

    
    
//    func createAndLoadStickersFromWeb()  {
//        let dataTask = URLSession.shared.dataTask(with: stickerWebURL!) {
//            data, response, error in
//            if error == nil {
//                let data = data
//                if let image = UIImage(data: data!) {
//                    if let pngData = UIImagePNGRepresentation(image) {
//                        let filename = self.getDocumentsDirectory().appendingPathComponent(self.setImageID())
//                        try? pngData.write(to: filename)
//                        print("THE FILE HAS BEEN WRITTEN AND IS NAMED \(filename.absoluteURL)")
//                        self.convertToSticker(filename: filename)
//                    }
//                }
//            } else {
//                print("THE ERROR IS: \(error)")
//            }
//        }
//        dataTask.resume()
//    }
    
//        func createAndLoadStickersFromWeb()  {
//            ImageDownloader.default.downloadImage(with: stickerWebURL!, options: [], progressBlock: nil) {
//                (image, error, url, data) in
//                if let imagePng = UIImagePNGRepresentation(image!) {
//                    let filename = self.getDocumentsDirectory().appendingPathComponent(self.setImageID())
//                    try? imagePng.write(to: filename)
//                    let stickerURL = filename.absoluteURL
//                    let sticker: MSSticker
//                    do {
//                        try sticker = MSSticker(contentsOfFileURL: stickerURL, localizedDescription: "description")
//                        self.stickers.append(sticker)
//                        print("STICKER WAS APPENDED TO ARRAY: \(self.stickers)")
//                    } catch {
//                        print("THERE WAS AN ERROR: \(error)")
//                        return
//                    }
//                }
//            }
//        }
    
    override func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
        print(stickers.count)
        return stickers.count
    }
    
    override func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView, stickerAt index: Int) -> MSSticker {
        print("THE STICKERAT DEL METHOD HAS BEEN CALLED \(stickers[index])")
        return stickers[index]
    }
}
