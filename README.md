# OCJSDemo
JS跟Native交互, JS调用原生相机获取照片数据展示


 JS同原生交互
 JS获取原生照片, 通过照片流(UIImage base64编码)给JS, 如果图片数据量比较大, 必然会导致原生跟H5的通信卡顿, 延迟问题;
 解决方案:
 把图片数据保存到本地, 通过图片路径传递给H5, h5通过路径读取;


效果图:

![输入图片说明](https://github.com/bjheweihua/OCJSDemo/blob/master/demo.GIF "")
