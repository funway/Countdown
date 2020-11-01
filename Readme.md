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

   需要完善这两个控件
   
   
   
3. NSTableView 每次切换时候都会有点卡

   已经优化成：1、保存每行的视图，而不是每次重建视图对象。  2、手工删除与插入行。

   但如果行数多的话，还是会有点卡。 后期的优化方向应该是从 EventRow 入手了，因为好像如果把 EventRow 简化一点，也能提高 NSTableView 的展示速度。

   

4. 是否需要增加一个功能自动清理过期N天的倒计时事件

   
