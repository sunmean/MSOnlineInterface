# MSOnlineInterface
通过GitHub的仓库功能写一个应用接口或类似在线参数的功能。<br/>

---
简要介绍
==============
我们在日常工作中，经常会遇到服务器更新线上代码或者域名更换SSL证书，导致无法请求接口的问题。最终引起无法请求版本升级接口，导致无法强制更新App版本。<br/>
我想了一下，如果有在线参数或有云函数，就可以很好解决这个问题。但是，云函数好多网站要收费，以前常用的友盟的在线参数功能也静悄悄下线了，腾讯的在线参数倒还看到有，但要引入很大的SDK，感觉会严重增大应用包的大小，还是放弃了在线参数这个方案。思来想去，可以将接口文件写好存到自己官网服务器上，直接读取文件即可。可是当我直接用下面的方法去获取线上文件的内容时，却遗憾的发现自己官网那个链接是重定向的方式跳转，导致无法获取到想要的数据。<br/>
```objc
+ (nullable instancetype)stringWithContentsOfURL:(NSURL *)url encoding:(NSStringEncoding)enc error:(NSError **)error;
```
1.正当我无计可施的时候，突然想到GitHub网站就是共享代码的地方，何不充分利用GitHub储存空间，存放一些接口文件。于是，我就写了一个md格式的接口文件上传到了GitHub里面，发现里面同样也有很多HTML的代码，但是没有被重定向，可以看到自己写的接口内容了。我写的接口内容如下：
```html
<span id = 'versionData'>data = {
"appId" : "修复已知的问题",
"version" : "1.1.1",
"versionCode" : "-1",
"isOpen" : "0"
}</span>
```
2.但很奇怪我明明写的id是“versionData”，但需要注意GitHub返回的id是“user-content-versiondata”。id只是增加了前缀，无所谓了。
3.首先我需要获取对应id的span里面的内容，于是我写<span id=\"user-content-versiondata\">[\\s\\S]*</span></p>的正则表达式通过正则从整个网页当中去获取到上面需要的内容。经过正则匹配筛选后的结果如下：
```html
<span id="user-content-versiondata">data = {
"appId" : "修复已知的问题",
"version" : "1.1.1",
"versionCode" : "-1",
"isOpen" : "0"
}</span></p>
```
4.再通过下面的方法去替换去除开始和结尾部分的HTML标签，只取到JsonString的字符串。
```objc
- (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement
```
5.再通过JsonString字符串转字典的方法，将接口的数据返回一个字典出来，这样就可以当接口调用了。

使用方法
==============

### 一.调用头文件
```objc
#import "MSOnlineInterface.h"
```

### 二.导入方法文件夹
导入MSOnlineInterface的文件夹。<br/>

### 三.方法调用
```objc
    NSDictionary *getDict = [MSOnlineInterface getDicFromOnlineInterfaceWithLinkString:@"https://github.com/sunmean/MSOnlineInterface/blob/master/version.md" andSearchRegExpStr:@"<span id=\"user-content-versiondata\">[\\s\\S]*</span></p>" andReplacingStartString:@"<span id=\"user-content-versiondata\">data = " andReplacingEndString:@"</span></p>"];
    
    NSLog(@"获取的在线接口返回字典:%@",getDict);

    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, [UIScreen mainScreen].bounds.size.width - 30, 150)];
    showLabel.numberOfLines = 0;
    showLabel.font = [UIFont systemFontOfSize:12];
    if (getDict) {
        showLabel.text = [MSOnlineInterface dictionaryToJson:getDict];
    }
    [self.view addSubview:showLabel];
```

### 四.方法参数说明
```objc
/*!
 * @brief 获取在线接口数据转换成字典返回
 * @param linkString   请求的链接地址
 * @param regExpStr    获取匹配内容的正则表达式
 * @param startString  需要替换去除掉的开始标识字符串
 * @param endString    需要替换去除掉的结束标识字符串
 * @return 返回字符串
 */
+ (NSDictionary *)getDicFromOnlineInterfaceWithLinkString:(NSString *)linkString andSearchRegExpStr:(NSString *)regExpStr andReplacingStartString:(NSString *)startString andReplacingEndString:(NSString *)endString;
```

### 五.温馨提示
==============
如果由于旧版本Xcode导致无法运行，请在Xcode顶部菜单栏上面选择“File”->"Workspace Settings..."->"Build System"->"Legacy Build System"。设置一下就可以兼容旧版本Xcode生成的项目引起的报错。
