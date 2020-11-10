//
//  AboutView.swift
//  Countdown
//
//  Created by funway on 2020/10/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    @State var showAlipayQRCode = false
    
    var body: some View {
        VStack(spacing: 10.0) {
            HStack(spacing: 15.0) {
                Image(nsImage: NSApplication.shared.applicationIconImage).resizable().frame(width: 64, height: 64)
                
                VStack(alignment: .leading, spacing: 3.0) {
                    Text("Countdown").font(Font.system(size: 20, weight: .medium).monospacedDigit())
                    
                    HStack {
                        Text(NSLocalizedString("About.Version", comment: "") + " \(appVersion)").font(Font.system(size: 13, weight: .regular).monospacedDigit())
                        
                        HyperLinkButton(destination: URL(string: "https://github.com/funway/Countdown/releases")!, label: {
                            Text(NSLocalizedString("About.Check", comment: "")).font(Font.system(size: 13, weight: .regular).monospacedDigit())
                        })
                    }
                }
            }
            
            HStack {
                Text(NSLocalizedString("About.Author", comment: ""))
                
                HyperLinkButton(destination: URL(string: "https://github.com/funway")!, label: {
                    Image("GithubIcon").resizable().frame(width: 16, height: 16)
                }).buttonStyle(BorderlessButtonStyle())
                
                HyperLinkButton(destination: URL(string: "https://twitter.com/wangfunway")!, label: {
                    Image("TwitterIcon").resizable().frame(width: 16, height: 16)
                }).buttonStyle(BorderlessButtonStyle())
            }
            
            HStack {
                Text(NSLocalizedString("About.Donate me with", comment: ""))
                HyperLinkText(text: "Paypal", destination: URL(string: "https://paypal.me/wangfengwei")!)
                Text(NSLocalizedString("About.or", comment: ""))
                Button(NSLocalizedString("AliPay", comment: "")){
                    self.showAlipayQRCode.toggle()
                }.popover(isPresented: self.$showAlipayQRCode, content: {
                    Image("AlipayQRCode").resizable().frame(width: 247.5, height: 371.5)
                }).buttonStyle(LinkButtonStyle())
                .foregroundColor(Color.blue)
                .onHoverAware({ hovered in
                    if hovered {
                        NSCursor.pointingHand.push()
                    } else {
                        NSCursor.pop()
                    }
                })
                Text("😜")
            }
            
            Divider().padding(.vertical, 5)
            
            ScrollView {
                VStack(spacing: 5.0) {
                    Text("Libraries:").font(.subheadline)
                    Section {
                        HyperLinkText(text: "XCGLogger", destination: URL(string: "https://github.com/DaveWoodCom/XCGLogger")!)
                        HyperLinkText(text: "SQLite.swift", destination: URL(string: "https://github.com/stephencelis/SQLite.swift")!)
                        HyperLinkText(text: "DynamicColor", destination: URL(string: "https://github.com/yannickl/DynamicColor")!)
                        HyperLinkText(text: "DateHelper", destination: URL(string: "https://github.com/melvitax/DateHelper")!)
                        HyperLinkText(text: "HoverAwareView", destination: URL(string: "https://github.com/aerobounce/HoverAwareView")!)
                    }
                    
                    Text("Resources:").font(.subheadline)
                    Section {
                        HyperLinkText(text: "Material.io", destination: URL(string: "https://material.io/resources/icons/?style=baseline")!)
                        HyperLinkText(text: "Ionicons", destination: URL(string: "https://ionicons.com/")!)
                        HyperLinkText(text: "Freepik", destination: URL(string: "https://www.flaticon.com/authors/freepik")!)
                    }
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView().frame(width: 350)
    }
}
