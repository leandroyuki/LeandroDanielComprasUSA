//
//  SumViewController.swift
//  ComprasUSA
//
//  Created by Leandro Yukio on 09/10/2018.
//  Copyright © 2018 DanielLeandro. All rights reserved.
//

import UIKit
import CoreData

class SumViewController: UIViewController {

    @IBOutlet weak var lbRealSum: UILabel!
    @IBOutlet weak var lbDolarSum: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        sumProductValues()
        

    }
    
    var fetchedResultController: NSFetchedResultsController<Product>!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sumProductValues() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension SumViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //tableView.reloadData()
    }
}
