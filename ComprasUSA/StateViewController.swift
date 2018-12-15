//
//  StateViewController.swift
//  ComprasUSA
//
//  Created by Leandro Yukio on 08/10/2018.
//  Copyright © 2018 DanielLeandro. All rights reserved.
//

import UIKit
import CoreData

class StateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tfIOF: UITextField!
    @IBOutlet weak var tfdolar: UITextField!
    var states: [State] = []
    
    @IBAction func addState(_ sender: UIButton) {
        showAlert()
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Lista de estados vazia."
        label.textAlignment = .center
        label.textColor = UIColor(named: "main")
        return label
    }()
    
    let ud = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        tfdolar.text = ud.string(forKey: "dolar")
        tfIOF.text = ud.string(forKey: "iof")
        self.tvStateList.delegate = self
        self.loadStates()
    }
    
    @IBOutlet weak var tvStateList: UITableView!
    
    func showAlert(state: State? = nil) {
        var title = "Adicionar estado"
        if(state != nil){
            title = "Editar estado"
        }
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let stateName = alert.textFields![0].text!
            let stateTax = alert.textFields![1].text!
            
            let name = stateName
            if (stateName == "" || stateTax == ""){
                self.present(ViewController.buildAlert(title:"Campos nao podem ser vazios!",message:"O estado e o imposto dele não devem ser vazios"), animated: true, completion: nil)
                return
            }
            if let tax = Double(stateTax) {
                if(tax <= 0){
                    self.present(ViewController.buildAlert(title:"O imposto deve ser positivo e não nulo!",message:"Afinal, é imposto"), animated: true, completion: nil)
                    return
                }else{
                    if(state == nil){
                        let cat = State(context: self.context)
                        cat.tax = tax
                        cat.name = name
                    }else{
                        let cat = state
                        cat!.tax = tax
                        cat!.name = name
                    }
                }
                }else{
                self.present(ViewController.buildAlert(title:"O imposto deve ser um valor numerico!",message:"O valor deve ser apenas numeros para representar a porcentagem da facada"), animated: true, completion: nil)
                return
            }
            //cat.tax = Double(stateTax)!
            
            try! self.context.save()
            self.loadStates()
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Nome do Estado"
            if(state != nil){
                textField.text = state?.name
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Imposto (%)"
            if(state != nil){
                textField.text = String(state!.tax)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        states = try! context.fetch(fetchRequest)
        tvStateList.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tvStateList: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = self.states[indexPath.row]
        self.showAlert(state: state)
        tableView.setEditing(false, animated: true)
    }
    
    func tableView(_ tvStateList: UITableView, numberOfRowsInSection section: Int) -> Int {
        tvStateList.backgroundView = states.count == 0 ? label : nil
        return states.count
    }
    
    func tableView(_ tvStateList: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tvStateList.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StateTableViewCell
        let state = states[indexPath.row]
        cell.lbStateName.text = state.name
        cell.lbStateTax.text = String(state.tax)
        return cell
    }
    
    func tableView(_ tvStateList: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Excluir") { (action, indexPath) in
            let state = self.states[indexPath.row]
            self.context.delete(state)
            try! self.context.save()
            self.states.remove(at: indexPath.row)
            tvStateList.deleteRows(at: [indexPath], with: .fade)
        }
        return [deleteAction]
    }

}
