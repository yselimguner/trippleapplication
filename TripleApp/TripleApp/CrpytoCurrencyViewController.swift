//
//  CrpytoCurrencyViewController.swift
//  TripleApp
//
//  Created by Yavuz Güner on 22.09.2022.
//

import UIKit

class CrpytoCurrencyViewController: UIViewController {
    @IBOutlet weak var btcLabel: UILabel!
    @IBOutlet weak var ethLabel: UILabel!
    @IBOutlet weak var usdtLabel: UILabel!
    @IBOutlet weak var bnbLabel: UILabel!
    @IBOutlet weak var xrpLabel: UILabel!
    @IBOutlet weak var adaLabel: UILabel!
    @IBOutlet weak var avaxLabel: UILabel!
    @IBOutlet weak var shibaLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    
    let urlString = "https://api.coingecko.com/api/v3/exchange_rates"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        }
    
    func fetchData (){
        let url = URL(string: urlString)
        let defaultSession = URLSession(configuration: .default)
        let dataTask = defaultSession.dataTask(with: url!) { (data : Data? ,response: URLResponse?,error: Error?)   in
            if (error != nil){
                print(error!)
                return
            }
            
            do{
                let json = try JSONDecoder().decode(Rates.self, from: data!)
                self.setPrices(currency: json.rates)
            }catch{
                print(error)
                return
            }
        }
        dataTask.resume()
    }
    
    func setPrices(currency:Currency){
        DispatchQueue.main.async {
            self.ethLabel.text = "1 BTC = \(self.formatPrice(currency.eth))"
            self.bnbLabel.text = "1 BTC = \(self.formatPrice(currency.bnb))"
            self.xrpLabel.text = "1 BTC = \(self.formatPrice(currency.xrp))"
            self.usdtLabel.text = "1 BTC = \(self.formatPrice(currency.usd))"
            self.adaLabel.text = "1 BTC = \(self.formatPrice(currency.ltc))"
            self.avaxLabel.text = "1 BTC = \(self.formatPrice(currency.dot))"
            self.tryLabel.text = "1 BTC = \(self.formatPrice(currency.try))"
        }
    }
    
    func formatPrice (_ price : Price)-> String{
        return String(format: "%.2f %@", price.value, price.unit)
    }
    
    
    struct Rates : Codable {
        let rates : Currency
    }
    
    struct Currency : Codable {
        let btc : Price
        let eth : Price
        let usd : Price
        let bnb : Price
        let xrp : Price
        let ltc : Price
        let dot : Price
        let `try` : Price
    }
    
    struct Price: Codable{
        let name:String
        let unit : String
        let value : Float
        let type : String
    }
        
        
        
        // Do any additional setup after loading the view.
        
    }



