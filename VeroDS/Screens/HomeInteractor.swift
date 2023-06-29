//
//  HomeInteractor.swift
//  VeroDS
//
//  Created by Murat Çiçek on 27.06.2023.
//

import Foundation
import AVFoundation
import Reachability

final class HomeInteractor: Interactorable {
    let entities = HomeEntities()
    var presenter: HomeInteractorOutputs?
    var session: AVCaptureSession?
}
extension HomeInteractor: HomeInteractorInputs {
    func sessionStart() {
        session?.startRunning()
    }
    
    
    func processData(data: Data, success: @escaping (() -> Void?)) {
        do {
            let decoder = JSONDecoder()
            HomeEntities.responseAPI = try decoder.decode([HomeEntities.Response].self, from: data)
            success()
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
        }
    }
    
    func getDatas() {
        Api().getAPIData(accessToken: entities.accessToken, savedDataURL: entities.localDataURL!) {(result: Result<[HomeEntities.Response], Error>) in
            switch result {
            case .success(let success):
                self.presenter?.onSuccessSearch(data: success)
            case .failure(let failure):
                self.presenter?.onErrorSearch(error: failure.localizedDescription)
            }
        }
    }
    
    func getLocalDataURL(success: @escaping (() -> Void?)) {
        entities.localDataURL = Api().getLocalDataURL()
        success()
    }
    
    func getAccessToken(success: @escaping (() -> Void?)) {
        AccessToken().loginAPI { [weak self] accessToken  in
            self?.entities.accessToken = accessToken
            success()
        }
    }
    func avCapture() -> AVCaptureVideoPreviewLayer  {
        let session = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return AVCaptureVideoPreviewLayer()}
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        self.session = session
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        return previewLayer
    }
    func checkInternetConnection(tableViewReload: @escaping (() -> Void )) {
        let reachability = try! Reachability()
        if reachability.connection == .unavailable { // offline
            guard let url = entities.localDataURL else {return}
            
            if let savedData = try? Data(contentsOf: url) {
                processData(data: savedData) {
                    self.entities.data = HomeEntities.responseAPI
                    tableViewReload()
                }
            }
            
        } else { // online
            getAccessToken {
                self.getLocalDataURL {
                    self.getDatas()
                }
            }
        }
    }
}

