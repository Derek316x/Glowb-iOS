//
//  User.swift
//  GlowFrame
//
//  Created by Michael Kavouras on 12/24/15.
//  Copyright © 2015 Michael Kavouras. All rights reserved.
//

import Foundation
import Spark_SDK

class User {
    
    static let currentUser = User()
    let particleAccount = SparkCloud.sharedInstance()
    var isLoggedInToParticle: Bool {
        return particleAccount.isLoggedIn
    }
    var loggedInParticleUsername: String! {
        return particleAccount.loggedInUsername
    }
    
}