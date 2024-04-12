//
//  ComentaryView.swift
//  SwiftData-Media
//
//  Created by 水原　樹 on 2024/04/12.
//

import SwiftUI
import SwiftData

struct ComentaryView: View {
    @Bindable var coment: Post
    @Environment(\.modelContext) var moc
    @State private var write: String = ""
    var body: some View {
        VStack {
            List {
                if coment.comentary.count != 0 {
                    ForEach(coment.comentary) { comen in
                        
                        VStack(alignment: .leading) {
                            Text(comen.comentary)
                            
                            HStack {
                                
                                Text(comen.date, style: .date)
                                Text(comen.date, style: .time)
                            }.font(.caption2)
                                .foregroundStyle(.gray)
                        }
                        //Delete comentaries
                        .swipeActions {
                            Button(action: {
                                self.moc.delete(comen)
                                try! self.moc.save()
                            }) {
                                Image(systemName: "trash")
                            }
                        }
                    }
                } else {
                    ContentUnavailableView("No comentaries, be the first", systemImage: "bubble.right.fill")
                }
            }.navigationTitle(coment.caption)
            HStack {
                TextField("coment...", text: self.$write)
                
                Button("Send") {
                    addComent()
                }
            }.padding()
        }
    }
    func addComent() {
        let new = Comentary(comentary: self.write, date: .now, isMarked: false)
        self.coment.comentary.append(new)
        self.write = ""
    }
}
