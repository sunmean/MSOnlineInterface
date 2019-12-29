//
//  MSOnlineInterface.m
//  MSOnlineInterface
//
//  Created by SongMin on 2019/12/29.
//  Copyright © 2019 lovsoft. All rights reserved.
//

#import "MSOnlineInterface.h"

@implementation MSOnlineInterface

static MSOnlineInterface *manager = nil;
+ (instancetype)defaultShareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [MSOnlineInterface new];
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    
    return manager;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[self class] defaultShareManager];
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone {
    return [[self class] defaultShareManager];
}


+ (NSDictionary *)getDicFromOnlineInterfaceWithLinkString:(NSString *)linkString andSearchRegExpStr:(NSString *)regExpStr andReplacingStartString:(NSString *)startString andReplacingEndString:(NSString *)endString{
    
    NSDictionary *dic = nil;
    if (linkString.length == 0) {
        return dic;
    }
    NSString *fromHtmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:linkString] encoding:NSUTF8StringEncoding error:nil];
    NSString *resultStr = @"";
    if (linkString.length > 0) {
        resultStr = [MSOnlineInterface partStringOfCheckStringWithRegularExpression:regExpStr checkString:fromHtmlString];
    }
    //替换无用字符串
    if (startString.length > 0) {
        resultStr = [resultStr stringByReplacingOccurrencesOfString:startString withString:@""];
    }
    if (endString.length > 0) {
        resultStr = [resultStr stringByReplacingOccurrencesOfString:endString withString:@""];
    }
//    NSLog(@"最后需要的字符串:%@",resultStr);
    //字符串转字典
    dic = [MSOnlineInterface dictionaryWithJsonString:resultStr];
    return dic;
}


+ (NSString *)partStringOfCheckStringWithRegularExpression:(NSString *)regex checkString:(NSString *)checkString {
    if (!checkString) {
        return nil;
    }
    NSError *error = NULL;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive |
        NSRegularExpressionDotMatchesLineSeparators error:&error];
    
    NSTextCheckingResult *result =
    [regularExpression firstMatchInString:checkString options:NSMatchingReportProgress range:NSMakeRange(0, [checkString length])];
    return result ? [checkString substringWithRange:result.range] : nil;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/*!
 * @brief 字典转换为字符串
 * @param dic 字典
 * @return 返回字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}




@end
