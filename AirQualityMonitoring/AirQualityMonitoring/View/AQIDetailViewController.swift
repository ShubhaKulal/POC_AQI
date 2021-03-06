//
//  AQMDetailViewController.swift
//  AirQualityMonitoring
//
//  Created by techjini on 03/12/21.
//

import UIKit
import CorePlot

class AQIDetailViewController: UIViewController {
    
    @IBOutlet var hostView: CPTGraphHostingView!
    var viewModel: AQIBaseViewModel!
    var plot: CPTScatterPlot!
    var currentIndex: Int!
    var plotData = [Double](repeating: 0.0, count: 50)
    var maxDataPoints = 50
    
    // MARK:- View life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*Intial setup of graph view*/
        self.setUpGraphView()
        viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.startSocketConnection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.stopScoketConnection()
    }
    
    func setUpGraphView(){
        configureGraphView()
        configureGraphAxis()
        configurePlot()
    }
}

//MARK:- Graph methods
extension AQIDetailViewController {
    
    func configureGraphView(){
        hostView.allowPinchScaling = false
        self.plotData.removeAll()
        self.currentIndex = 0
    }
    
    func configureGraphAxis(){
        
        let graph = CPTXYGraph(frame: hostView.bounds)
        graph.plotAreaFrame?.masksToBorder = false
        hostView.hostedGraph = graph
        graph.backgroundColor = UIColor.gray.cgColor
        graph.paddingBottom = 40.0
        graph.paddingLeft = 40.0
        graph.paddingTop = 30.0
        graph.paddingRight = 15.0
        
        
        //Set title for graph
        let titleStyle = CPTMutableTextStyle()
        titleStyle.color = CPTColor.white()
        titleStyle.fontName = "HelveticaNeue-Bold"
        titleStyle.fontSize = 20.0
        titleStyle.textAlignment = .center
        graph.titleTextStyle = titleStyle
        
        let city = viewModel.defaultCitiesList[0];
        let title = city.cityName
        graph.title = title
        graph.titlePlotAreaFrameAnchor = .top
        graph.titleDisplacement = CGPoint(x: 0.0, y: 0.0)
        
        let axisSet = graph.axisSet as! CPTXYAxisSet
        
        let axisTextStyle = CPTMutableTextStyle()
        axisTextStyle.color = CPTColor.white()
        axisTextStyle.fontName = "HelveticaNeue-Bold"
        axisTextStyle.fontSize = 10.0
        axisTextStyle.textAlignment = .center
        let lineStyle = CPTMutableLineStyle()
        lineStyle.lineColor = CPTColor.white()
        lineStyle.lineWidth = 5
        let gridLineStyle = CPTMutableLineStyle()
        gridLineStyle.lineColor = CPTColor.gray()
        gridLineStyle.lineWidth = 0.5
        
        
        if let x = axisSet.xAxis {
            x.majorIntervalLength   = 20
            x.minorTicksPerInterval = 5
            x.labelTextStyle = axisTextStyle
            x.minorGridLineStyle = gridLineStyle
            x.axisLineStyle = lineStyle
            x.axisConstraints = CPTConstraints(lowerOffset: 0.0)
            x.delegate = self
        }
        
        if let y = axisSet.yAxis {
            y.majorIntervalLength = 50
            y.minorTicksPerInterval = 50
            y.minorGridLineStyle = gridLineStyle
            y.labelTextStyle = axisTextStyle
            y.alternatingBandFills = [CPTFill(color: CPTColor.init(componentRed: 255, green: 255, blue: 255, alpha: 0.03)),CPTFill(color: CPTColor.black())]
            y.axisLineStyle = lineStyle
            y.axisConstraints = CPTConstraints(lowerOffset: 0.0)
            y.delegate = self
        }
        
        // Set plot space
        let xMin = 0.0
        let xMax = 50.0
        let yMin = 0.0
        let yMax = 500.0
        guard let plotSpace = graph.defaultPlotSpace as? CPTXYPlotSpace else { return }
        plotSpace.xRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(xMin), lengthDecimal: CPTDecimalFromDouble(xMax - xMin))
        plotSpace.yRange = CPTPlotRange(locationDecimal: CPTDecimalFromDouble(yMin), lengthDecimal: CPTDecimalFromDouble(yMax - yMin))
        
    }
    
    func configurePlot(){
        plot = CPTScatterPlot()
        let plotLineStile = CPTMutableLineStyle()
        plotLineStile.lineJoin = .round
        plotLineStile.lineCap = .round
        plotLineStile.lineWidth = 2
        plotLineStile.lineColor = CPTColor.white()
        plot.dataLineStyle = plotLineStile
        plot.curvedInterpolationOption = .catmullCustomAlpha
        plot.interpolation = .curved
        plot.identifier = "mindful-graph" as NSCoding & NSCopying & NSObjectProtocol
        guard let graph = hostView.hostedGraph else { return }
        plot.dataSource = (self as CPTPlotDataSource)
        plot.delegate = (self as CALayerDelegate)
        graph.add(plot, to: graph.defaultPlotSpace)
    }
}

extension AQIDetailViewController: CPTScatterPlotDataSource, CPTScatterPlotDelegate {
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(self.plotData.count)
    }
    
    func scatterPlot(_ plot: CPTScatterPlot, plotSymbolWasSelectedAtRecord idx: UInt, with event: UIEvent) {
    }
    
    func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any? {
        
        switch CPTScatterPlotField(rawValue: Int(field))! {
        
        case .X:
            return NSNumber(value: Int(record) + self.currentIndex-self.plotData.count)
            
        case .Y:
            return self.plotData[Int(record)] as NSNumber
            
        default:
            return 0
            
        }
        
    }
}

extension AQIDetailViewController: ViewModelDelegate {
    func viewModelDidUpdate() {
        fireTimer()
    }
}


extension AQIDetailViewController {
    func fireTimer(){
        let graph = self.hostView.hostedGraph
        let plot = graph?.plot(withIdentifier: "mindful-graph" as NSCopying)
        if((plot) != nil){
            if(self.plotData.count >= maxDataPoints){
                self.plotData.removeFirst()
                plot?.deleteData(inIndexRange:NSRange(location: 0, length: 1))
            }
        }
        guard let plotSpace = graph?.defaultPlotSpace as? CPTXYPlotSpace else { return }
        
        let location: NSInteger
        if self.currentIndex >= maxDataPoints {
            location = self.currentIndex - maxDataPoints + 2
        } else {
            location = 0
        }
        
        let range: NSInteger
        
        if location > 0 {
            range = location-1
        } else {
            range = 0
        }
        
        let oldRange =  CPTPlotRange(locationDecimal: CPTDecimalFromDouble(Double(range)), lengthDecimal: CPTDecimalFromDouble(Double(maxDataPoints-2)))
        let newRange =  CPTPlotRange(locationDecimal: CPTDecimalFromDouble(Double(location)), lengthDecimal: CPTDecimalFromDouble(Double(maxDataPoints-2)))
        print("Old Range : \(oldRange), New Range:\(newRange)")
        
        CPTAnimation.animate(plotSpace, property: "xRange", from: oldRange, to: newRange, duration:0.3)
        
        if let element = viewModel.defaultCitiesList.first {
            self.currentIndex += 1;
            print(element.aqi, element.city)
            self.plotData.append(element.aqi)
            plot?.insertData(at: UInt(self.plotData.count-1), numberOfRecords: 1)
        }
    }
}
