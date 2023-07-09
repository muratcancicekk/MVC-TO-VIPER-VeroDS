//
//  HomeContract.swift
//  VeroDS
//
//  Created by Murat Çiçek on 27.06.2023.
//

import Foundation
import AVFoundation
import UIKit

protocol HomeViewInputs: AnyObject {
    func configure()
    func tableViewReload(tableViewDataSource: TableViewDataSource)
    func configureSearchView()
    func configureTableView()
    func configureQrOperations()
    func indicatorView(animate: Bool)
    func previewLayerAddSublayer(previewLayer: AVCaptureVideoPreviewLayer)
    func metaDataSearch(searchText: String)
}
protocol HomeViewOutputs: AnyObject {
    func viewDidLoad()
    func checkInternetConnection()
    func qrBtnClicked(controller: HomeViewController)
    func configureQrOperations()
    func textFieldDidChange(text: String)
    
}
protocol HomeInteractorOutputs: AnyObject {
    func onSuccessSearch(data: [HomeEntities.Response]?)
    func onErrorSearch(error: String)
    func metaDataOutput(data: String)
}
protocol HomeInteractorInputs: AnyObject {
    func getAccessToken()
    func getLocalDataURL()
    func getDatas()
    func processData(data: Data, success: @escaping (() -> Void?))
    func avCapture() -> AVCaptureVideoPreviewLayer
    func sessionStart()
    func sessionStop()
    var session: AVCaptureSession? { get }
    func checkInternetConnection(tableViewReload: @escaping (() -> Void))
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection)
    func searchData(searchText: String)
}
protocol HomeDataStore: AnyObject {
    var localDataURL: URL? { get set }
    var accessToken: String? { get set }
    var homeData: [HomeEntities.Response]? { get set }
    var searchData: [HomeEntities.Response]? { get set }
    var responseAPI: [HomeEntities.Response]? { get set }
}
