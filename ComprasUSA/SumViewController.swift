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
    
    var totalBRL:Double = 0.0
    var totalUSD:Double = 0.0
    let ud = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sumProductValues()
        updateScreenValues()
    }
    
    func updateScreenValues(){
        lbRealSum.text = String(totalBRL)
        
        lbDolarSum.text = String(totalUSD)
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
            let products = try! context.fetch(fetchRequest)
            let iof = ud.double(forKey: "iof")
            let dolar = ud.double(forKey: "dolar")
            totalBRL = 0
            totalUSD = 0
            for product in products{
                totalBRL += product.value
                //var tax = product.state.tax ?? 1
                var value:Double = product.value
                if(product.creditCard || iof != 0){
                    totalUSD += (value * dolar) + (value * dolar)*(iof/100)
                    //totalUSD += (value * dolar * tax)
                }else{
                    totalUSD += (value * dolar) + (value * dolar)*(iof/100)
                    //totalUSD += (value * dolar * tax) + (value * dolar)(iof/100)
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension SumViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
}
