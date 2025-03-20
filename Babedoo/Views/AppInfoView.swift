//
//  AppInfoView.swift
//  Babydoo
//
//  Created by Caleb Friden on 11/1/22.
//

import SwiftUI

struct AppInfoView: View {
    @Environment(\.dismiss)
    var dismiss
    
    var body: some View {
        List {
            Section(header: Banner(),
                    footer: CopyrightNotice(),
                    content: {
                Link(destination: AppInfo.appStoreURL, label: {
                    Label("Rate \(AppInfo.displayName)", systemImage: "suit.heart")
                })
                Link(destination: AppInfo.supportURL, label: {
                    Label("Support", systemImage: "wrench.and.screwdriver")
                })
                NavigationLink(destination: PrivacyInfoView(), label: {
                    Label("Privacy", systemImage: "hand.raised")
                })
            })
        }
        .listStyle(InsetGroupedListStyle())
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .navigationTitle("About")
    }
    
    struct Banner: View {
        var body: some View {
            HStack {
                Image(uiImage: AppInfo.icon)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .aspectRatio(contentMode: .fit)
                
                VStack(alignment: .leading, content: {
                    Text(AppInfo.displayName)
                        .font(.headline)
                    
                    HStack(alignment: .lastTextBaseline, spacing: 4) {
                        Text(AppInfo.version.description)
                            .font(.subheadline)
                        
                        if isBuildShown {
                            Text("(\(AppInfo.buildString))")
                                .font(.caption)
                        }
                    }
                    .onTapGesture {
                        withAnimation {
                            isBuildShown.toggle()
                        }
                    }
                    .contextMenu {
                            Button(action: {
                                UIPasteboard.general.string = "\(AppInfo.version.description) (\(AppInfo.buildString)"
                            }) {
                                Text("Copy")
                                Image(systemName: "doc.on.doc")
                            }
                         }
                })
            }
            .padding(.vertical)
        }
        
        @State
        private var isBuildShown = false
    }
}

struct AppInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AppInfoView()
    }
}
