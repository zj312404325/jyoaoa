/** layui-v0.0.7 跨设备模块化前端框架@LGPL www.layui.com By 贤心 */
;layui.define(["jquery","layer"],function(a){var e=layui.jquery,i=layui.layer;a("upload",function(a){a=a||{};var t=e("body"),r=(navigator.userAgent.toLowerCase().match(/msie\s(\d+)/)||[],e(a.file||".layui-upload-file")),n=e('<iframe id="layui-upload-iframe" class="layui-upload-iframe" name="layui-upload-iframe"></iframe>');a.check=a.check||"images",e("#layui-upload-iframe")[0]||t.append(n),r.each(function(){var t=e(this),r='<form target="layui-upload-iframe" method="'+(a.method||"post")+'" key="set-mine" enctype="multipart/form-data" action="'+(a.url||"")+'"></form>';a.unwrap||(r='<div class="layui-upload-button">'+r+'<span class="layui-upload-icon"><i class="layui-icon">&#xe608;</i>'+(t.attr("layui-text")||"上传图片")+"</span></div>"),r=e(r),"layui-upload-iframe"===t.parent("form").attr("target")&&(a.unwrap?t.unwrap():(t.parent().next().remove(),t.unwrap().unwrap())),t.wrap(r),t.off("change").on("change",function(){var r=e(this),n=r.val(),u=e("#layui-upload-iframe");if(n){if("images"===a.check&&!/\w\.(jpg|png|gif|bmp|jpeg)$/.test(escape(n)))return i.msg("图片格式不对"),r.val("");t.parent().submit(),a.before&&a.before();var l=setInterval(function(){try{var e=u.contents().find("body").text()}catch(t){i.msg("发送文件不能大于10M，谢谢！"),clearInterval(l)}e&&(clearInterval(l),"function"==typeof a.success&&a.success(e),u.contents().find("body").html(""))},30);r.val("")}})})})});