//
//  Bridging-Header.h
//  BeiBeiWu
//
//  Created by 江东 on 2019/8/9.
//  Copyright © 2019 江东. All rights reserved.
//

#ifndef Bridging_Header_h
#define Bridging_Header_h


#endif /* Bridging_Header_h */

#import <RongIMKit/RongIMKit.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate : UIResponder<UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
