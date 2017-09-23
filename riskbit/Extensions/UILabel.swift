////
////  UILabel.swift
////  riskbit
////
////  Created by Alexander Murphy on 9/23/17.
////  Copyright © 2017 Alexander Murphy. All rights reserved.
////
//
//import Foundation
//import UIKit
//
////
////  UILabel.swift
////  sparkpoll_video
////
////  Created by Alex Murphy on 6/1/17.
////  Copyright © 2017 thexande. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//@IBDesignable
//class KerningLabel: UILabel {
//    func setKerning(with kerning: CGFloat) {
//        guard let text = self.attributedText else { return }
//        let attribString = NSMutableAttributedString(attributedString: text)
//        attribString.addAttributes([NSKernAttributeName:kerning], range:NSMakeRange(0, text.length))
//        self.attributedText = attribString
//    }
//    
//    override var text: String? {
//        didSet {
//            setKerning(with: self.kerning)
//        }
//    }
//    
//    @IBInspectable var kerning:CGFloat = 0.0 {
//        didSet{
//            if ((self.attributedText?.length) != nil) {
//                setKerning(with: self.kerning)
//            }
//        }
//    }
//}
//
//
//extension UILabel {
//    class func height(for string: String, width: CGFloat, font: UIFont) -> CGFloat {
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
//        label.font = font
//        label.text = string
//        label.numberOfLines = 0
//        label.sizeToFit()
//        return label.frame.height
//    }
//}
//
//
