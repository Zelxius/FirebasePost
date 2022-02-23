//
//  Registro.swift
//  FirebasePost
//
//  Created by Colimasoft on 23/02/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class Registro: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var imagenPerfil: UIImageView!
    
    var perfil : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addimage = UITapGestureRecognizer(target: self, action: #selector(agregarImagen))
        imagenPerfil.addGestureRecognizer(addimage)
    }
    
    @IBAction func registrar(_ sender: UIButton) {
    }
    
    @IBAction func cancelar(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func agregarImagen(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let imagenTomada = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        perfil = imagenTomada
        imagenPerfil.image = perfil
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
