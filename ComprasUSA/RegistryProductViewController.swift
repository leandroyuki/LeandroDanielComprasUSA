//
//  RegistryProductViewController.swift
//  ComprasUSA
//
//  Created by Leandro Yukio on 08/10/2018.
//  Copyright © 2018 DanielLeandro. All rights reserved.
//

import UIKit
import CoreData
class RegistryProductViewController: UIViewController {
    var product: Product!
    var state: State!
    var states: [State] = []
    
    var fetchedResultController: NSFetchedResultsController<State>!
    
    let pickerView = UIPickerView(frame: .zero)
    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
    
    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var ivProductImage: UIImageView!
    @IBOutlet weak var tfProductState: UITextField!

    @IBAction func btAddState(_ sender: UIButton) {
        let title = "Adicionar estado"
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
                    let cat = State(context: self.context)
                    cat.tax = tax
                    cat.name = name
                    self.state = cat
                    self.tfProductState.text = name
                }
            }else{
                self.present(ViewController.buildAlert(title:"O imposto deve ser um valor numerico!",message:"O valor deve ser apenas numeros para representar a porcentagem"), animated: true, completion: nil)
                return
            }
            
            
            
            try! self.context.save()
            self.loadStates()

        }
       
        alert.addTextField { (textField) in
            textField.placeholder = "Nome do Estado"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Imposto (%)"
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var tfProductValue: UITextField!
    @IBOutlet weak var swCreditCard: UISwitch!
    
    @IBAction func AddProductImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar foto", message: "Escolha entre tirar uma foto ou usar uma imagem da galeria", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btRegistryProduct(_ sender: UIButton) {
        //cria item a mais quando edita se nao verificado
        if(product == nil){
            product = Product(context: context)
        }
        
        if (tfProductName.text == "" || tfProductName.text == nil){
            self.present(ViewController.buildAlert(title:"O produto precisa de um nome!",message:"Digite um nome para identificar o produto"), animated: true, completion: nil)
            return
        }
        product.name = tfProductName.text
        
        /* nao sei se era necessario, o codigo funciona, mas incomoda bastante pra ficar testando o CRUD
         if (ivProductImage.image == nil){
            self.present(ViewController.buildAlert(title:"Que tal uma foto do produto?",message:"Tire uma foto ou selecione uma da galeria, assim fica fácil achar o produto"), animated: true, completion: nil)
            return
        }*/
        
        product.image = ivProductImage.image

        //product.state = state
        //product.value = Double(tfProductValue.text!)!
        if(tfProductValue.text == "" || tfProductValue.text == nil){
            self.present(ViewController.buildAlert(title:"O produto deve ter um valor!",message:"Se voce ganhou não foi uma compra..."), animated: true, completion: nil)
            return
        }
        if let value = Double(tfProductValue.text!){
            if (value <= 0){
                self.present(ViewController.buildAlert(title:"Valor deve ser positivo e não nulo",message:"O produto não foi grátis ou foi vendido"), animated: true, completion: nil)
                return
            }
            product.value = value
        }else{
            self.present(ViewController.buildAlert(title:"O produto precisa ser um valor numerico!",message:"O valor deve ser apenas numeros"), animated: true, completion: nil)
            return
        }
        if(tfProductState.text == ""){
            self.present(ViewController.buildAlert(title:"O produto precisa de algum estado!",message:"Cadastre ou escolha um estado com seu devido imposto, produtos Duty Free entrarão na próxima versão do app ;)"), animated: true, completion: nil)
            return
        }
        product.state = state
        product.creditCard = swCreditCard.isOn
        
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBOutlet weak var btRegistryProduct: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //verifica se precisa carregar as coisas ou nao
        if product != nil{
            print("carreguei um produto")
            tfProductName.text = product.name
            tfProductValue.text = String(product.value)
            swCreditCard.isOn = product.creditCard
            tfProductState.text = product.state?.name
            ivProductImage.image = product.image as? UIImage
            btRegistryProduct.setTitle("Atualizar", for:.normal)            
        }else{
            print("criando um produto")
            //product = Product(context: context) (ta criando um produto novo antes de precisar, trocado de lugar)
        }
    
        
        pickerView.dataSource = self
        pickerView.delegate = self
        //loadStates()
        self.loadStates()
        /*if state != nil{
         state = State(context: context)
         }*/
        
        configureToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func configureToolbar() {
        let btOk = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(done))
        
        let btSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let btCancel = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancel))
        
        toolbar.backgroundColor = .white
        toolbar.setItems([btCancel, btSpace, btOk], animated: false)
        
        tfProductState.inputView = pickerView
        tfProductState.inputAccessoryView = toolbar
    }
    
    @objc func done() {
        let position = pickerView.selectedRow(inComponent: 0)
        if(position == 0){
            if(states.count == 0){
                cancel()
                return
            }
        }
        let state = states[position]
        tfProductState.text = state.name
        cancel()
    }
    
    @objc func cancel() {
        view.endEditing(true)
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        states = try! context.fetch(fetchRequest)
    }
}


extension RegistryProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("trocando imagem")
            let aspectRatio = image.size.width / image.size.height
            let maxSize: CGFloat = 500
            var smallSize: CGSize
            if aspectRatio > 1 {
                smallSize = CGSize(width: maxSize, height: maxSize/aspectRatio)
            } else {
                smallSize = CGSize(width: maxSize*aspectRatio, height: maxSize)
            }
            
            UIGraphicsBeginImageContext(smallSize)
            image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
            ivProductImage.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        dismiss(animated: true, completion: nil)
    }
}

extension RegistryProductViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        loadStates()
        return states.count
    }
    
}

extension RegistryProductViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row].name
    }
}

extension RegistryProductViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

    }
}





