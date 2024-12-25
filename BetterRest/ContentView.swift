//
//  ContentView.swift
//  BetterRest
//
//  Created by Hadi Al zayer on 23/06/1446 AH.
//
import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defualtWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeAmount = 1
    
    var calculatedBedTime: String{
        do{
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            return sleepTime.formatted(date: .omitted, time: .shortened)
            
        }catch{
            return "Error"
        }
    }
    
    
     static var defualtWakeTime: Date{
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from:components) ?? .now
    }
    
    
    
    
    
    var body: some View {
        NavigationStack{
            Form{
                VStack(alignment:.leading , spacing: 0){
                    Text("When do you want to wake up").font(.headline)
                    DatePicker("", selection: $wakeUp, displayedComponents: .hourAndMinute).labelsHidden()
                }
                VStack(alignment:.leading , spacing: 0){
                    Text("Desired amount of sleep").font(.headline)
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount,in: 4...12, step: 0.15)
                }
                VStack(alignment:.leading , spacing: 0){
                    Text("Daily coffe consumed").font(.headline)
                    Picker("^[\(coffeAmount) cup](inflect: true)",selection: $coffeAmount){
                        ForEach(1...20, id: \.self){
                            Text("\($0)")
                        }
                    }
                }
                Section("Calculated bed time"){
                    Text("You need to Sleep at \(calculatedBedTime)")
                }.font(.headline)
                
                
            }
            .navigationTitle("BetterRest")
                
            }
    }
        
    }


#Preview {
    ContentView()
}
