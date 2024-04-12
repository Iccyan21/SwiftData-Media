//
//  PostView.swift
//  SwiftData-Media
//
//  Created by 水原　樹 on 2024/04/12.
//
import SwiftUI
import SwiftData
import PhotosUI

struct PostView: View {
    //We can call the post data through user model, because they are related
    @Bindable var post: User
    @State private var show: Bool = false
    var body: some View {
        
        //MARK: Please be patient :)
        ScrollView(.vertical, showsIndicators: false) {
            
            if self.post.post.count != 0 {
                
                ForEach(post.post) { post in
                    
                    VStack(alignment: .leading) {
                        Image(uiImage: UIImage(data: post.imgPost!)!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width - 24, height: 210)
                            .cornerRadius(13)
                        
                        HStack {
                            Text(post.caption)
                                .font(.headline.bold())
                            
                            Spacer()
                            
                            Text("\(post.comentary.count)")
                            
                            //NavigationLink to navigate to the Comentaries view,later on
                            NavigationLink(destination: ComentaryView(coment: post)) {
                                
                                Image(systemName: "bubble.fill")
                                
                            }
                        }//HStack
                        
                        HStack {
                            Text(post.date, style: .date)
                            Text(post.date, style: .time)
                        }.font(.caption2)
                            .foregroundStyle(.gray)
                        
                        Text(post.descriptions)
                    }.padding()//main vstack
                    
                    //To divide each row!!!
                    Divider()
                }//foreach
            }//if
            else {
                ContentUnavailableView("There are not posts yet", systemImage: "photo.fill")
            }
        }.navigationBarTitle(post.name, displayMode: .inline)
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        self.show.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        //Lets call AddPostView
            .sheet(isPresented: self.$show) {
                
                AddPost(post: post)
            }
    }
}


//MARK: Now lets create the AddPost view

struct AddPost: View {
    
    @Bindable var post: User
    @Environment(\.modelContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var item: PhotosPickerItem?
    @State private var imgPost: Data?
    
    @State private var caption: String = ""
    @State private var descriptions: String = ""
    var body: some View {
        NavigationStack {
            
            Form {
                HStack {
                    Spacer()
                    PhotosPicker(selection: self.$item, matching: .images, label: {
                        
                        if let data = self.imgPost, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 70, height: 70)
                                .cornerRadius(5)
                        }
                        else {
                            Image(systemName: "photo.fill")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .cornerRadius(5)
                                .foregroundStyle(.gray)
                        }
                    })
                    Spacer()
                }
                
                TextField("Caption...", text: self.$caption)
                TextField("Descriptions...", text: self.$descriptions)
                
                Button("Add post") {
                    addPost()
                }
            }.navigationTitle("Add post")
                .task(id: item) {
                    if let data = try! await item?.loadTransferable(type: Data.self) {
                        self.imgPost = data
                    }
                }
        }
    }
    func addPost() {
        let new = Post(imgPost: self.imgPost, caption: self.caption, descriptions: self.descriptions, date: .now, isLiked: false)
        post.post.append(new)
        
        dismiss()
    }
}

//MARK: Lets run the app now.
//MaRK: It will takes long, please be patient!!!! :)
