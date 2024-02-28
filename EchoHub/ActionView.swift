//
//  GoogleView.swift
//  EchoHub
//
//  Created by Eric Lau on 2/7/24.
//

import SwiftUI
import SwiftData

struct ActionView: View {
    @Environment(\.modelContext) private var modelContext;
    @Environment(\.dismiss) private var dismiss;
    
    let action: Action?;

    @State private var showPicker = false;
    @State private var sourceType = UIImagePickerController.SourceType.camera;
    @State private var image: UIImage? = nil;
    
    @State private var name: String = "";
    @State private var prompt: String =  "";
    @State private var category: String = "Household";
    @State private var device: String = "Amazon Alexa";
    @State private var hidden: Bool = false;
    @State private var favorite: Bool = false;

    let devices = ["Amazon Alexa", "Google Home"];
    let categories = ["Household", "Entertainment", "Communication", "Routines", "Information & Chores"];
    
    init(action: Action?) {
        guard let action = action else {
            self.action = nil;
            return;
        }

        self.action = action;
        
        _name = .init(initialValue: action.name);
        _prompt = .init(initialValue: action.prompt);
        _category = .init(initialValue: action.category);
        _device = .init(initialValue: action.device);
        _hidden = .init(initialValue: action.hidden);
        _favorite = .init(initialValue: action.favorite);
        
        guard action.imageData != nil else {
            return;
        }

        _image = .init(initialValue: UIImage(data: action.imageData!));
    }

    func addAction() {
        guard let image = self.image else {
            return;
        }

        if let action {
            action.name = self.name;
            action.prompt = self.prompt;
            action.category = self.category;
            action.device = self.device;
            action.hidden = self.hidden;
            action.favorite = self.favorite;
            action.imageData = image.pngData();
        } else {
            let action = Action(
                name: self.name,
                prompt: self.prompt,
                category: self.category,
                device: self.device,
                hidden: self.hidden,
                favorite: self.favorite,
                image: image
            );

            modelContext.insert(action)
        }
        
        dismiss();
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: self.$name);
                }
                
                Section(header: Text("Prompt")) {
                    TextField("Prompt", text: self.$prompt, axis: .vertical)
                }
                
                if (self.image == nil) {
                    EmptyView()
                } else {
                    Image(uiImage: self.image!)
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fill)
                        .scaledToFit()
                        .frame(width: 75, height: 75, alignment: .center)
                        .clipShape(.buttonBorder)
                }
                
                Menu("Set icon") {
                    Button(
                        action: {
                            self.sourceType = UIImagePickerController.SourceType.camera;
                            self.showPicker.toggle();
                        },
                        label: {
                            Label(
                                "Camera",
                                systemImage: "camera"
                            )
                        }
                    )
                    Button(
                        action: {
                            self.sourceType = UIImagePickerController.SourceType.photoLibrary;
                            self.showPicker.toggle();
                        },
                        label: {
                            Label(
                                "Photo library",
                                systemImage: "photo.stack"
                            )
                        }
                    )
                }
                .environment(\.menuOrder, .fixed)
                
                Picker("Category", selection: self.$category) {
                    ForEach(categories, id: \.self) {
                        Text($0)
                    }
                }
                
                Picker("Device", selection: self.$device) {
                    ForEach(devices, id: \.self) {
                        Text($0)
                    }
                }
                
                Toggle(isOn: self.$hidden) {
                    Text("Hide")
                }
                
                Toggle(isOn: self.$favorite) {
                    Text("Favorite")
                }
                
                Section {
                    Button(action: addAction) {
                        Text(self.action == nil ? "Submit" : "Save")
                    }.disabled(name.isEmpty || prompt.isEmpty || image == nil)
                }
            }
            .navigationTitle(self.action == nil ? "Add Action" : "Edit Action")
            .fullScreenCover(isPresented: self.$showPicker, content: {
                ImagePickerView(
                    showPicker: self.$showPicker,
                    image: self.$image,
                    sourceType: self.$sourceType
                );
            })
        }
    }
}
