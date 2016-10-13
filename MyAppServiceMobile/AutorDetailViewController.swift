//
//  AutorDetailViewController.swift
//  MyAppServiceMobile
//
//  Created by Juan Antonio Martin Noguera on 13/10/2016.
//  Copyright © 2016 Cloud On Mobile. All rights reserved.
//

import UIKit

class AutorDetailViewController: UIViewController {

    var model: AutorRecord?
    var client: MSClient?
    
    
    @IBOutlet weak var secondNameLbl: UILabel! {
        didSet {
            secondNameLbl.text = model?["secondname"] as! String?
        }
    }
    @IBOutlet weak var nameLbl: UILabel! {
        didSet{
            nameLbl.text = model?["name"] as! String?
        }
    }
    
    @IBOutlet weak var styleTxt: UITextField! {
        didSet {
            guard let estilo = model?["style"] as! String? else {
                return
            }
            
            styleTxt.text = estilo
        }
    }
    
    @IBOutlet weak var idiomatxt: UITextField! {
        didSet {
            guard let idioma = model?["idiom"] as! String? else {
                return
            }
            idiomatxt.text = idioma
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateNewDataAutorsAction(_ sender: AnyObject) {
        updateAutor()
    }

    func updateAutor() {
        let tableAz = client?.table(withName: "Autors")
        
        // check de datos
        model!["style"] = styleTxt.text as AnyObject?
        model!["idiom"] = idiomatxt.text as AnyObject?
        
        tableAz?.update(model!, completion: { (result, error) in
            if let _ = error {
                print(error)
                return
            }
            
            print(result)
            
        })
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
