//
//  NKTextAttribute.h
//  iOSStudy
//
//  Created by Knox on 2021/1/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


FOUNDATION_EXPORT NSString *const NKTextAttachmentAttributeName;




@interface NKTextAttachment : NSObject<NSCoding, NSCopying>

+ (instancetype)attachmentWithContent:(nullable id)content;
@property (nullable, nonatomic, strong) id content;     ///< Supported type: UIImage, UIView, CALayer
@property (nonatomic) UIViewContentMode contentMode;
@property (nonatomic) UIEdgeInsets contentInsets;
@property (nullable, nonatomic, strong) NSDictionary *userInfo;

@end

NS_ASSUME_NONNULL_END
