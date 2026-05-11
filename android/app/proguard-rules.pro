# Conscrypt references Android platform SSL classes that are present at runtime
# but not in the build classpath — suppress R8 warnings for them.
-dontwarn com.android.org.conscrypt.SSLParametersImpl
-dontwarn org.apache.harmony.xnet.provider.jsse.SSLParametersImpl
