https://stackoverflow.com/questions/59265642/detect-button-click-in-wkwebview

func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        guard let urlAsString = navigationAction.request.url?.absoluteString.lowercased() else {
            return
        }

        if urlAsString.range(of: "the url that the button redirects the webpage to") != nil {
        // do something
        } 
     }
