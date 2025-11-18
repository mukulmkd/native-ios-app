#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(NavigationBridge, NSObject)

RCT_EXTERN_METHOD(navigateToPDP:(NSString *)productId)
RCT_EXTERN_METHOD(navigateToCart)
RCT_EXTERN_METHOD(navigateToProducts)

@end

