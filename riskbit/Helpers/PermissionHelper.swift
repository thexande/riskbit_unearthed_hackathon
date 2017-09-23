//
//  PermissionHelper.swift
//  cheers_around_the_world
//
//  Created by Alexander Murphy on 7/8/17.
//  Copyright © 2017 thexande. All rights reserved.
//

import Foundation
import PermissionScope

class PermissionHelper {
    static func hasRequiredPermissions() -> Bool {
        let pscope = PermissionScope()
        return pscope.statusCamera() == .authorized && pscope.statusLocationInUse() == .authorized
    }
    
//    static func producePermissionScopeController() -> PermissionScope {
//        let pscope = PermissionScope()
//        pscope.headerLabel.text = "Cheers!".uppercased()
//        pscope.headerLabel.font = UIFont.italicSystemFont(ofSize: 24)
//        pscope.headerLabel.textColor = StyleConstants.color.primary_red
//        pscope.permissionButtonBorderColor = StyleConstants.color.primary_red
//        pscope.permissionButtonTextColor = StyleConstants.color.primary_red
//        pscope.buttonFont = UIFont.systemFont(ofSize: 14)
//        pscope.closeButtonTextColor = StyleConstants.color.primary_gray
//        pscope.permissionLabelColor = StyleConstants.color.primary_gray
//        pscope.authorizedButtonColor = StyleConstants.color.primary_gray
//        pscope.unauthorizedButtonColor = StyleConstants.color.primary_red
//        pscope.labelFont = UIFont.systemFont(ofSize: 11)
//        pscope.bodyLabel.text = "We need a few things before you get started."
//        pscope.bodyLabel.font = UIFont.systemFont(ofSize: 16)
//        pscope.addPermission(LocationWhileInUsePermission(), message: "We use your location to identify your city.")
//        pscope.addPermission(CameraPermission(), message: "The camera is used to create Cheer Cards.")
//        pscope.addPermission(PhotosPermission(), message: "We save your Cheer pictures to your photo library.")
//        return pscope
//    }
}
