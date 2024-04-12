//
//  ContentView.swift
//  SwiftData-Media
//
//  Created by 水原　樹 on 2024/04/11.
//

import SwiftUI
import SwiftData
import PhotosUI


struct ContentView: View {
    @Environment(\.modelContext) var moc
    
    @Query(animation: .snappy) var users: [User]
    @State private var show = false
    
    @State private var search = ""
    var body: some View {
        NavigationStack {
            Form {
                ForEach(users.filter { self.search.isEmpty ? true: $0.name.localizedCaseInsensitiveContains(self.search)}) { user in
                    
                    NavigationLink(destination: PostView(post: user)) {
                        HStack {
                            Image(uiImage: UIImage(data: user.avatar!)!)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 75, height: 75)
                            
                            VStack(alignment: .leading) {
                                Text(user.name)
                                
                                VStack(alignment: .leading) {
                                    Text(user.date, style: .date)
                                    Text(user.date, style: .time)
                                }.font(.caption2)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                                .badge(user.post.count)
                            
                        }
                    }//NavigationLink
                    
                }
                .searchable(text: self.$search, prompt: "Search users...")
            }.navigationTitle("Users")
                .toolbar {
                    ToolbarItem {
                        Button(action: {
                            self.show.toggle()
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: self.$show) {
                    AddUser()
                }
        }
        
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [User.self, Post.self, Comentary.self])
}

//MARK: Lets create the AddUser View

struct AddUser: View {
    // this property wrapper allows us to add,delte and update data from our model
    @Environment(\.modelContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    
    @State private var item: PhotosPickerItem?
    @State private var avatar: Data?
    var body: some View {
        NavigationStack {
            Form {
                HStack {
                    Spacer()
                    PhotosPicker(selection: self.$item, matching: .images, label: {
                        
                        if let data = self.avatar, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 60, height: 60)
                        } else {
                            Image(systemName: "photo.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundStyle(.secondary)
                        }
                    })
                    Spacer()
                }
                
                TextField("name...", text: self.$name)
                
                Button("Add user") {
                    addData()
                }
            }.navigationTitle("add User")
            //MARK: Now lets tranfer the image on its type.
                .task(id: item) {
                    if let data = try! await item?.loadTransferable(type: Data.self) {
                        //Lets relate them
                        self.avatar = data
                    }
                }
        }
    }
    
    func addData() {
        let new = User(avatar: self.avatar, name: self.name, date: .now)
        self.moc.insert(new)
        try! self.moc.save()
        
        dismiss()
    }
}

//



//Lets continue and implement the Comentaries View
