//
//  AutorTableViewController.swift
//  MyAppServiceMobile
//
//  Created by Juan Antonio Martin Noguera on 11/10/2016.
//  Copyright © 2016 Cloud On Mobile. All rights reserved.
//

import UIKit

typealias AutorRecord = Dictionary<String, AnyObject>


class AutorTableViewController: UITableViewController {

    var client: MSClient = MSClient(applicationURL: URL(string: "https://boot3labs-mbass.azurewebsites.net")!)
    var model: [Dictionary<String, AnyObject>]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let _ = client.currentUser {
            readAllItemsInTable()
        } else {
            doLoginInFacebook()
        }
    }
    
    func doLoginInFacebook() {
        
        client.login(withProvider: "facebook", parameters: nil, controller: self, animated: true) { (user, error) in
            
            if let _ = error {
                print(error)
                return
            }
            
            if let _ = user {
                self.readAllItemsInTable()
            }
        }
    }

    @IBAction func addNewAutor(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Nuevo Autor", message: "Escribe el nombre de un autor", preferredStyle: .alert)
        
        
        let actionOk = UIAlertAction(title: "OK", style: .default) { (alertAction) in
            let nameAutor = alert.textFields![0] as UITextField
            let secondName = alert.textFields![1] as UITextField
            
            
            self.inserNewAutor(nameAutor.text!, secondName: secondName.text!)
            
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        alert.addTextField { (textField) in
            
            textField.placeholder = "Introduce un nombre del autor"
            
        }
        
        alert.addTextField {(textfield2) in
            textfield2.placeholder = "Introduce los apellidos"
        }
        present(alert, animated: true, completion: nil)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Insert en la tabla de Autores
    
    func inserNewAutor(_ name: String, secondName: String) {
        
        let tableMS = client.table(withName: "Autors")
        
        tableMS.insert(["name" : name, "secondname": secondName]) { (result, error) in
            
            if let _ = error {
                print(error)
                return
            }
            self.readAllItemsInTable()
            print(result)
        }
    }
    
    
    func deleteRecord(_ item: AutorRecord) {
        
        let tableMS = client.table(withName: "Autors")
        
        tableMS.delete(item) { (reult, error) in
            
            if let _ = error {
                print(error)
                return
            } 
            
            // refrescar la tabla
            self.readAllItemsInTable()
        }

        
    }
    
    func readAllItemsInTable() {
        
        client.invokeAPI("readAllRecords", body: nil, httpMethod: "GET", parameters: nil, headers: nil) { (result, respose, error) in
            
            
            if let _ = error {
                print(error)
                return
            }
            
            if !((self.model?.isEmpty)!) {
                self.model?.removeAll()
            }
           
            if let _ = result {
                
                let json = result as! [AutorRecord]
                
                for item in json {
                    self.model?.append(item)
                }
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                }
                
            }
            
            
           

        }

        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if (model?.isEmpty)! {
            return 0
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (model?.isEmpty)! {
            return 0
        }

        return (model?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELDA", for: indexPath)

        // Configure the cell...

        let item = model?[indexPath.row]
        
        cell.textLabel?.text = item?["name"] as! String?
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = model?[indexPath.row]
        
        performSegue(withIdentifier: "detailAutor", sender: item)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            let item = self.model?[indexPath.row]
            
            self.deleteRecord(item!)
            self.model?.remove(at: indexPath.row)
            
            tableView.endUpdates()

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "detailAutor" {
            let vc = segue.destination as? AutorDetailViewController
            
            vc?.client = client
            vc?.model = sender as! AutorRecord
            
        }
    }
    

}
















