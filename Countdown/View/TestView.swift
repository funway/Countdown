//
//  TestView.swift
//  Countdown
//
//  Created by funway on 2020/7/29.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct TestView: View {
    @State var password : String = ""
    
    var body: some View {
        
        VStack{
            
            Text("Your password is \(password)!")
            
            SecureField("Your password", text: $password) {
                print("Your password is \(self.password)!")
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
        }
        .padding()
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
