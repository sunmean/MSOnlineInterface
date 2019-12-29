//
//  ViewController.m
//  MSOnlineInterface
//
//  Created by SongMin on 2019/12/29.
//  Copyright © 2019 lovsoft. All rights reserved.
//

#import "ViewController.h"
#import "MSOnlineInterface.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSDictionary *getDict = [MSOnlineInterface getDicFromOnlineInterfaceWithLinkString:@"https://github.com/sunmean/EShareVersion/blob/master/version.md" andSearchRegExpStr:@"<span id=\"user-content-versiondata\">[\\s\\S]*</span></p>" andReplacingStartString:@"<span id=\"user-content-versiondata\">data = " andReplacingEndString:@"</span></p>"];
    
    NSLog(@"获取的在线接口返回字典:%@",getDict);

    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, [UIScreen mainScreen].bounds.size.width - 30, 150)];
    showLabel.numberOfLines = 0;
    showLabel.font = [UIFont systemFontOfSize:12];
    showLabel.text = [MSOnlineInterface dictionaryToJson:getDict];
    [self.view addSubview:showLabel];
    
}


@end
