package com.razorpay.rn;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ActivityEventListener;

import com.razorpay.Checkout;
import com.razorpay.CheckoutActivity;
import com.razorpay.PaymentData;
import com.razorpay.PaymentResultWithDataListener;
import com.razorpay.ExternalWalletListener;

import org.json.JSONObject;
import android.app.Activity;
import android.content.Intent;

public class RazorpayModule extends ReactContextBaseJavaModule implements ActivityEventListener, PaymentResultWithDataListener, ExternalWalletListener {
  ReactApplicationContext reactContext;
  Callback callback;

  public RazorpayModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
    reactContext.addActivityEventListener(this);
  }

  @ReactMethod
  public void open(ReadableMap options, Callback callback) {
    this.callback = callback;
    Activity currentActivity = getCurrentActivity();
    try {
      JSONObject optionsJSON = Utils.readableMapToJson(options);
      Intent intent = new Intent(currentActivity, CheckoutActivity.class);
      intent.putExtra("OPTIONS", optionsJSON.toString());
      currentActivity.startActivityForResult(intent, 62442);
    } catch (Exception e) {
      callback.invoke(e.getMessage());
    }
  }

  public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
    onActivityResult(requestCode, resultCode, data);
  }

  public void onActivityResult(int requestCode, int resultCode, Intent data){
     Checkout.handleActivityResult(getCurrentActivity(), requestCode, resultCode, data, this, this);
  }

  @Override
  public void onPaymentSuccess(String razorpayPaymentID, PaymentData data) {
    this.callback.invoke(Utils.jsonToWritableMap(data.getData()));
  }

  @Override
  public void onPaymentError(int code, String description, PaymentData data) {
    JSONObject paymentDataJSON = new JSONObject();
    JSONObject error = data.getData();
    try {
      error.put("code", code);
      error.put("description", description);
      paymentDataJSON.put("error", error);
    } catch(Exception e) {}

    this.callback.invoke(Utils.jsonToWritableMap(paymentDataJSON));
  }

  @Override
  public String getName() { return "RazorpayCheckout"; }
  public void onNewIntent(Intent intent) {}
}
