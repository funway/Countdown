//
//  TestPreference.swift
//  Countdown
//
//  Created by funway on 2020/10/24.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct TestPreference: View {
    @ObservedObject var preference = Preference.shared
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            TextField("test string: ", text: $preference.testString)
        }
    }
}

struct TestPreference_Previews: PreviewProvider {
    static var previews: some View {
        TestPreference()
    }
}
