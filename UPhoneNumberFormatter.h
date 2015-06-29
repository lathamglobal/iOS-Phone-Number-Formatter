//
//  UPhoneNumberFormatter.h
//  Connectivity
//
//  Created by Mark Latham on 4/10/15.
//  Copyright (c) 2015 Utrepic. All rights reserved.
//
//  This class was inspired by Ahmed Abdelkader's work in 2010.
//  This work is licensed under a Creative Commons Attribution 3.0 License, found here:
//  http://creativecommons.org/licenses/by/3.0/us/
//
//  Note: A good international format property list 'UIPhoneFormats.plist' can be found here:
//  https://code.google.com/p/iphone-patch/source/browse/trunk/bgfix/UIKit.framework/PhoneFormats/UIPhoneFormats.plist?r=7



#import <Foundation/Foundation.h>

@interface UPhoneNumberFormatter : NSObject

/// Returns a formatted phone number for the given phone number in the user's current locale.
+(NSString*)formattedCurrentLocalePhoneNumber:(NSString*)phoneNumber;

/// Returns a formatted phone number for the given number and locale.
+(NSString*)formattedPhoneNumber:(NSString*)phoneNumber forLocale:(NSLocale*)locale;

/// Returns an unformatted phone number, stripped of any extraneous characters.
+(NSString*)unformattedPhoneNumber:(NSString*)phoneNumber;


@end
