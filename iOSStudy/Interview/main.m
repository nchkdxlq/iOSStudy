//
//  main.m
//  Interview
//
//  Created by Knox on 2021/4/25.
//

#import <Foundation/Foundation.h>
//#import "NKClassEntry.h"
#import "NKBlockEntry.h"
#import "NKRuntime.h"
#import "Synchronized.h"
#import "NKDictionary.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        [NKClassEntry entry];
//        [NKBlockEntry entry];
//        [NKRuntime entry];
//        [Synchronized entry];
        [NKDictionary entry];
        
        NSString *str = @"";
        
        NSString *pattern = @"";
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];

        NSArray<NSTextCheckingResult *> *result = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
        if (result) {
            for (int i = 0; i<result.count; i++) {
                NSTextCheckingResult *res = result[i];
                NSLog(@"str == %@", [str substringWithRange:res.range]);
            }
        }else{
            NSLog(@"error == %@",error.description);
        }
        
        
    }
    return 0;
}
