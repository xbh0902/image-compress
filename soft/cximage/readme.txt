使用方式:
把要压缩的图片文件夹拖动到bat脚本的图标上,放开.
最重要的是什么:无损.

特色:
1.自动遍历目标文件夹,递归到所有子文件夹.
2.可调节压缩率.默认是60
3.用Cximage的官方类库,地址http://www.xdp.it/cximage/
4.不用安装java,打开就能用.

注意:
1.使用了Cximage的类库,必须先进行regsrv32.
2.必须确保bin和lib目录下文件的存在.
3.执行出错请在管理员命令窗口中执行sc config winmgmt start= auto，然后再进行批量压缩.