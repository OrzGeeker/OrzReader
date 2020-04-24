# OrzReader

一个最简PDF阅读器

因为iBook没有按屏幕宽度缩放显示的功能，所以为了能尽可能利用屏幕空间显示PDF内容，开发了这个阅读助手。

# Wiki

[Home](https://github.com/OrzGeeker/OrzReader/wiki)


## 持续集成

```bash
$ xcodebuild -project 'OrzReader.xcodeproj' -scheme 'OrzReader' -destination 'platform=iOS Simulator,name=iPhone 8' test
```

## 持续分发

使用`Fastlane`工具完成自动化任务


环境配置

```bash
$ xcode-select --install  
$ xcode-select --print-path
$ brew -v
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
$ brew doctor
$ ruby -v
$ brew install ruby
$ gem install bundler
$ git --version
```

安装`Fastlane`

```bash
$ brew cask uninstall fastlane
$ sudo gem install fastlane
```

可以考虑使用`RVM`对`ruyb`环境进行隔离 

使用`Fastlane`，进入工程目录，初始化

```bash
$ cd project
$ fastlane init
$ open .
```

选 `4`定制，一路回车

注册应用Bundle ID，并在创建应用

```bash
$ fastlane produce
```
或者直接命令行指定

```bash
$ fastlane produce \
--username 824219521@qq.com \
--app_identifier com.joker.OrzReader \
--app_name OrzReader \
--team_name Zhizhou Wang \
--itc_team_name Zhizhou Wang
```
查看action帮助文档

```bash
$ fastlane actions produce
```

在自动化流中使用: `lane`的方式，在Fastfile中定义

```ruby

default_platform(:ios)

platform :ios do

  desc "Description of what the lane does"
  lane :custom_lane do
    # add actions here: https://docs.fastlane.tools/actions
  end

  desc "Register Your App"
  lane :register_app do
    produce(
      username: "824219521@qq.com",
      app_identifier: "com.joker.OrzReader",
      app_name: "OrzReader",
      team_name: "Zhizhou Wang",
      itc_team_name: "Zhizhou Wang"
    )
  end

end
```

```bash
$ fastlane register_app
```

管理证书

```base
$ fastlane cert
$ fastlane cert --help
$ fastlane cert --development -u 824219521@qq.com -l Zhizhou Wang
$ fastlane cert revoke_expired
```

管理授权文件

```bash
$ fastlane sigh
```

使`用Appfile`可以统一存储应用元数据, 不需要每次传入相同的参数

fastlane sign 有问题更新到ruby最新版本, 建议使用ruby2.6

团队开发工程配置, 创建一个私人仓库，用来存放团队开发的证书及相关许可文件

```bash
$ fastlane match init
$ fastlane match nuke development
$ fastlane match nuke distribution
$ fastlane match nuke enterprise
$ fastlane match development
$ fastlane match adhoc
$ fastlane match appstore
```

`fastlane list`列出可用的lane


- [配合蒲公英上传发布](http://www.pgyer.com/doc/view/fastlane)