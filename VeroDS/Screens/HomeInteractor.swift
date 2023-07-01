//
//  HomeInteractor.swift
//  VeroDS
//
//  Created by Murat Çiçek on 27.06.2023.
//

import Foundation
import AVFoundation
import Reachability

final class HomeInteractor: Interactorable, HomeDataStore {
    var responseAPI: [HomeEntities.Response]?
    var localDataURL: URL?
    var accessToken: String?
    var homeData: [HomeEntities.Response]?
    var searchData: [HomeEntities.Response]?
    
    let entities = HomeEntities()
    var presenter: HomeInteractorOutputs?
    var session: AVCaptureSession?
}
extension HomeInteractor: HomeInteractorInputs {
    func sessionStop() {
        session?.stopRunning()
    }
    
    func sessionStart() {
        session?.startRunning()
    }
    
    func processData(data: Data, success: @escaping (() -> Void?)) {
        do {
            let decoder = JSONDecoder()
            responseAPI = try decoder.decode([HomeEntities.Response].self, from: data)
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
        }
    }
    
    func getDatas() {
        guard let accessToken = accessToken else { return }
        Api().getAPIData(accessToken: accessToken, savedDataURL:localDataURL!) {[ weak self] (result: Result<[HomeEntities.Response], Error>) in
            switch result {
            case .success(let success):
                self?.presenter?.onSuccessSearch(data: success)
            case .failure(let failure):
                self?.presenter?.onErrorSearch(error: failure.localizedDescription)
            }
        }
    }
    
    func getLocalDataURL() {
        localDataURL = Api().getLocalDataURL()
        getDatas()
    }
    
    func getAccessToken() {
        AccessToken().loginAPI { [weak self] accessToken  in
            self?.accessToken = accessToken
            self?.getLocalDataURL()
            
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
            guard let url = localDataURL else {return}
            
            if let savedData = try? Data(contentsOf: url) {
                processData(data: savedData) {
                    self.homeData = self.responseAPI
                    tableViewReload()
                }
            }
            
        } else { // online
            getAccessToken()
        }
    }
}

