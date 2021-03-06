//
//  Book.swift
//  Flipt-web
//
//  Created by Johann Kerr on 11/21/16.
//
//

//
//  Book.swift
//  flatiron-teacher-assistant
//
//  Created by Johann Kerr on 11/15/16.
//
//


import Vapor
import Foundation
import Fluent
import Foundation



final class Book: Model{
    var id: Node?
    var bookId: String?
    var exists: Bool = false
    
    
    var title:String
    var isbn:String
    var imgUrl:String
    var mainuser_id: Node?
    var publisher: String
    var author: String
    var description: String
    var publishYear: String
    var lat:Double
    var long:Double
    
    
    var userImg: String = ""
    var status: String = ""
    

    init(title:String, isbn:String,imgUrl:String, lat:Double,long:Double, mainuser_id:Node?, publisher:String, author:String, description:String, publishYear:String){
        self.bookId = UUID().uuidString
        self.title = title
        self.isbn = isbn
        self.imgUrl = imgUrl
        self.publisher = publisher
        self.author = author
        self.description = description
        self.publishYear = publishYear
        self.lat = lat
        self.long = long
        self.mainuser_id = mainuser_id
    }
    

    
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        title = try node.extract("title")
        isbn = try node.extract("isbn")
        imgUrl = try node.extract("imgurl")
        mainuser_id = try node.extract("mainuser_id")
        lat = try node.extract("lat")
        long = try node.extract("long")
        publisher = try node.extract("publisher")
        author = try node.extract("author")
        description = try node.extract("description")
        publishYear = try node.extract("publishyear")
        userImg = try node.extract("userimg")
        bookId = try node.extract("bookid")
        //status = try node.extract("status")
    
 
    }
    
    
    func makeNode(context: Context) throws -> Node {
        print("getting called")
        return try Node(node: [
            "id":id,
            "bookId":bookId,
            "title": title,
            "isbn": isbn,
            "imgUrl": imgUrl,
            "mainuser_id": mainuser_id,
            "lat":lat,
            "long":long,
            "publisher":publisher,
            "author":author,
            "description": description,
            "publishYear":publishYear,
            "userimg": userImg//,
            //"status": status
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("books"){ books in
            books.id()
            books.string("bookId")
            books.string("title")
            books.string("isbn")
            books.string("imgUrl")
            books.double("lat")
            books.double("long")
            books.parent(MainUser.self, optional: false)
            books.string("publisher")
            books.string("author")
            books.string("description")
            books.string("publishYear")
            books.string("userimg", length: 255, optional: true)
            books.string("status", length: 255, optional: true)

        }
    }
    
    static func revert(_ database: Database) throws{
        try database.delete("books")
    }
    
}

extension Book {
    func owner() throws -> MainUser?{
        return try parent(mainuser_id, nil, MainUser.self).get()
    }
    
    func findOwner() throws -> MainUser? {
        if let owner = try MainUser.query().filter("id", self.mainuser_id!).first() {
            return owner
        }
        return nil
    }
    
    
    
}




