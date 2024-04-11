//
//  ContentView.swift
//  SwiftData-Media
//
//  Created by 水原　樹 on 2024/04/11.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var moc
    
    @Query(animation: .snappy) var users: [User]
    
    var body: some View {
        NavigationStack{
            Form{
                ForEach(users){ user in
                    HStack{
                        Image(uiImage: UIImage(data: user.avatar!)!)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 75,height: 75)
                        VStack(alignment: .leading){
                            Text(user.name)
                            
                            VStack(alignment: .leading){
                                Text(user.date,style: .date)
                                Text(user.date,style: .time)
                            }.font(.caption2)
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [User.self,Post.self,Comentary.self])
}
