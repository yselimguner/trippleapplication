//
//  ViewController.swift
//  TripleApp
//
//  Created by Yavuz Güner on 22.09.2022.
//

import UIKit

class CurrencyViewController: UIViewController {
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var euroLabel: UILabel!
    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var kwdLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    @IBOutlet weak var audLabel: UILabel!
    @IBOutlet weak var aedLabel: UILabel!
    @IBOutlet weak var chfLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://v6.exchangerate-api.com/v6/11f3b76f8347c3c48214cf36/latest/USD")
        
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { (data, response, error ) in
            
            if error != nil{
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                if data != nil{
                    do{
                        
                    
                   let jsonResponse = try JSONSerialization.jsonObject(with: data! , options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                        DispatchQueue.main.async {
                            
                            if let  rates = jsonResponse["conversion_rates"] as? [String : Any]{
                                if let usd = rates["USD"] as? Double{
                                    self.usdLabel.text = "USD: \(usd)"
                                }
                                if let eur = rates["EUR"] as? Double{
                                    self.euroLabel.text = "EUR: \(eur)"
                                }
                                if let cad = rates["CAD"] as? Double{
                                    self.cadLabel.text = "CAD: \(cad)"
                                }
                                if let chf = rates["CHF"] as? Double{
                                    self.chfLabel.text = "CHF: \(chf)"
                                }
                                if let gbp = rates["GBP"] as? Double{
                                    self.gbpLabel.text = "GBP: \(gbp)"
                                }
                                if let aed = rates["AED"] as? Double{
                                    self.aedLabel.text = "AED: \(aed)"
                                }
                                if let aud = rates["AUD"] as? Double{
                                    self.audLabel.text = "AUD: \(aud)"
                                }
                                if let kwd = rates["KWD"] as? Double{
                                    self.kwdLabel.text = "KWD: \(kwd)"
                                }
                                if let trz = rates["TRY"] as? Double{
                                    self.tryLabel.text = "TRY: \(trz)"
                                }
                            }
                        }
                    } catch {
                        print("Error")
                    }
                }
            }
        }
        task.resume()
    }
}

