//
//  SQLiteEmojiDB.swift
//  TableViewSample
//
//  Created by Mohammed Hajajate on 9/19/17.
//  Copyright © 2017 Mohammed Hajajate. All rights reserved.
//

import SQLite
class SQLiteEmojiDB {
   
    static let instance = SQLiteEmojiDB()
    private let db: Connection?
    
    private let emojiFavoris = Table("EmojiFavo")
    private let id = Expression<Int64>("id")
    private let symbolEmoji = Expression<String?>("symbolEmoji")
    private let titleEmoji = Expression<String?>("titleEmoji")
    private let descriptionEmoji = Expression<String?>("descriptionEmoji")

    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            db = try Connection("\(path)/Stephencelis.sqlite3")
        } catch {
            db = nil
            print ("Unable to open database")
        }
        
        createTable()
    }
    
    func createTable() {
        do {
            try db!.run(emojiFavoris.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(symbolEmoji, unique: true)
                table.column(titleEmoji, unique: true)
                table.column(descriptionEmoji)
            })
        } catch {
            print("Unable to create table")
        }
    }

    func AddEmojiFavo(csymbolEmoji: String, cnameEmoji: String, cdescriptionEmoji: String) -> Int64{
        do{
            let insert = emojiFavoris.insert(symbolEmoji <- csymbolEmoji, titleEmoji <- cnameEmoji, descriptionEmoji <- cdescriptionEmoji)
            let id = try db!.run(insert)
            print(insert.asSQL())
            return id
        }catch{
                print("Insert failed")
            return -1
        }
    }
    func getEmojiFavo() -> [Emoji] {
        var emojiFavos = [Emoji]()
        
        do{
            for emojiFavo in try db!.prepare(self.emojiFavoris){
                emojiFavos.append(Emoji(title: emojiFavo[titleEmoji], description: emojiFavo[descriptionEmoji], symbol: emojiFavo[symbolEmoji]))
            }
        } catch {
                print("Select failed")
            }
        return emojiFavos
    }
    
    func deleteEmojiFavo(csymbol: String) -> Bool {
        do{
            let emojiFavoDelete = emojiFavoris.filter(symbolEmoji == csymbol)
            try db!.run(emojiFavoDelete.delete())
            return true
        } catch {
                print("Delete failed")
        }
       return false
    }
}














