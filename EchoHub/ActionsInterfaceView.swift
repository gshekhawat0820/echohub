//
//  ActionsInterfaceView.swift
//  EchoHub
//
//  Created by Sambujang Fofana on 2/8/24.
//

import SwiftUI
import AVFoundation

struct ActionsInterfaceView: View {
    var body: some View {
        // For each action in a category, call a function to convert
        // the pressed action into speech.
        // Example VStack containing an action button
        VStack{
            Button("Lights"){
                let command = "turn on the lights."
                ActionToSpeech(action_command: command)
            }
        }
        
        // Enable a feature to have an option that allows users to
        // move and delete actions through and edit button
/*      List {
            ForEach(actons) {action in Text(action.name)}
            .onMove(perform: move)
            .onDelete(perform: deleteItem)
        }
            .navigationBarItems(trailing: EditButton())
 */
    }
    
    func ActionToSpeech(action_command: String) {
        let utterance = AVSpeechUtterance(string: "Hey Google,  \(action_command)")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.3

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
/*  func move(from source: IndexSet, to destination: Int) {
        actions.move(fromOffsets: source, toOffset: destination)
    }
 
    func deleteItem(at offsets: IndexSet){
        characters.remove(atOffsets: offsets)
    }
*/
}

#Preview {
    ActionsInterfaceView()
}
