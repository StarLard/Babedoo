//
//  AppInfoView.swift
//  Babedoo
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
                    .accessibilityHidden(true)
                
                VStack(alignment: .leading, content: {
                    Text(AppInfo.displayName)
                        .font(.headline)
                    
                    HStack(alignment: .lastTextBaseline, spacing: 4) {
                        Text(AppInfo.version.description)
                            .font(.subheadline)
                        
                        if isBuildShown {
                            Text(verbatim: "(\(AppInfo.buildString))")
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
                                UIPasteboard.general.string = "\(AppInfo.version.description) (\(AppInfo.buildString))"
                            }) {
                                Text("Copy")
                                Image(systemName: "doc.on.doc")
                            }
                         }
                    // VoiceOver always reads the build number and offers Copy as an action.
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text("Version \(AppInfo.version.description), build \(AppInfo.buildString)", comment: "Accessibility label for the app version; placeholders are the version and build number"))
                    .accessibilityAction(named: Text("Copy")) {
                        UIPasteboard.general.string = "\(AppInfo.version.description) (\(AppInfo.buildString))"
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
