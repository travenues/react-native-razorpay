//
//  RazorpayEventEmitter.m
//  RazorpayCheckout
//
//  Created by Akshay Bhalotia on 19/09/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RazorpayEventEmitter.h"

NSString *const kPaymentError = @"PAYMENT_ERROR";
NSString *const kPaymentSuccess = @"PAYMENT_SUCCESS";
NSString *const kExternalWalletSelected = @"EXTERNAL_WALLET_SELECTED";

@implementation RazorpayEventEmitter

RCT_EXPORT_MODULE();

+ (id)allocWithZone:(NSZone *)zone {
    static RazorpayEventEmitter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [super allocWithZone:zone];
    });
    return sharedInstance;
}

- (NSArray<NSString *> *)supportedEvents {
  return @[
    @"PAYMENT_SUCCESS",
    @"PAYMENT_ERROR",
    @"EXTERNAL_WALLET_SELECTED"
  ];
}

- (void)sendNotificationWithName:(NSString *)eventName body:(id)body {
    [self sendEventWithName:eventName body:body];
}

- (void)onPaymentSuccess:(NSString *)payment_id andData:(NSDictionary *)response {
  [self sendEventWithName:kPaymentSuccess body:@{@"name": response}];
}

- (void)onPaymentError:(int)code
           description:(NSString *)str
               andData:(NSDictionary *)response {
  NSDictionary *payload = @{
    @"code" : @(code),
    @"description" : str,
    @"details" : response
  };
  [self sendEventWithName:kPaymentError body:@{@"name": payload}];
}

- (void)onExternalWalletSelected:(NSString *)walletName andData:(NSDictionary *)paymentData {
  NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
  [payload addEntriesFromDictionary: paymentData];
  [payload setValue:walletName forKey:@"external_wallet"];
  [self sendEventWithName:kExternalWalletSelected body:@{@"name": payload}];
}

@end
