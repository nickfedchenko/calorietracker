//
//  AVCaptureDevice+flash.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 28.11.2022.
//

import AVFoundation

extension AVCaptureDevice {
    func flash(flag: Bool) {
        do {
            if self.hasTorch {
                try self.lockForConfiguration()
                self.torchMode = flag ? .on : .off
                self.unlockForConfiguration()
            }
        } catch {
            print("Device tourch Flash Error ")
        }
    }
}
