//
//  NKDictionary.m
//  Interview
//
//  Created by Knox on 2021/9/1.
//

#import "NKDictionary.h"

@interface NKDicKey : NSObject<NSCopying>

@property (nonatomic, assign) NSInteger age;

@end


@implementation NKDicKey

- (id)copyWithZone:(nullable NSZone *)zone {
    NKDicKey *obj = [NKDicKey allocWithZone:zone];
    obj.age = self.age;
    return obj;
}


- (NSUInteger)hash {
    return self.age;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    } else if ([object isKindOfClass:NKDicKey.class]) {
        return self.hash == [(NKDicKey *)object hash];
    } else {
        return NO;
    }
}

- (BOOL)isEqualTo:(id)object {
    return [super isEqualTo:object];
}

@end



@implementation NKDictionary

+ (void)entry {

    NKDicKey *obj1 = [NKDicKey new];
    obj1.age = 10;
    NSLog(@"obj1 = %p", obj1);
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@(1) forKey:obj1];
    [dic setValue:@(2) forKey:@"2"];
    
    for (NKDicKey *key in dic.allKeys) {
        NSLog(@"key = %p", key);
    }
    
    NSNumber *one = [dic valueForKey:@"1"];
    NSNumber *two = [dic objectForKey:obj1];
    
//    NSLog(@"one %@", one);
//    NSLog(@"two %@", two);
    
    NSString *str1 = @"ios12345678901234567890";
    NSString *str2 = @"ios12345678901234567890";
    NSString *str3 = [NSString stringWithFormat:@"%@", str2];
    
    NSLog(@"str1 = %p", str1);
    NSLog(@"str2 = %p", str2);
    NSLog(@"str3 = %p", str3);
    
    NSLog(@"str1 == str2 %d", [str1 isEqual:str2]);
    NSLog(@"str1 == str3 %d", [str1 isEqual:str3]);
    
    NSLog(@"str1 == str2 %d", [str1 isEqualToString:str2]);
    NSLog(@"str1 == str3 %d", [str1 isEqualToString:str3]);
}


@end
