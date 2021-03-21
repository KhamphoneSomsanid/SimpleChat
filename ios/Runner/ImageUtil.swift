//
//  ImageUtil.swift
//  Runner
//
//  Created by Macbook Pro on 3/20/21.
//

import Foundation
import AVFoundation

func createVideoThumbnail(from url: URL, width: Int, height: Int) -> String? {
    let asset = AVAsset(url: url)
    let assetImgGenerate = AVAssetImageGenerator(asset: asset)
    assetImgGenerate.appliesPreferredTrackTransform = true
    assetImgGenerate.maximumSize = CGSize(width: width, height: height)

    let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
    do {
        let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
        let thumbnail = UIImage(cgImage: img)
        
        let imageData:NSData = thumbnail.pngData()! as NSData
        let strBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)
        
        return strBase64
    }
    catch {
      print(error.localizedDescription)
      return nil
    }
}
