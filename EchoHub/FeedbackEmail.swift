//
//  FeedbackEmail.swift
//  EchoHub
//
//  Created by Gaurav Shekhawat on 4/20/24.
//

import Foundation
import UIKit
import SwiftUI

struct FeedbackEmail {
    let toAddress: String
    let subject: String
    let messageHeader: String
    var body: String {"""
    \(messageHeader)
    ---------------------------------------------
    """
    }
    
    func send(openURL: OpenURLAction) {
        let urlString = "mailto:\(toAddress)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        guard let url = URL(string: urlString) else { return }
        openURL(url) { accepted in
            if !accepted {
                print("""
                This device does not support email
                \(body)
                """)
            }
        }
    }
}
