//
//  RazorpayCheckout.m
//  RazorpayCheckout
//
//  Created by Akshay Bhalotia on 29/08/16.
//  Copyright © 2016 Razorpay. All rights reserved.
//

#import "RazorpayCheckout.h"
#import "RazorpayEventEmitter.h"
#import <Razorpay/Razorpay-Swift.h>

@interface RazorpayCheckout ()

@property (copy, nonatomic) RCTResponseSenderBlock callback;
@property (nonatomic,strong) RazorpayEventEmitter *emitter;

@end

@implementation RazorpayCheckout

-(id) init {
  self = [super init];
  if(self != nil) {
    _emitter = [RazorpayEventEmitter allocWithZone: nil];
  }
  return self;
}


- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(open:(NSDictionary *)options result:(RCTResponseSenderBlock)callback)
{
  NSString *keyID = (NSString *)[options objectForKey:@"key"];
  dispatch_async(dispatch_get_main_queue(), ^{
    Razorpay *razorpay = [Razorpay initWithKey:keyID andDelegateWithData:self];
    [razorpay setExternalWalletSelectionDelegate:self];
    [razorpay open:options];
  });
  _callback = callback;
}


- (void)onPaymentSuccess:(nonnull NSString *)payment_id
                 andData:(nullable NSDictionary *)response {
  [_emitter onPaymentSuccess:payment_id andData:response];
  if (_callback) {
    _callback(@[[NSNull null] , response]);
  }
}

- (void)onPaymentError:(int)code
           description:(nonnull NSString *)str
               andData:(nullable NSDictionary *)response {
  [_emitter onPaymentError:code description:str andData:response];
  NSDictionary *payload = @{
    @"code" : @(code),
    @"description" : str,
    @"details" : response
  };
  if (_callback) {
    _callback(@[[NSNull null] , payload]);
  }
}

- (void)onExternalWalletSelected:(NSString * _Nonnull)walletName WithPaymentData:(NSDictionary * _Nullable)paymentData {
  NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
  [payload addEntriesFromDictionary: paymentData];
  [payload setValue:walletName forKey:@"external_wallet"];
  if (_callback) {
    _callback(@[payload]);
  }
}

@end
