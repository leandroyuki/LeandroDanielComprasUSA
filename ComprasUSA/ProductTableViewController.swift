//
//  ProductTableViewController.swift
//  ComprasUSA
//
//  Created by Leandro Yukio on 07/10/2018.
//  Copyright © 2018 DanielLeandro. All rights reserved.
//

import UIKit
import CoreData

class ProductTableViewController: UITableViewController {
    
    var fetchedResultController: NSFetchedResultsController<Product>!
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Sua lista está vazia!"
        label.textAlignment = .center
        label.textColor = UIColor(named: "main")
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProducts()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = fetchedResultController.fetchedObjects?.count == 0 ? label : nil
        return fetchedResultController.fetchedObjects?.count ?? 0
    }
    
    private func loadProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        print("itens na lista: \(fetchRequest.fetchBatchSize)")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // da crash se nao tiver indice selecionado, porque tem 2 segues, 1 pro botao e 1 pro click no item
        if let row = tableView.indexPathForSelectedRow?.row {
            if(row >= 0){
                if let vc = segue.destination as? RegistryProductViewController {
                    vc.product = fetchedResultController.object(at: tableView.indexPathForSelectedRow!)
                }
            }
        }
    }
        

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell
        let product = fetchedResultController.object(at: indexPath)
        cell.lbProductName.text = product.name
        cell.ivProduct.image = product.image as? UIImage
        cell.lbProductValue.text = String(product.value)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = fetchedResultController.object(at: indexPath)
            do {
                context.delete(product)
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}


extension ProductTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

