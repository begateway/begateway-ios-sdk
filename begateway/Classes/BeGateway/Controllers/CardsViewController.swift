//
//  CardsViewController.swift
//  begateway.framework
//
//  Created by admin on 02.11.2021.
//

import UIKit

class CardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var options: BeGatewayOptions?
    var request: BeGatewayRequest?
    var completionHandler: ((BeGatewayCard) -> Void)?
    var failureHandler:((String) -> Void)?
    
    var onSelectCard:((StoreCard) -> Void)?
    var items: Array<StoreCard> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if BeGateway.instance.options?.backgroundColor != nil {
            self.view.backgroundColor = BeGateway.instance.options!.backgroundColor
        }
        
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //        self.tableView.register(UINib(nibName: "CardTableViewCell", bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: "CardTableViewCell")
        self.tableView.registerCellByNib(with: "CardTableViewCell", bundle: Bundle(for: type(of: self)))
        //
        //        var tt = Bundle.main.bundleURL
        //        print(tt)
        //        print(Bundle(for: type(of: self)).bundleURL)
        
        navigationController?.title = "Select card"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        self.items = StoreCard.readFromUserDefaults() ?? []
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.items = StoreCard.readFromUserDefaults() ?? []
        self.tableView.reloadData()
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let bundle = Bundle(for: type(of: self))
        
        let controller = PaymentViewController.loadFromNib(bundle)
        self.sheetViewController?.setSizes([.fullscreen])
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    
    // MARK: - Table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardTableViewCell", for: indexPath) as! CardTableViewCell
        
        cell.backgroundColor = UIColor.clear
        cell.initCell(
            card: self.items[indexPath.item],
            onChange: {isActive in
                _ = StoreCard.setActiveState(indexPath.item, isActive: isActive)
                self.items = StoreCard.readFromUserDefaults() ?? []
                self.tableView.reloadData()
            },
            textColor: BeGateway.instance.options?.textColor,
            textFont: BeGateway.instance.options?.textFont
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.onSelectCard?(self.items[indexPath.item])
        //        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            _ = StoreCard.remove(indexPath.item)
            self.items = StoreCard.readFromUserDefaults() ?? []
            self.tableView.reloadData()
        }
    }
    
    
    
}
