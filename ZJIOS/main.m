//
//  main.m
//  ZJIOS
//
//  Created by Zengjian on 2021/6/12.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    /*
     int UIApplicationMain(int argc, char * _Nullable *argv, NSString *principalClassName, NSString *delegateClas
     
     principalClassName
     The name of the UIApplication class or subclass. If you specify nil, UIApplication is assumed.
     */
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
