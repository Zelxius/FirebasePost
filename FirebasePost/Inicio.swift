//
//  Inicio.swift
//  FirebasePost
//
//  Created by Colimasoft on 23/02/22.
//

import UIKit
import FirebaseAuth
class Inicio: UIViewController {

    @IBOutlet var vistaPost: UIView!
    @IBOutlet weak var texto: UITextView!
    
    let customView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vistaPost.layer.cornerRadius = 10
    }
    
    @IBAction func guardarPost(_ sender: UIBarButtonItem) {
        
        
    }
    @IBAction func agregarPost(_ sender: UIBarButtonItem) {
        
        let w = self.view.frame.width
        let h = self.view.frame.height
        
        customView.frame = CGRect.init(x: 0, y: 0, width: w, height: h)
        customView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        customView.center = self.view.center
        self.view.addSubview(customView)
        
        vistaPost.center = self.view.center
        self.view.addSubview(vistaPost)
    }
    @IBAction func cancelarPost(_ sender: UIBarButtonItem) {
        customView.removeFromSuperview()
        vistaPost.removeFromSuperview()
    }
    
    
    @IBAction func salir(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Salir", message: "¿Desea salir?", preferredStyle: .alert)
        let aceptar = UIAlertAction(title: "ACEPTAR", style: .default) { (_) in
            try! Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alert.addAction(cancelar)
        alert.addAction(aceptar)
        present(alert, animated: true, completion: nil)
    }
}
