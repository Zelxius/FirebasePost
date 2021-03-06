//
//  Inicio.swift
//  FirebasePost
//
//  Created by Colimasoft on 23/02/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
class Inicio: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var vistaPost: UIView!
    @IBOutlet weak var texto: UITextView!
    
    @IBOutlet weak var tabla: UITableView!
    let customView = UIView()
    
    var userList = [Users]()
    var postList = [Posts]()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabla.delegate = self
        tabla.dataSource = self
        ref = Database.database().reference()
        vistaPost.layer.cornerRadius = 10
        
        selectUser()
        selectPosts()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let post = postList[indexPath.row]
        cell.textLabel?.text = post.texto
        return cell
    }
    
    @IBAction func guardarPost(_ sender: UIBarButtonItem) {
        guard let idPost = ref.childByAutoId().key else { return }
        guard let idUser = Auth.auth().currentUser?.uid else { return }
        guard let user = userList[0].user else { return }
        guard let imagenPerfil = userList[0].fotoPerfil else { return }
        guard let text = texto.text else { return }
        
        let campos = ["texto": text,
                      "user": user,
                      "imagenPerfil": imagenPerfil,
                      "idUser": idUser,
                      "idPost": idPost]
        
        ref.child("posts").child(idPost).setValue(campos)
        texto.text = ""
        customView.removeFromSuperview()
        vistaPost.removeFromSuperview()
        
        
    }
    
    func selectUser(){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(userId).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let username = value?["user"] as? String ?? ""
            let imagenPerfil = value?["imagenPerfil"] as? String ?? ""
            let user = Users(user: username, fotoPerfil: imagenPerfil)
            self.userList.append(user)
        }
    }
    
    func selectPosts() {
        ref.child("posts").observe(DataEventType.value) { (snapshot) in
            self.postList.removeAll()
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                let valores = item.value as? [String: AnyObject]
                let username = valores!["user"] as? String ?? ""
                let imagenPerfil = valores!["imagenPerfil"] as? String ?? ""
                let texto = valores!["texto"] as? String ?? ""
                let idUser = valores!["idUser"] as? String ?? ""
                let idPost = valores!["idPost"] as? String ?? ""
                
                let post = Posts(user: username, fotoPerfil: imagenPerfil, texto: texto, idUser: idUser, idPost: idPost)
                self.postList.append(post)
                print(texto)
            }
            DispatchQueue.main.async {
                self.tabla.reloadData()
            }
        }
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
        let alert = UIAlertController(title: "Salir", message: "??Desea salir?", preferredStyle: .alert)
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
