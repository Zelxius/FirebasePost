//
//  InicioSesion.swift
//  FirebasePost
//
//  Created by Colimasoft on 23/02/22.
//

import UIKit
import FirebaseAuth
class InicioSesion: UIViewController {

    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func entrar(_ sender: UIButton) {
        
    }
    
    func iniciarSesion(correo: String, pass: String){
        Auth.auth().signIn(withEmail: correo, password: pass) { (user, error) in
            if user != nil {
                print("Entro")
                self.performSegue(withIdentifier: "entrar", sender: self)
            }else{
                if let error = error?.localizedDescription {
                    print("Error en firebase", error)
                }else{
                    print("Error en el codigo")
                }
            }
        }
    }
}
