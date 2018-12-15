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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        sumProductValues()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        updateScreenValues()
    }
    
    func updateScreenValues(){
        lbRealSum.text = formatCurrency(value:totalBRL)
        lbDolarSum.text = formatCurrency(value:totalUSD)
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
            //ok, vamos la
            for product in products{
                var value:Double = product.value
                totalUSD += value //valor do dolar segue bruto, sem impostos
                
                //o estado pode ter sido deletado, para nao apagar a compra do usuario calculamos sem o imposto do estado
                if let tax = product.state?.tax{
                    totalBRL += (value * dolar) + (value * dolar)*(iof/100)
                }else{
                    
                }
                
                
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
    
    //pra referencia https://stackoverflow.com/questions/39458003/swift-3-and-numberformatter-currency-%C2%A4
    func formatCurrency(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: Locale.current.identifier)
        let result = formatter.string(from: value as NSNumber)
        return result!
    }
}

extension SumViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
}
