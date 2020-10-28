//
//  AboutView.swift
//  Countdown
//
//  Created by funway on 2020/10/27.
//  Copyright © 2020 funwaywang. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 10.0) {
            HStack(spacing: 10.0) {
                Image(nsImage: NSApplication.shared.applicationIconImage).resizable().frame(width: 48, height: 48)
                
                VStack(alignment: .leading) {
                    Text("Countdown").font(Font.system(size: 20, weight: .medium).monospacedDigit())
                    Text("version \(appVersion)").font(Font.system(size: 13, weight: .regular).monospacedDigit())
                }
            }
            
            HStack {
                Text("Author:")
                HyperLinkText(text: "funway", destination: URL(string: "https://www.hawu.me")!)
                
                HyperLinkButton(destination: URL(string: "https://github.com/funway")!, label: {
                    Image("GithubIcon").resizable().frame(width: 16, height: 16)
                }).buttonStyle(BorderlessButtonStyle())
                
                HyperLinkButton(destination: URL(string: "https://twitter.com/wangfunway")!, label: {
                    Image("TwitterIcon").resizable().frame(width: 16, height: 16)
                }).buttonStyle(BorderlessButtonStyle())
            }
            
            Divider()
            
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
        AboutView()
    }
}
