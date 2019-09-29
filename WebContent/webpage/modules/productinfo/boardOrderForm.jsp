<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>主板信息明细管理</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/common/contabs.js"></script>
	<script type="text/javascript">
		var validateForm;
		function doSubmit(){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
			if(validateForm.form()){
			  $("#inputForm").submit();
			  return true;
		  }
	
		  return false;
		}
		function doSubmit1(){//回调函数，下一步跳转。
			  if(validateForm.form()){
				  $("#inputForm").submit();
				  return true;
			  }
			  return false;
		}

        //图片上传回调函数
        function commonFileUploadCallBack(id,url,fname){
            $("#"+id).val(url);
            var htmlstr="";
            if(url!=''){
                htmlstr+='<li><a href="javascript:;" target="_blank" vl="'+url+'" onclick="commonFileDownLoad(this)"><span>'+fname+'</span></a> &nbsp; <a href="javascript:;" name="removeFile"><i class="glyphicon glyphicon-remove text-danger"></i></a></li>';
            }
            $("#filecontent").html(htmlstr);
        }

        function setReadOnly() {
            //$(".tbdisable input").attr("disabled","true");
            $(".tbdisable input").attr("readonly","readonly");
            $(".tbdisable textarea").attr("disabled","true");
            $(".tbdisable button").attr("disabled","true");
            $(".tbdisable select").attr("disabled","true");
            $(".tbdisable a[name=removeFile]").remove();
        }

		$(document).ready(function() {
            laydate({
                elem: '#expectDate', //目标元素。由于laydate.js封装了一个轻量级的选择器引擎，因此elem还允许你传入class、tag但必须按照这种方式 '#id .class'
                event: 'focus' //响应事件。如果没有传入event，则按照默认的click
            });
            laydate({
                elem: '#realDate', //目标元素。由于laydate.js封装了一个轻量级的选择器引擎，因此elem还允许你传入class、tag但必须按照这种方式 '#id .class'
                event: 'focus' //响应事件。如果没有传入event，则按照默认的click
            });

            if('${bhv}'=='1'){
                setReadOnly();
            }

            $("#uploadF").click(function () {
                var id=$(this).attr("vl");
                commonFileUpload(id);
            });

            $("#filecontent").delegate("a[name=removeFile]","click",function () {
                $("#filecontent").html("");
                $("#fileurl").val("");
            })

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
				cv("number",obj);
			}else if(delFlag.val() == "0"){
				delFlag.val("1");
				$(obj).html("&divide;").attr("title", "撤销删除");
				$(obj).parent().parent().addClass("error");
				var delPoint = $(obj).closest("tr").find("input.number").val();
				$("#selfscore").val(Number($("#selfscore").val() - delPoint));
			}else if(delFlag.val() == "1"){
				delFlag.val("0");
				$(obj).html("&times;").attr("title", "删除");
				$(obj).parent().parent().removeClass("error");
				var delPoint = $(obj).closest("tr").find("input.number").val();
				$("#selfscore").val(Number($("#selfscore").val()) + Number(delPoint));
			}
			
		}
		function cv(type,obj){
			compare(obj);
			var valueArr= $(".tabs-container").find("tr").not(".error").find("input."+type);
			var sumValue=0;  
			   if(valueArr.size()>0||valueArr != null){  
			       for (var i=0;i<valueArr.size();i++ )  
			        {      
			            //alert(valueArr[i].value);  
			            if(isNaN(valueArr[i].value)||valueArr[i].value==null||valueArr[i].value==""){  
			               sumValue +=0;  
			            }  
			            else{  
			               //alert(valueArr[i].value);  
			               sumValue +=parseFloat(valueArr[i].value);
			               
			            }  
			              
			        } 

			   }  
			   if(type=="number"){
				   
				   if(sumValue>0){  
				        $('#selfscore').val(parseInt(sumValue));  
				   }  
				   else{  
				       $('#selfscore').val(0);  
				   }  
			   }
		}
		
		
		function compare(obj1){
			var num1 = $(obj1).closest("tr").find("input.number").val();
            var reg = /^[1-9]\d*\.[5]$|0\.[5]$|^[1-9]\d*$/;

            if('' != num1.replace(reg,'')){
                num1 = num1.match(reg) == null  ?  '' : num1.match(reg);
            }

            if (num1 === '') {
                top.layer.alert("天数必须是0.5的整数倍！",{icon:2});
            }
		}
		
		
	</script>
</head>
<body class="hideScroll">
	<shiro:hasPermission name="checkmodel:boardOrder:import">
		<table:importExcel url="${ctx}/checkmodel/productinfo/boardOrder/import?id=${boardOrder.id}&template=主板明细模板.xlsx"></table:importExcel><!-- 导入按钮 -->
	</shiro:hasPermission>
	<form:form id="inputForm" modelAttribute="boardOrder" action="${ctx}/checkmodel/productinfo/boardOrder/save" method="post" class="form-horizontal">
		<input type="hidden" name="type" value="${type }" />
		<form:hidden path="id"/>
		<%--<form:hidden path="category"/>--%>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer tbdisable">
		   <tbody>

			   <%--第一行--%>
			   <tr>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red">*</font>生产工单：</label>
				   </td>
				   <td class="width-35">
					   <form:input path="orderNo" htmlEscape="false"    class="form-control required"/>
				   </td>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red">*</font>数量：</label>
				   </td>
				   <td class="width-35">
					   <form:input path="quantity" htmlEscape="false"  onkeyup='clearNoNum(this)'  class="form-control number"/>
				   </td>
			   </tr>

			   <%--第二行--%>
			   <tr>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red"></font>预计上线日期：</label>
				   </td>
				   <td class="width-35">
					   <%--<form:input path="expectDate" htmlEscape="false"    class="form-control "/>--%>
					   <input id="expectDate" name="expectDate" type="text" maxlength="20" class="laydate-icon form-control layer-date"
							  value="<fmt:formatDate value="${boardOrder.expectDate}" pattern="yyyy-MM-dd"/>"/>
				   </td>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red"></font>实际上线日期：</label>
				   </td>
				   <td class="width-35">
					   <%--<form:input path="realDate" htmlEscape="false"    class="form-control "/>--%>
					   <input id="realDate" name="realDate" type="text" maxlength="20" class="laydate-icon form-control layer-date"
							  value="<fmt:formatDate value="${boardOrder.realDate}" pattern="yyyy-MM-dd"/>"/>
				   </td>
			   </tr>

			   <%--第三行--%>
			   <tr>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red"></font>备注修改：</label>
				   </td>
				   <td class="width-35">
					   <form:input path="remarks" htmlEscape="false"    class="form-control "/>
				   </td>
			   </tr>

			   <%--第4行--%>
			   <tr>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red">*</font>固件版本：</label>
				   </td>
				   <td class="width-35">
					   <form:input path="firmware" htmlEscape="false"    class="form-control required"/>
				   </td>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red">*</font>产品名称：</label>
				   </td>
				   <td class="width-35">
					   <form:input path="productName" htmlEscape="false"    class="form-control required"/>
				   </td>
			   </tr>

			   <%--第5行--%>
			   <tr>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red">*</font>BOM版本：</label>
				   </td>
				   <td class="width-35">
					   <form:input path="bom" htmlEscape="false"    class="form-control required"/>
				   </td>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red">*</font>PCB名称：</label>
				   </td>
				   <td class="width-35">
					   <form:input path="pcb" htmlEscape="false"    class="form-control required"/>
				   </td>
			   </tr>

			   <tr>
				   <td class="width-15 active"><label class="pull-right text-danger">说明：</label></td>
				   <td colspan="3" class="text-danger">请在下方区域填写主板明细信息。</td>
			   </tr>

		 	</tbody>
		</table>

		<!--主板明细 start-->
		<div class="tabs-container">
			<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-2" aria-expanded="true">主板明细</a>
				</li>
			</ul>
				<div class="panel-body active">
			<a class="btn btn-white btn-sm" onclick="addRow('#boardOrderDetailList', boardOrderDetailRowIdx, boardOrderDetailTpl);boardOrderDetailRowIdx = boardOrderDetailRowIdx + 1;" title="新增"><i class="fa fa-plus"></i> 新增</a>

			<table id="contentTable2" class="table table-striped table-bordered table-condensed dataTable tbdisable">
				<thead>
					<tr>
						<th class="hide"></th>
						<th width="100">主板条码记录</th>
						<th width="60">Lable1</th>
						<th width="60">Lable2</th>
						<th width="60">Lable3</th>
						<th width="60">Lable4</th>
						<th width="60">Lable5</th>
						<th width="60">Lable6</th>
						<th width="10">&nbsp;</th>
					</tr>
				</thead>
				<tbody id="boardOrderDetailList">
				</tbody>
			</table>
			<script type="text/template" id="boardOrderDetailTpl">//<!--
				<tr id="boardOrderDetailList{{idx}}">
					<td class="hide">
						<input id="boardOrderDetailList{{idx}}_id" name="boardOrderDetailList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
						<input id="boardOrderDetailList{{idx}}_delFlag" name="boardOrderDetailList[{{idx}}].delFlag" type="hidden" value="0"/>
						<input id="boardOrderDetailList{{idx}}_type" name="boardOrderDetailList[{{idx}}].type" type="hidden" value="0"/>
					</td>

					<td width="100">
						<input id="boardOrderDetailList{{idx}}_boardRecord" name="boardOrderDetailList[{{idx}}].boardRecord" type="text" value="{{row.boardRecord}}"    class="form-control required" maxlength=50/>
					</td>

					<td width="60">
						<input id="boardOrderDetailList{{idx}}_lable1" name="boardOrderDetailList[{{idx}}].lable1" type="text" value="{{row.lable1}}"    class="form-control " maxlength=50 onmouseover="this.title=this.value"/>
					</td>


					<td width="60">
						<input id="boardOrderDetailList{{idx}}_lable2" name="boardOrderDetailList[{{idx}}].lable2" type="text" value="{{row.lable2}}"    class="form-control " maxlength=50 onmouseover="this.title=this.value"/>
					</td>


					<td width="60">
						<input id="boardOrderDetailList{{idx}}_lable3" name="boardOrderDetailList[{{idx}}].lable3" type="text" value="{{row.lable3}}"    class="form-control " maxlength=50 onmouseover="this.title=this.value"/>
					</td>

					<td width="60">
						<input id="boardOrderDetailList{{idx}}_lable4" name="boardOrderDetailList[{{idx}}].lable4" type="text" value="{{row.lable4}}"    class="form-control " maxlength=50 onmouseover="this.title=this.value"/>
					</td>

					<td width="60">
						<input id="boardOrderDetailList{{idx}}_lable5" name="boardOrderDetailList[{{idx}}].lable5" type="text" value="{{row.lable5}}"    class="form-control " maxlength=50 onmouseover="this.title=this.value"/>
					</td>

					<td width="60">
						<input id="boardOrderDetailList{{idx}}_lable6" name="boardOrderDetailList[{{idx}}].lable6" type="text" value="{{row.lable6}}"    class="form-control " maxlength=50 onmouseover="this.title=this.value"/>
					</td>
					<td class="text-center" width="10">
						{{#delBtn}}<span class="close" onclick="delRow(this, '#boardOrderDetailList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
					</td>
				</tr>//-->
			</script>
			<script type="text/javascript">
				var boardOrderDetailRowIdx = 0,boardOrderDetailRowIdx = 0, boardOrderDetailTpl = $("#boardOrderDetailTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
				$(document).ready(function() {
					var data = ${fns:toJson(boardOrder.boardOrderDetailList)};
					for (var i=0; i<data.length; i++){
						addRow('#boardOrderDetailList', boardOrderDetailRowIdx, boardOrderDetailTpl, data[i]);
						boardOrderDetailRowIdx = boardOrderDetailRowIdx + 1;
					}

                    if('${bhv}'=='1'){
                        setReadOnly();
                        $("a[title='新增']").remove();
                        $("span.close").remove();
                    }
				});
			</script>
		</div>
		</div>
		<!--主板明细 End-->
	</form:form>
</body>
</html>