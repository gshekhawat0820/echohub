//
//  HouseholdIconView.swift
//  EchoHub
//
//  Created by Gaurav Shekhawat on 2/8/24.
//

import SwiftUI

struct ActionIconView: View {
    
    let action: Action
    var body: some View {
        VStack(alignment: .leading, spacing: 6, content: {
            ZStack {
                Button(
                    action: {
                        speechObject.ActionToSpeech(action_command: action.prompt)
                    }, 
                    label: {
                        Image(uiImage: UIImage(data: action.imageData!)!)
                            .resizable()
                            .frame(width: 90, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                              .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                  .stroke(.black, lineWidth: 3)
                            }
                    }
                )
            }
            NavigationLink(action.name) {
                ActionView(action: action)
            }
            .font(.title3)
            .fontWeight(.semibold)
        })
    }
}