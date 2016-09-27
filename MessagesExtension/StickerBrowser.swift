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


class StickerBrowser: MSStickerBrowserViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var stickers = [MSSticker]()
    var stickerWebURL =  URL(string: "https://s3.amazonaws.com/sticker-bucket/lion.png")
    
    func loadStickers() {
        createStickersFromWeb()
    }
    
    func loadAddSticker() {
        createAddSticker(asset: "create", localizedDescription: "create sticker")
    }
    
    func createAddSticker(asset: String, localizedDescription: String) {
        guard let addStickerPath = Bundle.main.path(forResource: asset, ofType: "png") else {
            print("couln't return the sticker path for \(asset)")
            return
        }
        
        let addStickerURL = URL(fileURLWithPath: addStickerPath)
        let addSticker: MSSticker
        
        do {
            try addSticker = MSSticker(contentsOfFileURL: addStickerURL, localizedDescription: localizedDescription)
            stickers.append(addSticker)
        } catch {
            print(error)
            return
        }
        
    }
    
    func addStickerFromPhone() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        let filename = self.getDocumentsDirectory().appendingPathComponent(self.setImageID())
        
        if let pngData = UIImagePNGRepresentation(image) {
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
                return
            }
        } else {
            print("THERE WAS AN ERROR PNG DIDNT GET WRITTEN")
        }
        dismiss(animated: true)
    }

    func createStickersFromWeb()  {
        let dataTask = URLSession.shared.dataTask(with: stickerWebURL!) {
            data, response, error in
            if error == nil {
                let data = data
                if let image = UIImage(data: data!) {
                    if let pngData = UIImagePNGRepresentation(image) {
                        let filename = self.getDocumentsDirectory().appendingPathComponent(self.setImageID())
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
                                return
                            }
                        }
                    }
                } else {
                    print("THE ERROR IS: \(error)")
                }
            }
        dataTask.resume()
    }
    
//    func convertToSticker() {
//        let stickerURL: URL
//        let sticker: MSSticker
//        do {
//            try sticker = MSSticker(contentsOfFileURL: stickerURL, localizedDescription: "description")
//            self.stickers.append(sticker)
//        } catch {
//            print("THERE WAS AN ERROR: \(error)")
//        }
//    }
    
//
//            let dataTask = try URLSession.shared.dataTask(with: stickerWebURL!) {
//                data, response, error in
//                let data = data
//                let image = UIImage(data: data!)
//                let imagePNG = UIImagePNGRepresentation(image!)
//                let filename = self.getDocumentsDirectory().appendingPathComponent("lonfile.png")
//                try? imagePNG?.write(to: filename)
//                print("THE FILE HAS BEENT WRITTEN")
//                let stickerURL = filename.absoluteURL
//                let sticker: MSSticker
//                do {
//                    try sticker = MSSticker(contentsOfFileURL: stickerURL, localizedDescription: "description")
//                    self.stickers.append(sticker)
//                    print("STICKER WAS APPENDED TO ARRAY: \(self.stickers)")
//                } catch {
//                    print("THERE WAS AN ERROR: \(error)")
//                    return
//                }
//        }
//        
//    }
    
    func setImageID() -> String {
        let imageID = UUID().uuidString
        return imageID
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
     override func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
        return stickers.count
     }
    
     override func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView, stickerAt index: Int) -> MSSticker {
//        stickers.insert(, at: 0)
        return stickers[index]
     }

}
