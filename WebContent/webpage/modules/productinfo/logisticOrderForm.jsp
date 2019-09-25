<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>发货信息明细管理</title>
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
	<shiro:hasPermission name="checkmodel:logisticOrder:import">
		<table:importExcel url="${ctx}/checkmodel/productinfo/logisticOrder/import?id=${logisticOrder.id}&template=logistic.xlsx"></table:importExcel><!-- 导入按钮 -->
	</shiro:hasPermission>
	<form:form id="inputForm" modelAttribute="logisticOrder" action="${ctx}/checkmodel/productinfo/logisticOrder/save" method="post" class="form-horizontal">
		<input type="hidden" name="type" value="${type }" />
		<form:hidden path="id"/>
		<%--<form:hidden path="category"/>--%>
		<sys:message content="${message}"/>	
		<table class="table table-bordered  table-condensed dataTables-example dataTable no-footer tbdisable">
		   <tbody>

			   <%--第一行--%>
			   <tr>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red">*</font>物流单号：</label>
				   </td>
				   <td class="width-35">
					   <form:input path="orderNo" htmlEscape="false"    class="form-control required"/>
				   </td>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red">*</font>发货数量：</label>
				   </td>
				   <td class="width-35">
					   <form:input path="quantity" htmlEscape="false"   onkeyup='clearNoNum(this)'  class="form-control required number"/>
				   </td>
			   </tr>

			   <%--第二行--%>
			   <tr>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red">*</font>收货单位：</label>
				   </td>
				   <td class="width-35">
					   <form:input path="receiveComp" htmlEscape="false"    class="form-control required"/>
				   </td>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red">*</font>收货地址：</label>
				   </td>
				   <td class="width-35">
					   <form:input path="receiveAddress" htmlEscape="false"    class="form-control required"/>
				   </td>
			   </tr>

			   <%--第三行--%>
			   <tr>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red">*</font>收货电话：</label>
				   </td>
				   <td class="width-35">
					   <form:input path="receiveMobile" htmlEscape="false"    class="form-control required"/>
				   </td>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red">*</font>收货人：</label>
				   </td>
				   <td class="width-35">
					   <form:input path="receivePerson" htmlEscape="false"    class="form-control required"/>
				   </td>
			   </tr>

			   <%--第4行--%>
			   <tr>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red">*</font>发货单位：</label>
				   </td>
				   <td class="width-35">
					   <form:input path="sendComp" htmlEscape="false"    class="form-control required"/>
				   </td>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red">*</font>发货地址：</label>
				   </td>
				   <td class="width-35">
					   <form:input path="sendAddress" htmlEscape="false"    class="form-control required"/>
				   </td>
			   </tr>

			   <%--第5行--%>
			   <tr>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red">*</font>发货电话：</label>
				   </td>
				   <td class="width-35">
					   <form:input path="sendMobile" htmlEscape="false"    class="form-control required"/>
				   </td>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red">*</font>发货人：</label>
				   </td>
				   <td class="width-35">
					   <form:input path="sendPerson" htmlEscape="false"    class="form-control required"/>
				   </td>
			   </tr>

			   <%--第6行--%>
			   <tr>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red">*</font>承运单位：</label>
				   </td>
				   <td class="width-35">
					   <form:input path="transComp" htmlEscape="false"    class="form-control required"/>
				   </td>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red">*</font>承运电话：</label>
				   </td>
				   <td class="width-35">
					   <form:input path="transMobile" htmlEscape="false"    class="form-control required"/>
				   </td>
			   </tr>

			   <%--第7行--%>
			   <tr>
				   <td class="width-15 active">
					   <label class="pull-right"><font color="red">*</font>承运人：</label>
				   </td>
				   <td class="width-35">
					   <form:input path="transPerson" htmlEscape="false"    class="form-control required"/>
				   </td>
			   </tr>

			   <tr>
				   <td class="width-15 active"><label class="pull-right text-danger">说明：</label></td>
				   <td colspan="3" class="text-danger">请在下方区域填写发货单明细信息。</td>
			   </tr>

		 	</tbody>
		</table>

		<!--发货单明细 start-->
		<div class="tabs-container">
			<ul class="nav nav-tabs">
				<li class="active"><a data-toggle="tab" href="#tab-2" aria-expanded="true">主板明细</a>
				</li>
			</ul>
				<div class="panel-body active">
			<a class="btn btn-white btn-sm" onclick="addRow('#logisticOrderDetailList', logisticOrderDetailRowIdx, logisticOrderDetailTpl);logisticOrderDetailRowIdx = logisticOrderDetailRowIdx + 1;" title="新增"><i class="fa fa-plus"></i> 新增</a>
			<table id="contentTable2" class="table table-striped table-bordered table-condensed dataTable tbdisable">
				<thead>
					<tr>
						<th class="hide"></th>
						<th width="100">产品条码记录</th>
						<th width="10">&nbsp;</th>
					</tr>
				</thead>
				<tbody id="logisticOrderDetailList">
				</tbody>
			</table>
			<script type="text/template" id="logisticOrderDetailTpl">//<!--
				<tr id="logisticOrderDetailList{{idx}}">
					<td class="hide">
						<input id="logisticOrderDetailList{{idx}}_id" name="logisticOrderDetailList[{{idx}}].id" type="hidden" value="{{row.id}}"/>
						<input id="logisticOrderDetailList{{idx}}_delFlag" name="logisticOrderDetailList[{{idx}}].delFlag" type="hidden" value="0"/>
						<input id="logisticOrderDetailList{{idx}}_type" name="logisticOrderDetailList[{{idx}}].type" type="hidden" value="0"/>
					</td>

					<td width="100">
						<input id="logisticOrderDetailList{{idx}}_prodRecord" name="logisticOrderDetailList[{{idx}}].prodRecord" type="text" value="{{row.prodRecord}}"    class="form-control required" maxlength=50/>
					</td>

					<td class="text-center" width="10">
						{{#delBtn}}<span class="close" onclick="delRow(this, '#logisticOrderDetailList{{idx}}')" title="删除">&times;</span>{{/delBtn}}
					</td>
				</tr>//-->
			</script>
			<script type="text/javascript">
				var logisticOrderDetailRowIdx = 0,logisticOrderDetailRowIdx = 0, logisticOrderDetailTpl = $("#logisticOrderDetailTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
				$(document).ready(function() {
					var data = ${fns:toJson(logisticOrder.logisticOrderDetailList)};
					for (var i=0; i<data.length; i++){
						addRow('#logisticOrderDetailList', logisticOrderDetailRowIdx, logisticOrderDetailTpl, data[i]);
						logisticOrderDetailRowIdx = logisticOrderDetailRowIdx + 1;
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
		<!--发货单明细 End-->
	</form:form>
</body>
</html>