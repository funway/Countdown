# 开发环境

macOS 10.15.5

Xcode 11.7



# 依赖库

默认使用 Carthage 进行依赖库管理

- XCGLogger

  https://github.com/DaveWoodCom/XCGLogger

  

- SQLite.swift

  https://github.com/stephencelis/SQLite.swift
  
  
  
- DynamicColor
  
  https://github.com/yannickl/DynamicColor
  
  
  
- DateHelper

  version 4.4.1

  https://github.com/melvitax/DateHelper
  
  因为这个库实际上只有一个文件 DateHelper.swift，所以直接将该文件拷贝到项目 Helper 目录下，而不使用 Carthage
  
  
  
- HoverAwareView

  version 1.1.1

  https://github.com/aerobounce/HoverAwareView
  
  直接将 HoverAwareView.swift 文件拷贝到 Helper 目录下，不使用 Carthage



# Todo

1. NSSwitch 控件，当窗口不是 keywindow 的时候，其选中的蓝色底色会变成灰色 =。 =

   这个好像无解

   

2. datepicker、ColorPicker

   参考下 Swift-Mac 这个项目
   
   
   
3. NSTableView 刷新有点卡

   应该是因为每次 NSTableView.reloadData() 都会删除，然后重建视图导致的。

   可以不让它reloadData，手工 removeRows 和 insertRows