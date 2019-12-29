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

/*!
 * @brief 获取在线接口数据转换成字典返回
 * @param linkString   请求的链接地址
 * @param regExpStr    获取匹配内容的正则表达式
 * @param startString  需要替换去除掉的开始标识字符串
 * @param endString    需要替换去除掉的结束标识字符串
 * @return 返回字典
 */
+ (NSDictionary *)getDicFromOnlineInterfaceWithLinkString:(NSString *)linkString andSearchRegExpStr:(NSString *)regExpStr andReplacingStartString:(NSString *)startString andReplacingEndString:(NSString *)endString;

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/*!
 * @brief 字典转换为字符串
 * @param dic 字典
 * @return 返回字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
