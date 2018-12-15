//
//  SumViewController.swift
//  ComprasUSA
//
//  Created by Leandro Yukio on 09/10/2018.
//  Copyright © 2018 DanielLeandro. All rights reserved.
//

import UIKit
import CoreData
import Foundation

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
        lbRealSum.text = String(format:"%.2f",totalBRL)
        lbDolarSum.text = String(format:"%.2f",totalUSD)
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
                var valueUS:Double = product.value
                totalUSD += valueUS //valor do dolar segue bruto, sem impostos
                
                //o estado pode ter sido deletado, para nao apagar a compra do usuario calculamos sem o imposto do estado caso ele nao exista
                if let tax = product.state?.tax{
                    valueUS = (valueUS * dolar) +  (valueUS * dolar * tax/100) //valor total no USA com o imposto do estado
                }else{
                    valueUS = (valueUS * dolar)  // executa apenas a conversao de dolar para real
                }
                
                if(product.creditCard ){
                    totalBRL += valueUS + valueUS * (iof/100) // adicionado o IOF se cartao de credito
                }else{
                    totalBRL += valueUS //no brasil o total é adicionado o IOF
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
