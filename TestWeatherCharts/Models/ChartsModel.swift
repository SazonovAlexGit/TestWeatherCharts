//
//  ChartsModel.swift
//  TestWeatherCharts
//
//  Created by MAC on 21.05.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import Charts

class ChartsSetup {
    
   static func setDataCount(_ objtoChart: LineChartView,_ arrayToCharts: [Double],_ color: UIColor) {
    var chartEntry = [ChartDataEntry]()
    var chartEntry1 = [ChartDataEntry]()
    
    
    for i in 0..<arrayToCharts.count {
        let value = BarChartDataEntry(x: Double(i), y: Double(arrayToCharts[i]))
        let value1 = BarChartDataEntry(x: Double(i), y: Double(arrayToCharts[i]-0.05))
        
        chartEntry.append(value)
        chartEntry1.append(value1)
    }
    
    let set1 = LineChartDataSet(entries: chartEntry)
    set1.drawIconsEnabled = false
    set1.setColor(color)
    
    let set2 = LineChartDataSet(entries: chartEntry1)
    set2.drawIconsEnabled = false
    set2.setColor(.lightGray)
    
    objtoChart.chartDescription?.enabled = false
    objtoChart.dragEnabled = false
    objtoChart.setScaleEnabled(false)
    objtoChart.pinchZoomEnabled = false
    objtoChart.legend.enabled = false
    objtoChart.xAxis.enabled = false
    
    let leftAxis = objtoChart.leftAxis
    leftAxis.enabled = false
    
    if !arrayToCharts.isEmpty {
    leftAxis.axisMaximum = arrayToCharts.max()! + 5
    leftAxis.axisMinimum = arrayToCharts.min()! - 10
    }
    
    let rightAxis = objtoChart.rightAxis
    rightAxis.enabled = false
    
    //            set1.setCircleColor(.black)
    //            set1.lineWidth = 1
    //            set1.circleRadius = 3
    //            set1.drawCircleHoleEnabled = false
    //            set1.valueFont = .systemFont(ofSize: 9)
    //            set1.formLineDashLengths = [5, 2.5]
    //            set1.formLineWidth = 3
    //            set1.formSize = 15
    set1.cubicIntensity = 0.2
    set1.valueFormatter = DefaultValueFormatter(decimals: 1)
    set1.lineWidth = 2
    set1.lineDashLengths = .none
    set1.drawCirclesEnabled = false
    set1.fillAlpha = 1
    set1.fill = Fill(color: .white)
    set1.drawFilledEnabled = true
    set1.mode = .cubicBezier
    
    set2.cubicIntensity = 0.2
    set2.lineWidth = 2
    set2.lineDashLengths = .none
    set2.drawCirclesEnabled = false
    set2.fillAlpha = 1
    set2.fill = Fill(color: .white)
    set2.drawFilledEnabled = true
    set2.mode = .cubicBezier
    set2.drawValuesEnabled = false
    
    //            let data = LineChartData(dataSet: set1)
    let data1 = LineChartData(dataSets: [set1, set2])
    
    objtoChart.data = data1
    }
}

