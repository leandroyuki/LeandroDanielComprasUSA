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
    var list = ["A"]
    var fetchedResultController: NSFetchedResultsController<State>!
    
    let pickerView = UIPickerView(frame: .zero)
    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
    
    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var ivProductImage: UIImageView!
    @IBOutlet weak var tfProductState: UITextField!

    @IBAction func btAddState(_ sender: UIButton) {
        
    }
    
    @IBOutlet weak var tfProductValue: UITextField!
    @IBOutlet weak var swCreditCard: UISwitch!
    
    @IBAction func AddProductImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster", preferredStyle: .actionSheet)
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
            ivProductImage.image = product.image as? UIImage
            btRegistryProduct.setTitle("Atualizar", for:.normal)            
        }else{
            print("criando um produto")
            //product = Product(context: context) (ta criando um produto novo antes de precisar, trocado de lugar)
        }
        
        //state = State(context: context)
        
        pickerView.dataSource = self
        pickerView.delegate = self
        //loadStates()
        
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
        let state = list[pickerView.selectedRow(inComponent: 0)]
        tfProductState.text = state
        cancel()
    }
    
    @objc func cancel() {
        view.endEditing(true)
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
    /*
    private func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
            
            print(try fetchedResultController.performFetch())
        } catch {
            print(error.localizedDescription)
        }
    }*/
}

extension RegistryProductViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return fetchedResultController.fetchedObjects?.count ?? 0
    }
    
}

extension RegistryProductViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }
}

extension RegistryProductViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

    }
}





