//
//  ViewController.swift
//  TestWeatherCharts
//
//  Created by MAC on 03.05.2020.
//  Copyright © 2020 Alex. All rights reserved.

import UIKit
import CoreLocation
import Charts

class ViewController: UIViewController, ChartViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var weatherCollectionView: UICollectionView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentSkyLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var headacheLabel: UILabel!
    @IBOutlet weak var migraneLabel: UILabel!
    @IBOutlet weak var arthritisLabel: UILabel!
    @IBOutlet weak var blurField: UIVisualEffectView!
    
    //api new: zSo8GciSuLObCIMZo9ULnD8sAn22GdhJ
    //api new: 97ApOMXPiG2wG2NaZxSJIP1ZXVNTX3eY
    //api old: CSL0EtuZHFhfvziVEYme6VtNHud0ZWDP
    
    private var city = ""
    private let dailyWeatherURL = "http://dataservice.accuweather.com/forecasts/v1/hourly/12hour/"
    private let apiKey = "?apikey=zSo8GciSuLObCIMZo9ULnD8sAn22GdhJ"
    private var fullDailyWeatherURL = ""
    private let accuCityURL = "http://dataservice.accuweather.com/locations/v1/cities/geoposition/search"
    private var accuCityFullURL = ""
    private let fiveDayForecast = "http://dataservice.accuweather.com/forecasts/v1/daily/5day/"
    private var fullFiveDayForecasrURL = ""
    private var achesIndices = "http://dataservice.accuweather.com/indices/v1/daily/1day/"
    private var fullAchesIndices = ""
    private var weatherData = [Double]()
    private var weatherData1 = [AccuWeatherElement]()
    private var achesArray = [Double]()
    private var fiveDaysArray = [Double]()
    private var currenTemp = ""
    private var day = "n"
    private var date2 = [String]()
    private var localizedName = ""
    
    //GEO Posicion
    var lat: Double?
    var lon: Double?
    
    let locationManager = CLLocationManager()
    
    // Ekaterinburg for testing = 56.8519 60.6122
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        chartView.delegate = self
        weatherCollectionView.delegate = self
        weatherCollectionView.dataSource = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        addObservers()
        
    }
    
    fileprivate  func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    fileprivate  func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc fileprivate func applicationDidBecomeActive() {
        if(CLLocationManager.locationServicesEnabled()){
            print(#function)
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let dispQue = DispatchQueue.global(qos: .background)
        let semaphore = DispatchSemaphore(value: 0)
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        accuCityFullURL = accuCityURL+apiKey+"&q="+String(lat!)+"%2C"+String(lon!)
        
        dispQue.async {
                   
        //MARK: - JSON Geoposition Sity fetch
            JSONParse.fetchDictDatafromURL(urlString: self.accuCityFullURL) { (cityGeo : AccuCity) in
            guard (cityGeo.key != nil) else {
                DispatchQueue.main.async {
                    self.showRedAllert(title: "Error fetch city", message: "Cant fetch city from server")
                    self.loadingActivity.stopAnimating()
                    self.locationManager.stopUpdatingLocation()
                   // exit(1)
                }
                return
            }
            self.city = cityGeo.key!
            self.localizedName = cityGeo.localizedName!
            self.fullDailyWeatherURL = self.dailyWeatherURL+self.city+self.apiKey+"&metric=true"
            self.fullFiveDayForecasrURL = self.fiveDayForecast+self.city+self.apiKey+"&metric=true"
            self.fullAchesIndices = self.achesIndices+self.city+"/groups/2"+self.apiKey+"&metric=true"
                print("First : Weather URL's ready")
                semaphore.signal()
        }
            //MARK: - 5 Days Weather Forecast
            semaphore.wait()
            JSONParse.fetchDictDatafromURL(urlString: self.fullFiveDayForecasrURL) { ( fiveDaysForecastDict: AccuForecast ) in
                self.fiveDaysArray.removeAll()
                fiveDaysForecastDict.dailyForecasts.forEach { (fiveDays) in
                    self.fiveDaysArray.append(fiveDays.temperature.maximum.value)
                }
              //  print("FiveDays: \(fiveDaysForecastDict)")
                print("Second")
                semaphore.signal()
            }
            //MARK: - Aches Indices
            semaphore.wait()
            JSONParse.fetchArrayDatafromURL(urlString: self.fullAchesIndices) { ( aches : [AchesIndex]) in
                guard !aches.isEmpty else {
                    DispatchQueue.main.async {
                        self.showRedAllert(title: "Error fetch aches", message: "Cant fetch aches data from server")
                        self.loadingActivity.stopAnimating()
                        self.locationManager.stopUpdatingLocation()
                        
                        print(aches)
                       // exit(1)
                    }
                    return
                }
                aches.forEach { (achesData) in
                    self.achesArray.append(achesData.value)
                }
                print("Third")
                semaphore.signal()
            }
            //MARK: - JSON Hourly Weather
            semaphore.wait()
            JSONParse.fetchArrayDatafromURL(urlString: self.fullDailyWeatherURL) { ( weather: [AccuWeatherElement] ) in
                guard (weather.count != 0) else {
                    DispatchQueue.main.async {
                        self.showRedAllert(title: "Error fetch data", message: "Cant fetch hourly temp from server")
                        self.loadingActivity.stopAnimating()
                        self.locationManager.stopUpdatingLocation()
                       // exit(1)
                    }
                    return
                }
                
                weather.forEach { (temperatureData) in
                    self.weatherData1.append(contentsOf: weather)
                    
                    let date = Date(timeIntervalSince1970: temperatureData.epochDateTime)
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
                    dateFormatter.dateStyle = DateFormatter.Style.none //Set date style
                    dateFormatter.timeZone = .current
                    let localDate = dateFormatter.string(from: date)
                    self.date2.append(localDate)
                }
                print("Fourh")
                semaphore.signal()
        }
            semaphore.wait()
                DispatchQueue.main.async {
                    print("Fifth")
                    self.currentCityLabel.text = self.localizedName

                    if self.weatherData1.first!.isDaylight {
                        self.day = "d"
                    }
                    switch self.weatherData1.first?.iconPhrase {

                    //Weather Pictures
                    case "Sunny" :
                        self.weatherImage.image = UIImage (named: "1\(self.day).png")
                        
                    case "Mostly sunny" :
                        self.weatherImage.image = UIImage (named: "2\(self.day).png")
                        
                    case "Partly sunny" :
                        self.weatherImage.image = UIImage (named: "3\(self.day).png")

                    case "Intermittent clouds" :
                        self.weatherImage.image = UIImage (named: "4\(self.day).png")

                    case "Cloudy" :
                        self.weatherImage.image = UIImage (named: "7\(self.day).png")

                    case "Showers" :
                        self.weatherImage.image = UIImage (named: "12\(self.day).png")

                    case "Rain" :
                        self.weatherImage.image = UIImage (named: "18\(self.day).png")
                        
                    case "Clear" :
                        self.weatherImage.image = UIImage (named: "33\(self.day).png")
                        
                    case "Mostly clear" :
                        self.weatherImage.image = UIImage (named: "34\(self.day).png")
                        
                    case "Partly cloudy" :
                        self.weatherImage.image = UIImage (named: "35\(self.day).png")

                    case "Mostly cloudy" :
                        self.weatherImage.image = UIImage (named: "38\(self.day).png")

                    //Default Picture
                    default :
                        self.weatherImage.image = UIImage (named: "noimage.png")
                        print("Weather: \(self.weatherData1.first?.iconPhrase as Any) day: \(self.day)")
                    }
                    //Today Weather Main Screen
                    self.currentTempLabel.text = "+\(String((self.weatherData1.first?.temperature.value.description)!))"
                    self.currentSkyLabel.text = self.weatherData1.first?.iconPhrase


                    //Aches Labels
                    self.arthritisLabel.text = String(self.achesArray[0])
                    self.migraneLabel.text = String(self.achesArray[1])
                    self.headacheLabel.text = String(self.achesArray[2])
                    self.achesColor(self.arthritisLabel, 0)
                    self.achesColor(self.migraneLabel, 1)
                    self.achesColor(self.headacheLabel, 2)

                    self.weatherCollectionView.reloadData()

                    ChartsSetup.setDataCount(self.chartView, self.fiveDaysArray, .black)

                    self.loadingActivity.stopAnimating()
                    self.blurField.isHidden = true
                    semaphore.signal()
               }
                semaphore.wait()
            }
        
        locationManager.stopUpdatingLocation()
    }
    
    func achesColor (_ textLable: UILabel,_ index: Int) {
        if self.achesArray[index] <= 3.0 {
            textLable.textColor = .green
        } else if (self.achesArray[index] > 3.0) && (self.achesArray[index] < 5.5) {
            textLable.textColor = .orange
        } else {
            textLable.textColor = .red
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        showRedAllert(title: "GPS Error", message: "Sory, but cant retrieve location.")
    }
    
    //MARK: - COllectionView Settings
    func collectionView(_ collectionView: UICollectionView , numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeatherCollectionViewCell
        if !self.weatherData1.isEmpty {
        cell.hourlyTempLabel.text = "+"+String(self.weatherData1[indexPath.row].temperature.value)
        cell.timeLabel.text = self.date2[indexPath.row]
        cell.imageCell.image = UIImage(named: String(self.weatherData1[indexPath.row].weatherIcon)+".png")
        }
        return cell
    }

    deinit {
        removeObservers()
    }
}

extension ViewController {
    private func showRedAllert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}
