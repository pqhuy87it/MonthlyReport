https://stackoverflow.com/questions/31254725/transport-security-has-blocked-a-cleartext-http

<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSExceptionDomains</key>
    <dict>
        <key>example.com</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSIncludesSubdomains</key>
            <true/>
        </dict>
    </dict>
</dict>

----

<key>NSAppTransportSecurity</key>
<dict>
  <key>NSExceptionDomains</key>
  <dict>
    <key>example.com</key>
    <dict>
      <!--Include to allow subdomains-->
      <key>NSIncludesSubdomains</key>
      <true/>
      <!--Include to allow HTTP requests-->
      <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
      <true/>
      <!--Include to specify minimum TLS version-->
      <key>NSTemporaryExceptionMinimumTLSVersion</key>
      <string>TLSv1.1</string>
    </dict>
  </dict>
</dict>

The lazy option is:

<key>NSAppTransportSecurity</key>
<dict>
  <!--Include to allow all connections (DANGER)-->
  <key>NSAllowsArbitraryLoads</key>
      <true/>
</dict>

---

https://stackoverflow.com/questions/30731785/how-do-i-load-an-http-url-with-app-transport-security-enabled-in-ios-9?noredirect=1&lq=1

<key>NSAppTransportSecurity</key>
<dict>
<key>NSExceptionDomains</key>
<dict>
<key>testdomain.com</key>
<dict>
<key>NSIncludesSubdomains</key>
<true/>
<key>NSExceptionAllowsInsecureHTTPLoads</key>
<true/>
<key>NSExceptionRequiresForwardSecrecy</key>
<true/>
<key>NSExceptionMinimumTLSVersion</key>
<string>TLSv1.2</string>
<key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>
<false/>
<key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
<true/>
<key>NSThirdPartyExceptionMinimumTLSVersion</key>
<string>TLSv1.2</string>
<key>NSRequiresCertificateTransparency</key>
<false/>
</dict>
</dict>
</dict>

