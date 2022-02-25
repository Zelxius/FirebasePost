//
//  Posts.swift
//  FirebasePost
//
//  Created by Colimasoft on 25/02/22.
//

import Foundation

class Posts {
    var user: String?
    var fotoPerfil: String?
    var texto: String?
    var idUser: String?
    var idPost: String?
    
    init(user: String?, fotoPerfil: String?, texto: String?, idUser: String?, idPost: String?) {
        self.user = user
        self.fotoPerfil = fotoPerfil
        self.texto = texto
        self.idUser = idUser
        self.idPost = idPost
    }
}
