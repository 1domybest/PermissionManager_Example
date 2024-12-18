//
//  ContentView.swift
//  Example
//
//  Created by 온석태 on 10/24/24.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: LazyView(PermissionManagerView())) {
                Text("PermissionManagerView")
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.blue)
                    )
            }
            
        }
    }
}
