//
//  TestPicker.swift
//  Countdown
//
//  Created by funway on 2020/10/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct TestPicker: View {
    var colors = ["Red", "Green", "Blue", "Tartan"]
    @State private var selectedColor = 0

    var body: some View {
       VStack {
          Picker(selection: $selectedColor, label: Text("Please choose a color")) {
             ForEach(0 ..< colors.count) {
                Text(self.colors[$0])
             }
        }.pickerStyle(RadioGroupPickerStyle())
          Text("You selected: \(colors[selectedColor])")
       }
    }
}

struct TestPicker_Previews: PreviewProvider {
    static var previews: some View {
        TestPicker()
    }
}
