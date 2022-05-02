//
//  NKOperationViewController.m
//  iOSStudy
//
//  Created by Knox on 2021/8/26.
//

#import "NKOperationViewController.h"

@implementation NKOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSOperation *op = [NSOperation new];
    NSOperationQueue *queue = [NSOperationQueue new];
    
//    [self moveItem];
//    [self copyItem];
    [self subPath];
    [self contentsOfDirectoryAtPath];
}

- (void)moveItem {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSURL *srcURL = [NSURL fileURLWithPath:@"/Users/knox/Downloads/abc/stack.png"];
    NSURL *destURL = [NSURL fileURLWithPath:@"/Users/knox/Downloads/123/test.png"];
    [manager moveItemAtURL:srcURL toURL:destURL error:&error];
    NSLog(@"%@", error);
}


- (void)copyItem {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSURL *srcURL = [NSURL fileURLWithPath:@"/Users/knox/Downloads/abc/stack.png"];
    NSURL *destURL = [NSURL fileURLWithPath:@"/Users/knox/Downloads/123/test.png"];
    [manager copyItemAtURL:srcURL toURL:destURL error:&error];
    NSLog(@"%@", error);
}


- (void)subPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = @"/Users/knox/Downloads/abc";
    NSArray<NSString *> *subpaths = [manager subpathsAtPath:path];
    NSLog(@"%@", subpaths);
}

/// 返回当前目录下的子目录和文件(类似返回树结点的子节点)
- (void)contentsOfDirectoryAtPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = @"/Users/knox/Downloads/abc";
    NSArray<NSString *> *subpaths = [manager contentsOfDirectoryAtPath:path error:NULL];
    NSLog(@"%@", subpaths);
}


@end
