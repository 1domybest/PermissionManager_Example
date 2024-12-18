//
//  PermissionManagerView.swift
//  PermissionManager_example
//
//  Created by 온석태 on 12/18/24.
//

import Foundation
import SwiftUI

struct PermissionManagerView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    @ObservedObject var vm: PermissionManagerViewModel = PermissionManagerViewModel()
    @State private var showingAlert = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                Button(action:{
                    self.vm.requestPermission(.camera)
                }, label:{
                    Text("카메라: \(self.vm.cameraPermissionText)")
                        .foregroundColor(self.vm.cameraPermissionStatus == .notDetermined ? .red : .white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(self.vm.cameraPermissionStatus == .denied ? .red : .blue)
                        )
                })
                
                Button(action: {
                    self.vm.requestPermission(.microphone)
                }, label: {
                    Text("마이크: \(self.vm.microphonePermissionText)")
                        .foregroundColor(self.vm.microphonePermissionStatus == .notDetermined ? .red : .white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(self.vm.microphonePermissionStatus == .denied ? .red : .blue)
                        )
                })
                
                Button(action: {
                    self.vm.requestPermission(.photo)
                }, label: {
                    Text("사진: \(self.vm.photoPermissionText)")
                        .foregroundColor(self.vm.photoPermissionStatus == .notDetermined ? .red : .white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(self.vm.photoPermissionStatus == .denied ? .red : .blue)
                        )
                })
                
                Button(action: {
                    self.vm.requestPermission(.notification)
                }, label: {
                    Text("노티: \(self.vm.notificationPermissionText)")
                        .foregroundColor(self.vm.notificationPermissionStatus == .notDetermined ? .red : .white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(self.vm.notificationPermissionStatus == .denied ? .red : .blue)
                        )
                })
                
             
              
                
            }
            
            .alert(isPresented: self.$vm.showingAlert) {
                self.vm.currentAlert ?? Alert(title: Text(""))
            }
            
            
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:
                self.vm.checkPermissionStatus()
                print("App is in the foreground.")
                // 포어그라운드로 전환 시 처리
            case .inactive:
                print("App is transitioning.")
                // 활성 상태에서 비활성 상태로 전환 시 처리
            case .background:
                print("App is in the background.")
                // 백그라운드로 전환 시 처리
            @unknown default:
                print("Unexpected scene phase.")
            }
        }
       
    }
}
