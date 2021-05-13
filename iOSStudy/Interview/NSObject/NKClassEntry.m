//
//  NKClassEntry.m
//  Interview
//
//  Created by Knox on 2021/4/25.
//

#import "NKClassEntry.h"
#import <objc/runtime.h>

@interface NKClass1 : NSObject
{
    int _age;
    int _height;
    int _no;
}
@end

@implementation NKClass1

@end


@implementation NKClassEntry

+ (void)entry {
    NSObject *object1 = [[NSObject alloc] init];
    NSObject *object2 = [[NSObject alloc] init];
    
    // 获取class对象
    Class objectClass1 = [object1 class];
    Class objectClass2 = [object2 class];
    Class objectClass3 = object_getClass(object1);
    Class objectClass4 = object_getClass(object2);
    Class objectClass5 = [NSObject class];
    // Class对象调用class方法还是返回`class`对象
    Class objectClass6 = [objectClass5 class];
    NSLog(@"class %p %p %p %p %p %p",
          objectClass1,
          objectClass2,
          objectClass3,
          objectClass4,
          objectClass5,
          objectClass6);
    
    // meta-class对象，元类对象
    Class metaClassObject1 = object_getClass(objectClass1);
    Class metaClassObject2 = [metaClassObject1 class];
    NSLog(@"meta-class %p, %p", metaClassObject1, metaClassObject2);
}

@end
