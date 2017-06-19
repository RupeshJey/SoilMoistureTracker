//
//  VisualizationViewController.swift
//  SoilMoisture
//
//  Created by Rupesh Jeyaram on 3/13/17.
//  Copyright © 2017 Planlet Systems. All rights reserved.
//

import UIKit
import Charts

class VisualizationViewController: UIViewController {

    @IBOutlet weak var lineChart: LineChartView!
    
    let recordsID = "recordsID"
    var recordsArray:[Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserDefaults.standard.array(forKey: recordsID) == nil) {
            UserDefaults.standard.set([], forKey: recordsID)
        }
        
        recordsArray = UserDefaults.standard.array(forKey: recordsID)
        
        setChart(dataPoints: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct"], values: [25, 20, 33, 43, 22, 14, 25, 45, 35, 10])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
        
        //let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Units Sold")
        //let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        //pieChartView.data = pieChartData
        
        /*var colors: [UIColor] = []
        
        for i in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors*/
        
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Moisture Content")
        let lineChartData = LineChartData (dataSet: lineChartDataSet)
        
        lineChart.animate(yAxisDuration: 1)
        lineChart.data = lineChartData
        
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
