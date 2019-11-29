import { NativeModules } from 'react-native';
import { WebView } from 'react-native-webview';

class RazorpayCheckout {
  static open(options, successCallback, errorCallback) {
    return new Promise(function(resolve, reject) {
      NativeModules.RazorpayCheckout.open(options, result => {
        if (result.error) {
          reject(result.error);
          if (errorCallback) errorCallback(result.error);
        } else {
          resolve(result);
          if (successCallback) successCallback(result);
        }
      });
    });
  }
}

export default RazorpayCheckout;
