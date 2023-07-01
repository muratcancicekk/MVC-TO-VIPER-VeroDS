//
//  ViewController.swift
//  VeroDS
//
//  Created by Berkan Gezgin on 6.04.2023.
//

import UIKit
import Reachability
import AVFoundation

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var qrBtn: UIButton!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchV: UIView!
    @IBOutlet weak var resultTV: UITableView!
    
    var presenter: HomePresenter?
    var tableViewDataSource: TableViewDataSource?

    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    let refreshControl = UIRefreshControl()
        
    init() {
        super.init(nibName: nil, bundle: nil)
        HomeConfigurator.sharedInstance.configure(viewController: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        HomeConfigurator.sharedInstance.configure(viewController: self)
    }
    
    /// Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    @IBAction func qrBtnClicked(_ sender: Any) {
        presenter?.qrBtnClicked(controller: self)
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    /// pull-to-refresh operations
    @objc func refresh(_ sender: UIRefreshControl) {
        presenter?.checkInternetConnection()
        sender.endRefreshing()
    }
    
    /// Textfield operations
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTF.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        presenter?.searchData(searchText: textField.text ?? "")
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource?.numberOfItems ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableViewDataSource?.itemCell(tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
    }
    
}
extension HomeViewController: HomeViewInputs {
    func previewLayerAddSublayer(previewLayer: AVCaptureVideoPreviewLayer) {
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            searchTF.text = stringValue
        }
        dismiss(animated: true)
    }
    
    func indicatorView(animate: Bool) {
        DispatchQueue.main.async {
            self.resultTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: animate ? 50 : 0, right: 0)
            _ = animate ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = !animate
        }
    }
    func configureQrOperations() {
        presenter?.configureQrOperations()
    }
    
    func configureTableView() {
        self.resultTV.delegate = self
        self.resultTV.dataSource = self
    }
    
    func configureSearchView() {
        // Search view border and radius
        searchV.layer.borderColor = UIColor.separator.cgColor
        searchV.layer.borderWidth = 2.0
        searchV.layer.cornerRadius = 10
        
        searchTF.addTarget(self, action: #selector(HomeViewController.textFieldDidChange(_:)), for: .editingChanged)
        searchTF.returnKeyType = .search
        searchTF.keyboardType = .webSearch
        searchTF.delegate = self
        searchTF.placeholder = "Search VerosDS..."
    }
    
    func tableViewReload(tableViewDataSource: TableViewDataSource) {
        self.tableViewDataSource = tableViewDataSource
        DispatchQueue.main.async { [weak self] in
            self?.resultTV.reloadData()
        }
    }
    
    func configure() {
        // Activity indicator opreations
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        // Close keyboard anywhere
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        // Pull-to-refresh created
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        resultTV.addSubview(refreshControl)
    }

}

extension HomeViewController: Viewable {}
