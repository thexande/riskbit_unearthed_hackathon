//
//  VideoHelper.swift
//  proto
//
//  Created by Alexander Murphy on 11/3/16.
//  Copyright © 2016 Alexander Murphy. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit


class VideoHelper {
    
    static func getVideoFirstFrame(videoURL: URL) -> (UIImage)? {
        do {
            let asset = AVURLAsset(url: videoURL, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch let error as NSError {
            print("Error generating thumbnail: \(error)")
            return nil
        }
    }
}
