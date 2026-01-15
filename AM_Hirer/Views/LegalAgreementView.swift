import SwiftUI
import PDFKit

struct LegalAgreementView: View {
    private static let agreedKey = "LegalAgreementAccepted"
    static var hasAgreed: Bool {
        UserDefaults.standard.bool(forKey: agreedKey)
    }
    private static func setAgreed(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: agreedKey)
    }

    var onAgree: () -> Void
    var isPresentedBinding: Binding<Bool>? = nil

    @State private var agree = false
    @State private var showEULA = false
    @State private var showTOS = false
    private var eulaURL: URL? { Self.resolvePDF(named: "EULA 11-28-25") }
    private var tosURL: URL? { Self.resolvePDF(named: "Terms of Service 11-18-25") }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Please review and accept")
                        .font(.title2).bold()

                    DisclosureGroup(isExpanded: $showEULA) {
                        if let eulaURL {
                            PDFKitView(url: eulaURL)
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.3)))
                        } else {
                            Text("EULA PDF not found in app bundle.")
                                .foregroundColor(.secondary)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "doc.text")
                            Text("EULA (End User License Agreement)")
                                .fontWeight(.semibold)
                        }
                    }

                    DisclosureGroup(isExpanded: $showTOS) {
                        if let tosURL {
                            PDFKitView(url: tosURL)
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.3)))
                        } else {
                            Text("Terms of Service PDF not found in app bundle.")
                                .foregroundColor(.secondary)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "doc.text")
                            Text("Terms of Service")
                                .fontWeight(.semibold)
                        }
                    }

                    Toggle(isOn: $agree) {
                        Text("I have read and agree to the terms of service and EULA")
                    }
                    .toggleStyle(CheckboxToggleStyle())

                    Button(action: {
                        if agree {
                            Self.setAgreed(true)
                            onAgree()
                            if let isPresentedBinding {
                                isPresentedBinding.wrappedValue = false
                            }
                        }
                    }) {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(agree ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(!agree)
                }
                .padding()
            }
            .onAppear {
                showEULA = true
                showTOS = true
            }
            .navigationTitle("Legal")
            .navigationBarBackButtonHidden(true)
        }
        .interactiveDismissDisabled(true)
    }

    private static func resolvePDF(named: String) -> URL? {
        if let url = Bundle.main.url(forResource: named, withExtension: "pdf", subdirectory: "AMS-AI/PDFs") {
            return url
        }
        if let url = Bundle.main.url(forResource: named, withExtension: "pdf") {
            return url
        }
        let underscored = named.replacingOccurrences(of: " ", with: "_")
        if let url = Bundle.main.url(forResource: underscored, withExtension: "pdf", subdirectory: "AMS-AI/PDFs") {
            return url
        }
        if let url = Bundle.main.url(forResource: underscored, withExtension: "pdf") {
            return url
        }
        return nil
    }
}

// checkbox
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(configuration.isOn ? .blue : .secondary)
                configuration.label
                    .foregroundColor(.primary)
            }
        }
        .buttonStyle(.plain)
    }
}

struct PDFKitView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.document = PDFDocument(url: url)
        pdfView.backgroundColor = .systemBackground
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        if uiView.document?.documentURL != url {
            uiView.document = PDFDocument(url: url)
        }
    }
}

#Preview {
    LegalAgreementView(onAgree: {})
}
