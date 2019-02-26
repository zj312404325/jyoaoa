<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>信息管理</title>
	<meta name="decorator" content="default"/>

	<link rel="stylesheet" href="${ctxStatic}/editormd/css/editormd.preview.min.css" />
	<link rel="stylesheet" href="${ctxStatic}/editormd/css/editormd.css" />

	<script src="${ctxStatic}/editormd/lib/marked.min.js"></script>
	<script src="${ctxStatic}/editormd/lib/prettify.min.js"></script>
	<script src="${ctxStatic}/editormd/editormd.min.js"></script>

	<script type="text/javascript">
		var validateForm;
		var testEditor;
		var wordsView;
		//editor.md上传本地图片
        $(function() {
            testEditor=editormd("test-editormd", {
				width   : "90%",
				height  : 640,
				syncScrolling : "single",
				//你的lib目录的路径，我这边用JSP做测试的
				path    : "${ctxStatic}/editormd/lib/",
				//这个配置在simple.html中并没有，但是为了能够提交表单，使用这个配置可以让构造出来的HTML代码直接在第二个隐藏的textarea域中，方便post提交表单。
				imageUpload : true,
				imageFormats : ["jpg", "jpeg", "gif", "png", "bmp", "webp"],
				imageUploadURL : "${ctx}/sys/user/mdImageUpload",
				saveHTMLToTextarea : true
        	})
        });

		function doSubmit(){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
			if($.trim($("#title").val()) == ''){
				layer.alert("请输入主题",{icon:0});
				return false;
			}
            if($.trim($("#html").val()) == ''){
                layer.alert("请输入内容",{icon:0});
                return false;
            }
		  if(validateForm.form()){
			  $("#inputForm").submit();
			  return true;
		  }
	
		  return false;
		}
		$(document).ready(function() {
			validateForm = $("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
			
		});
		function addRow(list, idx, tpl, row){
			$(list).append(Mustache.render(tpl, {
				idx: idx, delBtn: true, row: row
			}));
			$(list+idx).find("select").each(function(){
				$(this).val($(this).attr("data-value"));
			});
			$(list+idx).find("input[type='checkbox'], input[type='radio']").each(function(){
				var ss = $(this).attr("data-value").split(',');
				for (var i=0; i<ss.length; i++){
					if($(this).val() == ss[i]){
						$(this).attr("checked","checked");
					}
				}
			});
		}
		function delRow(obj, prefix){
			var id = $(prefix+"_id");
			var delFlag = $(prefix+"_delFlag");
			if (id.val() == ""){
				$(obj).parent().parent().remove();
			}else if(delFlag.val() == "0"){
				delFlag.val("1");
				$(obj).html("&divide;").attr("title", "撤销删除");
				$(obj).parent().parent().addClass("error");
			}else if(delFlag.val() == "1"){
				delFlag.val("0");
				$(obj).html("&times;").attr("title", "删除");
				$(obj).parent().parent().removeClass("error");
			}
		}

	</script>
</head>
<body class="hideScroll">
	<form:form id="inputForm" modelAttribute="oaquestion" action="${ctx}/oaqa/oaquestion/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<input type="hidden" id="myquestion" name="myquestion" value="${myquestion}"/>
		<sys:message content="${message}"/>
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
		   <tbody>
			   <tr>
				   <td class="width-15 active"><label class="pull-right">*标题：</label></td>
				   <td class="width-35">
					   <form:input path="title" id="title" htmlEscape="false"    class="form-control " maxlength="20"/>
				   </td>
			   </tr>
				<%--<tr >
					<td class="width-15 active"><label class="pull-right"><font color="red">*</font>问：</label></td>
					<td class="width-35">
						<form:textarea path="question" htmlEscape="false"    class="form-control required editormd-html-textarea"/>
					</td>
				</tr>--%>

				<%--<c:if test="${oaquestion.id == null}">
                    <shiro:hasPermission name="oaqa:oaquestion:edit">
						<tr>
							<td class="width-15 active"><label class="pull-right">答：</label></td>
							<td class="width-35">
								<form:input path="var1" htmlEscape="false"    class="form-control "/>
							</td>
						</tr>
                	</shiro:hasPermission>
				</c:if>--%>

				<div class="editormd" id="test-editormd">
					<textarea class="editormd-markdown-textarea" name="test-editormd-markdown-doc" style="display: none;" id="editormd">${oaquestion.question}</textarea>

					<textarea class="editormd-html-textarea" name="html" id="html"></textarea>
				</div>
		 	</tbody>
		</table>
		

	</form:form>
</body>
</html>