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
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let addimage = UITapGestureRecognizer(target: self, action: #selector(agregarImagen))
        imagenPerfil.addGestureRecognizer(addimage)
    }
    
    @IBAction func registrar(_ sender: UIButton) {
        
        guard let email = correo.text else { return }
        guard let pass = password.text else { return }
        Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
            if user != nil {
                print("Usuario creado")
                self.guardarUsuario()
            }else{
                if let error = error?.localizedDescription{
                    print("Error en firebase", error)
                }else{
                    print("Error de codigo")
                }
            }
        }
    }
    
    func guardarUsuario(){
        // guardar en storage
        let storage = Storage.storage().reference()
        let nombreImagen = UUID()
        let directorio = storage.child("imagenesPerfil/\(nombreImagen)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        directorio.putData(perfil.pngData()!, metadata: metadata) { (data, error) in
            if error == nil {
                print("Se guardo la imagen")
            }else{
                if let error = error?.localizedDescription{
                    print("Error en firebase al cargar imagen", error)
                }else{
                    print("Error de codigo")
                }
            }
        }
        
        //guardar en database
        guard let id = Auth.auth().currentUser?.uid else { return }
        guard let email = Auth.auth().currentUser?.email else { return }
        guard let user = usuario.text  else { return }
        let campos = ["user":user,
                      "correo": email,
                      "idUser": id,
                      "imagenPerfil": String(describing: directorio) ]
        ref.child("users").child(id).setValue(campos)
        dismiss(animated: true, completion: nil)
        
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
    
    func redimensionarImagen(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio = targetSize.width / size.width
        let heigthRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if widthRatio > heigthRatio {
            newSize = CGSize(width: size.width * heigthRatio, height: size.height * heigthRatio)
        }else{
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let imagenTomada = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        perfil = redimensionarImagen(image: imagenTomada!, targetSize: CGSize(width: 100.0, height: 100.0))
        imagenPerfil.image = perfil
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
