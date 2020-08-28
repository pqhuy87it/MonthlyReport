https://stackoverflow.com/questions/24869481/how-to-detect-if-app-is-being-built-for-device-or-simulator-in-swift

After Swift 4.1 version

#if targetEnvironment(simulator)
  // your simulator code
#else
  // your real device code
#endif

Detect the watchOS simulator

#if (arch(i386) || arch(x86_64)) && os(watchOS)
...
#endif
Detect the tvOS simulator

#if (arch(i386) || arch(x86_64)) && os(tvOS)
...
#endif
Or, even, detect any simulator

#if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
...
#endif
