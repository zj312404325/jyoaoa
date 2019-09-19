<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>产品信息查询</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
        var codeNo;
        function searchProduct(){//重置，页码清零
            var typeValue=${type};
            var url;
            codeNo=$("#codeNo").val();
            console.log(typeValue);
            if(typeValue!=null&&typeValue=='0'){
                url="${ctx}/checkmodel/productinfo/boardOrder/list?${repage}&codeNo="+codeNo;
                $("#contentIframe1").attr('src', url);

			}
			else if(typeValue!=null&&typeValue=='1'){
                url="${ctx}/checkmodel/productinfo/machineOrder/list?${repage}&codeNo="+codeNo;
                $("#contentIframe2").attr('src', url);
			}
            else if(typeValue!=null&&typeValue=='2'){
                url="${ctx}/checkmodel/productinfo/logisticOrder/list?${repage}&codeNo="+codeNo;
                $("#contentIframe3").attr('src', url);
            }

            $("#productInfo-content").show();
            return false;
        }

		$(document).ready(function() {
            codeNo=$("#codeNo").val();
		});
	</script>
</head>
<body class="gray-bg">

<div class="wrapper wrapper-content" style="height:100%">
	<div class="ibox" style="height:100%">
		<div class="ibox-title">
			<h5>产品信息查询</h5>
		</div>

		<div class="ibox-content" style="height:100%">
			<sys:message content="${message}"/>

			<!--查询条件-->
			<div class="row">
				<div class="col-sm-12">
					<form:form id="searchForm" class="form-inline">
						<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
						<div class="form-group">
							<span>SN号：</span>
							<input id="codeNo" name="codeNo" type="text" maxlength="20" class="form-control"/>
						</div>
					</form:form>
					<br/>
				</div>
			</div>

			<!-- 工具栏 -->
			<div class="row">
				<div class="col-sm-12">
					<div class="pull-left">
						<button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
					</div>
					<div class="pull-right">
						<button  class="btn btn-primary btn-rounded btn-outline btn-sm " onclick="searchProduct()" ><i class="fa fa-search"></i> 查询</button>
						<button  class="btn btn-primary btn-rounded btn-outline btn-sm " onclick="reset()" ><i class="fa fa-refresh"></i> 重置</button>
					</div>
				</div>
			</div>

			<div class="tabs-container" id="keyContent" style="height:100%">
	        	<ul class="nav nav-tabs">
					<li class="<c:if test="${type!=null&&type=='0' }">active</c:if>"><a data-toggle="tab" href="#tab-1" aria-expanded="true">主板信息</a>
					</li>
					<li class="<c:if test="${type!=null&&type=='1' }">active</c:if>"><a data-toggle="tab" href="#tab-2" aria-expanded="false">整机信息</a>
					</li>
					<li class="<c:if test="${type!=null&&type=='2' }">active</c:if>"><a data-toggle="tab" href="#tab-3" aria-expanded="false">发货信息</a>
					</li>
	            </ul>
	        	<div id="productInfo-content" class="tab-content" style="height:100%;display: none">
					<div id="tab-1" class="tab-pane <c:if test="${type!=null&&type=='0' }">active</c:if>" style="height:100%">
						<div class="panel-body" style="height:100%">
							<iframe id="contentIframe1" src="${ctx }/checkmodel/productinfo/boardOrder/list?${repage}" style="width:100%;height:100%" frameborder="0"></iframe>
						</div>
					</div>
					<div id="tab-2" class="tab-pane <c:if test="${type!=null&&type=='1' }">active</c:if>" style="height:100%">
						<div class="panel-body" style="height:100%">
							<iframe id="contentIframe2" src="${ctx }/checkmodel/productinfo/machineOrder/list?${repage}&codeNo=${codeNo}" style="width:100%;height:100%" frameborder="0"></iframe>
						</div>
					</div>
					<div id="tab-3" class="tab-pane <c:if test="${type!=null&&type=='2' }">active</c:if>" style="height:100%">
						<div class="panel-body" style="height:100%">
							<iframe id="contentIframe3" src="${ctx }/checkmodel/productinfo/logisticOrder/list?${repage}&codeNo=${codeNo}" style="width:100%;height:100%" frameborder="0"></iframe>
						</div>
					</div>
	           	</div>
	            	
	    	</div>
		</div>
	</div>
</div>

<script>
$(function(){

})

</script>
</body>
</html>