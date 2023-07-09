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
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)  {
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            presenter?.metaDataOutput(data: stringValue)
        }
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
    
    func searchData(searchText: String) {
        // TODO: Interactor?
        guard !searchText.isEmpty && responseAPI != nil else {
            return
        }
        homeData?.removeAll()
        
        // Search of all value
        guard let datas = responseAPI else {return}
        for response in datas {
            
            
            if response.BusinessUnitKey?.range(of: searchText, options: .caseInsensitive) != nil {
                homeData?.append(response)
                
            } else if response.businessUnit?.range(of: searchText, options: .caseInsensitive) != nil {
                homeData?.append(response)
                
            } else if response.colorCode?.range(of: searchText, options: .caseInsensitive) != nil {
                homeData?.append(response)
                
            } else if response.description?.range(of: searchText, options: .caseInsensitive) != nil {
                homeData?.append(response)
                
            } else if response.parentTaskID?.range(of: searchText, options: .caseInsensitive) != nil {
                homeData?.append(response)
                
            } else if response.preplanningBoardQuickSelect?.range(of: searchText, options: .caseInsensitive) != nil {
                homeData?.append(response)
                
            } else if response.task?.range(of: searchText, options: .caseInsensitive) != nil {
                homeData?.append(response)
                
            } else if response.title?.range(of: searchText, options: .caseInsensitive) != nil {
                homeData?.append(response)
                
            } else if response.workingTime?.range(of: searchText, options: .caseInsensitive) != nil {
                homeData?.append(response)
            }
        }
        
        if  homeData?.isEmpty == true {
            guard let responseAPI = responseAPI else { return }
            homeData? = responseAPI
        }
        
    }
    
}

