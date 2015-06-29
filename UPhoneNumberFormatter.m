//
//  UPhoneNumberFormatter.m
//  Connectivity library
//
//  Created by Mark Latham on 4/10/15.
//  Copyright (c) 2015 Utrepic. All rights reserved.
//
//  This class was inspired by Ahmed Abdelkader's work in 2010.
//  This work is licensed under a Creative Commons Attribution 3.0 License, found here:
//  http://creativecommons.org/licenses/by/3.0/us/
//
//  Note: A good international format property list can be found here:
//  https://code.google.com/p/iphone-patch/source/browse/trunk/bgfix/UIKit.framework/PhoneFormats/UIPhoneFormats.plist?r=7



#import "UPhoneNumberFormatter.h"

@implementation UPhoneNumberFormatter

/// Returns a formatted phone number for the given phone number in the user's current locale.
+(NSString*)formattedCurrentLocalePhoneNumber:(NSString*)phoneNumber
{
    return [self formattedPhoneNumber:phoneNumber forLocale:[NSLocale currentLocale]];
}

/// Returns a formatted phone number for the given number and locale.
+(NSString*)formattedPhoneNumber:(NSString*)phoneNumber forLocale:(NSLocale*)locale
{
    //  validate phone number
    if (!phoneNumber || [phoneNumber isEqualToString:@""])
        return phoneNumber;
    
    //  global formats from plist, loaded once on demand
    static NSDictionary *globalFormats;
    if (!globalFormats)
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PhoneFormats" ofType:@"plist"];
        globalFormats = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    }
    if (!globalFormats)
    {
        NSLog(@"PhoneFormats.plist not found.");
        return phoneNumber;
    }

    //  get locale formats
    NSString *localeID = [[[locale.localeIdentifier componentsSeparatedByString:@"_"] objectAtIndex:1] lowercaseString];
    NSArray *formats = [globalFormats valueForKey:localeID];
    
    //  remove extraneous characters from given phone number
    NSString *input = [UPhoneNumberFormatter unformattedPhoneNumber:phoneNumber];
    
    //  for all solutions in given locale
    NSMutableArray *solutions = [NSMutableArray arrayWithCapacity:5];
    for (NSString *format in formats)
    {
        //  create mutable string
        NSMutableString *formattedNumber = [NSMutableString new];
        
        //  index through input and format
        uint inputIndex = 0, formatIndex = 0;
        while ((inputIndex < input.length) && (formatIndex < format.length))
        {
            char inputChar = [input characterAtIndex:inputIndex];
            char formatChar = [format characterAtIndex:formatIndex];
            switch(formatChar)
            {
                    //  any char
                case '$':
                    [formattedNumber appendFormat:@"%c", inputChar];
                    inputIndex++;
                    break;
                    
                    //  must be number
                case '#':
                    if(inputChar < '0' || inputChar > '9') goto nextFormat;
                    [formattedNumber appendFormat:@"%c", inputChar];
                    inputIndex++, formatIndex++;
                    break;
                    
                    //  must match or insert auto-inserted characters
                case ' ':
                case '(':
                case ')':
                case '-':
                    if (inputChar == formatChar)
                        inputIndex++, formatIndex++;
                    else
                        formatIndex++;
                    [formattedNumber appendFormat:@"%c", formatChar];
                    break;
                    
                    //  all others must match, and by doing so indicate user's desired format
                default:
                    if (inputChar != formatChar) goto nextFormat;
                    [formattedNumber appendFormat:@"%c", formatChar];
                    inputIndex++, formatIndex++;
                    break;
            }
            //NSLog (@"Formatted test: %@", formattedNumber);
        }
        //  formating successful, so add to list of possible solutions
        if (inputIndex >= input.length)
            [solutions addObject:formattedNumber];
        
        //  try next format
    nextFormat:
        continue;
    }
    
    //  return shortest solution, or given phone number if none found
    NSString *result = phoneNumber;
    uint length = 1E6;
    for (NSString *solution in solutions)
        if (length > solution.length)
        {
            length = (uint)solution.length;
            result = solution;
        }
    
    return result;
}

/// Returns an unformatted phone number, stripped of any extraneous characters.
+(NSString*)unformattedPhoneNumber:(NSString*)phoneNumber
{
    //  filter input
    NSCharacterSet *filter = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789+*#"] invertedSet];
    return [[phoneNumber componentsSeparatedByCharactersInSet:filter] componentsJoinedByString:@""];
}

@end
