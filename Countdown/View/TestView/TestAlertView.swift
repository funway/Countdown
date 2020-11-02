//
//  TestAlertView.swift
//  Countdown
//
//  Created by funway on 2020/11/2.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI



struct TestAlertView: View {
    @State var showAlert = true
    
    var body: some View {
        VStack {
            Text("hello").font(.headline)
            Spacer()
        }.padding()
        .frame(width: 400, height: 300)
        .overlyingAlert(showAlert: $showAlert, title: "Confirm delete?", message: "Delete countdown [ xxx ]的撒分积分卡上就放了快仨附近开了阿萨德肌肤快乐撒点击可怜的撒娇浪费 ", confirmButton: Button("Cancel"){}, cancelButton: Button("Delete"){})
        
    }
}

struct TestAlertView_Previews: PreviewProvider {
    static var previews: some View {
        TestAlertView()
    }
}
