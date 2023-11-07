/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The app and main window group scene.
*/

import SwiftUI

@main
struct EarthquakesApp: App {
    var body: some Scene {
        WindowGroup {
            Quakes()
                .onAppear(perform: {
                    printFunctionName(3)
                })
        }
    }
    func printFunctionName(_ param: Int){
        print(#function)
    }

}
