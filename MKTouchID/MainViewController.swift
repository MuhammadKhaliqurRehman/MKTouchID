//
//  MainViewController.swift
//  MKTouchID
//
//  Created by Muhammad Khaliq ur Rehman on 04/04/2017.
//  Copyright © 2017 Muhammad Khaliq ur Rehman. All rights reserved.
//

import UIKit
import LocalAuthentication

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    //MARK: - Class Properties
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var passcodeButton: UIBarButtonItem!
    @IBOutlet weak var touchIDButton: UIBarButtonItem!
    private var dataSource: [String] = []
    private let cellIdentifier = "Cell"
    private let laContext = LAContext()
    private var isTouchID = false
    
    
    //MARK: - View Controllers Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupNavigationBar()
        setupViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - TableView Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = dataSource[indexPath.row]
        
        return cell
    }
    
    
    //MARK: - Action Methods
    
    @IBAction func passcodeButtonPressed(_ sender: UIBarButtonItem) {
        self.showAlertWith(message: "Password Button Pressed", title: "MKTouchID")
    }
    
    @IBAction func touchIDButtonPressed(_ sender: UIBarButtonItem) {
        if isTouchID {
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To unlock, place your finger on home button", reply: { (success, error) in
                DispatchQueue.main.async {
                    if success {
                        self.unlock()
                    } else {
                        switch (error as! LAError).code {
                        case LAError.userFallback:
                            self.passcodeButtonPressed(self.passcodeButton)
                            break
                        default: break
                        }
                    }
                }
            })
        } else {
            showAlertWith(message: "Your device does not support TouchID", title: "MKTouchID")
        }
    }
    
    
    //MARK: - Private Methods
    
    private func setupNavigationBar() {
        self.title = "Main View Controller"
    }
    
    private func setupViewController() {
        dataSource = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"]
        tableView.isHidden = true
        var error: NSError? = nil
        isTouchID = laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    func unlock() {
        warningLabel.isHidden = true
        tableView.isHidden = false
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
    }
    
    private func showAlertWith(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(actionOk)
        present(alertController, animated: true, completion: nil)
    }
}

