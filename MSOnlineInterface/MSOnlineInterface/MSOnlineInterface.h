//
//  MSOnlineInterface.h
//  MSOnlineInterface
//
//  Created by SongMin on 2019/12/29.
//  Copyright © 2019 lovsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSOnlineInterface : NSObject

+ (instancetype)defaultShareManager;

+ (NSDictionary *)getDicFromOnlineInterfaceWithLinkString:(NSString *)linkString andSearchRegExpStr:(NSString *)regExpStr andReplacingStartString:(NSString *)startString andReplacingEndString:(NSString *)endString;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
