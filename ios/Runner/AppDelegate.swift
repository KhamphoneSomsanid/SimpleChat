import UIKit
import Flutter
import AVFoundation


@available(iOS 10.0, *)
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channelThumbnail = FlutterMethodChannel(name: "com.laodev.simplechat/thumbnail",  binaryMessenger: controller.binaryMessenger)
    channelThumbnail.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if (call.method == "image") {
                let thumbnailData = call.arguments as! Array<Any>
                
                // Get data from flutter
                let data = thumbnailData[0] as! FlutterStandardTypedData
                let width: Int = Int(thumbnailData[1] as! String)!
                let height: Int = Int(thumbnailData[2] as! String)!
                
                var size = width
                if (height > width) {
                    size = height
                }
                
                let base64 = self.createImageThumbnail(from: UIImage(data: data.data)!, size: size)
                
                result(base64)
            } else if (call.method == "video") {
                let thumbnailData = call.arguments as! Array<Any>
                
                // Get data from flutter
                let data = thumbnailData[0] as! FlutterStandardTypedData
                let width = Int(thumbnailData[1] as! String)
                let height = Int(thumbnailData[2] as! String)
                
                let asset = data.data.getAVAsset()
                
                let base64 = self.createVideoThumbnail(from: asset, width: width!, height: height!)
                
                result(base64)
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func createVideoThumbnail(from asset: AVAsset, width: Int, height: Int) -> String? {
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
    
    func createImageThumbnail(from image: UIImage, size: Int) -> String? {
        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: size] as CFDictionary

        guard let imageData = image.pngData(),
              let imageSource = CGImageSourceCreateWithData(imageData as NSData, nil),
              let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options)
        else {
            return nil
        }
        
        let imageDataResult: NSData = UIImage(cgImage: image).pngData()! as NSData
        let strBase64:String = imageDataResult.base64EncodedString(options: .lineLength64Characters)

        return strBase64
    }
    
    
}

extension Data {
    func getAVAsset() -> AVAsset {
        let directory = NSTemporaryDirectory()
        let fileName = "\(NSUUID().uuidString).mov"
        let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName])
        try! self.write(to: fullURL!)
        let asset = AVAsset(url: fullURL!)
        return asset
    }
}
