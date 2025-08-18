import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    var urlToDisplay: URL?
    @Binding var isLoading: Bool
    @Binding var progress: Double
    @EnvironmentObject var themeManager: ThemeManager
   
    public init(urlToDisplay: String, isLoading: Binding<Bool>, progress: Binding<Double>) {
        self.urlToDisplay = URL(string: urlToDisplay)
        self._isLoading = isLoading
        self._progress = progress
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        
        webView.overrideUserInterfaceStyle = themeManager.isDarkMode ? .dark : .light
        
        let style: String = themeManager.isDarkMode ? "dark" : "light"
        
        let lightModeCSS = """
            :root {
                color-scheme: light;
            }
            body {
                background-color: #FFFFFF !important;
                color: #000000 !important;
            }
            * {
                background-color: inherit !important;
                color: inherit !important;
            }
        """
        
        let darkModeCSS = """
                    :root {
                        color-scheme: light dark;
                    }
                    body {
                        background-color: #121212 !important;
                        color: #E0E0E0 !important;
                    }
                    * {
                        background-color: inherit !important;
                        color: inherit !important;
                    }
                """
        
        let colorModeCSS = themeManager.isDarkMode ? darkModeCSS : lightModeCSS
        
        let script = """
                    var style = document.createElement('style');
                    style.innerHTML = `\(colorModeCSS)`;
                    document.head.appendChild(style);
                    document.body.style.setProperty('color-scheme', '\(style)', 'important');
                """
        
        let userScript = WKUserScript(
            source: script,
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: false
        )
        
        webView.configuration.userContentController.addUserScript(userScript)
        
        if let url = urlToDisplay {
            webView.load(URLRequest(url: url))
        }
        
        return webView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, isLoading: $isLoading)
    }
    
    final class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        @Binding var isLoading: Bool
        
        init(_ parent: WebView, isLoading: Binding<Bool>) {
            self._isLoading = isLoading
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isLoading = false
            }
            parent.progress = 1.0
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.progress = Double(webView.estimatedProgress)
        }
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
    
}
