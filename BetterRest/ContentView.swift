//
//  ContentView.swift
//  BetterRest
//
//  Created by Soumyattam Dey on 27/06/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp=defaultDate
    @State private var sleepAmount=8.0
    @State private var coffeeAmount=1
    
    
    static var defaultDate:Date{
        var components=DateComponents()
        components.hour=7
        components.minute=0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var calculateBedTime:String{
        let model=SleepCalculator()
        let components=Calendar.current.dateComponents([.hour,.minute], from: wakeUp)
        let hour=(components.hour ?? 0) * 60 * 60
        let minute=(components.minute ?? 0) * 60
        var requiredSleepTime=""
        
        do{
            let prediction=try model.prediction(wake: Double(hour+minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime=wakeUp-prediction.actualSleep
            let formatter=DateFormatter()
            formatter.timeStyle = .short
            requiredSleepTime=formatter.string(from: sleepTime)
            
        }catch{
            requiredSleepTime="Something went wrong !"
        }
        
        return requiredSleepTime
    }
    
    
    var body: some View {
        NavigationView{
            Form{
                Section(header:Text("When do you want to wake up?")){
                    DatePicker("Please enter your name",selection:$wakeUp,displayedComponents:.hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                Section(header:Text("Desired amount of sleep ?")){
                    Stepper(value: $sleepAmount, in: 4...12, step:0.25){
                        Text("\(sleepAmount,specifier: "%g") hours")
                    }
                }
                Section(header:Text("Daily coffee intake")){
                    Picker("Cups of coffee",selection:$coffeeAmount){
                        ForEach( 0..<21){
                            Text("\($0)")
                        }
                    }
                }
                Section(header:Text("Your sleeptime")){
                    Text("\(calculateBedTime)")
                }
            }
            .navigationBarTitle("BetterRest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
