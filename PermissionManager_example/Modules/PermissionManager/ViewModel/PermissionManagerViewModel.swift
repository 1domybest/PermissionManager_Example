//
//  PermissionManagerViewModel.swift
//  PermissionManager_example
//
//  Created by 온석태 on 12/18/24.
//

import Foundation
import PermissionManager
import UIKit
import SwiftUI

class PermissionManagerViewModel: ObservableObject {
    var permissionManager: PermissionManagerClass?
    @Published var showingAlert = false
    
    @Published var cameraPermissionStatus: PermissionStatusType = .unknown
    @Published var microphonePermissionStatus: PermissionStatusType = .unknown
    @Published var notificationPermissionStatus: PermissionStatusType = .unknown
    @Published var photoPermissionStatus: PermissionStatusType = .unknown
    
    @Published var currentAlert: Alert?
    
    lazy var deniedAler: Alert = Alert(title: Text("권한설정이 필요합니다"),
                                      message: Text("설정창으로 이동할까요?"),
                                      primaryButton: .destructive(Text("설정으로 이동"), action: {
                                    self.openSetPermission()
                                }),
                                      secondaryButton: .destructive(Text("취소"), action: {
                                }))
    
    lazy var authorizedAler: Alert = Alert(title: Text("알람"),
                                  message: Text("이미 허용되었습니다"),
                                  dismissButton: .default(Text("확인"))
                              )
    
    var cameraPermissionText: String {
        switch self.cameraPermissionStatus {
        case .notDetermined:
            return "권한 요청전"
        case .denied:
            return "권한 거부됨"
        case .authorized:
            return "권한 허용됨"
        default:
            return "알수없음"
        }
    }
    
    var microphonePermissionText: String {
        switch self.microphonePermissionStatus {
        case .notDetermined:
            return "권한 요청전"
        case .denied:
            return "권한 거부됨"
        case .authorized:
            return "권한 허용됨"
        default:
            return "알수없음"
        }
    }
    
    var photoPermissionText: String {
        switch self.photoPermissionStatus {
        case .notDetermined:
            return "권한 요청전"
        case .denied:
            return "권한 거부됨"
        case .authorized:
            return "권한 허용됨"
        default:
            return "알수없음"
        }
    }
    
    var notificationPermissionText: String {
        switch self.notificationPermissionStatus {
        case .notDetermined:
            return "권한 요청전"
        case .denied:
            return "권한 거부됨"
        case .authorized:
            return "권한 허용됨"
        default:
            return "알수없음"
        }
    }
    
    init() {
        self.permissionManager = PermissionManagerClass()
        self.permissionManager?.setCallback(callback: self)
        self.checkPermissionStatus()
    }
    
    func checkPermissionStatus() {
        guard let permissionManager = self.permissionManager else { return }
        
        DispatchQueue.main.async {
            self.cameraPermissionStatus = permissionManager.getDevicePermissionStatus(permission: .camera)
            self.microphonePermissionStatus = permissionManager.getDevicePermissionStatus(permission: .microphone)
            self.notificationPermissionStatus = permissionManager.getDevicePermissionStatus(permission: .notification)
            self.photoPermissionStatus = permissionManager.getDevicePermissionStatus(permission: .photo)
        }
        
    }
    
    func checkPermissionBeforeRequest(_ type: PermissionManager.PermissionType) -> Bool {
        switch type {
        case .camera:
            if self.cameraPermissionStatus == .denied {
                DispatchQueue.main.async {
                    self.currentAlert = self.deniedAler
                    self.showingAlert = true
                }
                return false
            } else if self.cameraPermissionStatus == .authorized {
                DispatchQueue.main.async {
                    self.currentAlert = self.authorizedAler
                    self.showingAlert = true
                }
                return false
            }
        case .microphone:
            if self.microphonePermissionStatus == .denied {
                DispatchQueue.main.async {
                    self.currentAlert = self.deniedAler
                    self.showingAlert = true
                }
                return false
            } else if self.cameraPermissionStatus == .authorized {
                DispatchQueue.main.async {
                    self.currentAlert = self.authorizedAler
                    self.showingAlert = true
                }
                return false
            }
        case .photo:
            if self.photoPermissionStatus == .denied {
                DispatchQueue.main.async {
                    self.currentAlert = self.deniedAler
                    self.showingAlert = true
                }
                return false
            } else if self.cameraPermissionStatus == .authorized {
                DispatchQueue.main.async {
                    self.currentAlert = self.authorizedAler
                    self.showingAlert = true
                }
                return false
            }
        case .notification:
            if self.notificationPermissionStatus == .denied {
                DispatchQueue.main.async {
                    self.currentAlert = self.deniedAler
                    self.showingAlert = true
                }
                return false
            } else if self.cameraPermissionStatus == .authorized {
                DispatchQueue.main.async {
                    self.currentAlert = self.authorizedAler
                    self.showingAlert = true
                }
                return false
            }
        @unknown default:
            return false
        }
        
        return true
    }
    
    func requestPermission(_ type: PermissionManager.PermissionType) {
        
        guard self.checkPermissionBeforeRequest(type) == true else { return }
        
        self.permissionManager?.requestPermissionWithCallback(permission: type, completion: { succeed in
            DispatchQueue.main.async {
                switch type {
                case .camera:
                    self.cameraPermissionStatus = succeed ? .authorized : .denied
                case .microphone:
                    self.microphonePermissionStatus =  succeed ? .authorized : .denied
                case .photo:
                    self.photoPermissionStatus =  succeed ? .authorized : .denied
                case .notification:
                    self.notificationPermissionStatus =  succeed ? .authorized : .denied
                @unknown default:
                    return
                }
            }
        })
    }
    
    public func openSetPermission() {
        DispatchQueue.main.async {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
    }
}

extension PermissionManagerViewModel: PermissionCallbackProtocol {
    func onNotDetermined(_ type: PermissionManager.PermissionType) {
        
    }
    
    func onAuthorized(_ type: PermissionManager.PermissionType) {
        
    }
    
    func onDenined(_ type: PermissionManager.PermissionType) {
        
    }
}
