<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>主板信息管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
        function reset1(){//重置，页码清零
            $("#pageNo").val(0);
            $("#searchForm div.form-group input").val("");
            $("#searchForm div.form-group select").val("");
            $("#searchForm div input.form-control").val("");
            $("#searchForm").submit();
            return false;
        }
		$(document).ready(function() {
			laydate({
	            elem: '#startdate', //目标元素。由于laydate.js封装了一个轻量级的选择器引擎，因此elem还允许你传入class、tag但必须按照这种方式 '#id .class'
	            event: 'focus' //响应事件。如果没有传入event，则按照默认的click
	        });
			laydate({
	            elem: '#enddate', //目标元素。由于laydate.js封装了一个轻量级的选择器引擎，因此elem还允许你传入class、tag但必须按照这种方式 '#id .class'
	            event: 'focus' //响应事件。如果没有传入event，则按照默认的click
	        });
		});
	</script>
</head>
<body class="hideScroll">
	<div class="">
	<sys:message content="${message}"/>
	<div class="row">
		<div class="col-sm-12" <c:if test="${isSearch!=null&&isSearch=='0' }">hidden</c:if>>
	<!--查询条件-->
	<form:form id="searchForm" modelAttribute="boardOrder" action="${ctx}/checkmodel/productinfo/boardOrder/list?cat=depart" method="post" class="form-inline" >
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <%--<form:hidden path="category"/>--%>
		<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
		<div class="form-group">
            <span>固件版本：</span>
            <form:input path="firmware" class="form-control"/>

            <span>产品名称：</span>
            <form:input path="productName" class="form-control"/>

            <span>BOM版本：</span>
            <form:input path="bom" class="form-control"/>

            <span>PCB版本：</span>
            <form:input path="pcb" class="form-control"/>

			<span>开始时间：</span>
			<input id="startdate" name="startdate" type="text" maxlength="20" class="laydate-icon form-control layer-date required"
							value="<fmt:formatDate value="${boardOrder.startdate}" pattern="yyyy-MM-dd"/>"/>
			<span>结束时间：</span>
			<input id="enddate" name="enddate" type="text" maxlength="20" class="laydate-icon form-control layer-date required"
							value="<fmt:formatDate value="${boardOrder.enddate}" pattern="yyyy-MM-dd"/>"/>

				<div class="pull-right" style="padding-left: 20px">
					<button  class="btn btn-primary btn-rounded btn-outline btn-sm " onclick="search()" ><i class="fa fa-search"></i> 查询</button>
					<button  class="btn btn-primary btn-rounded btn-outline btn-sm " onclick="reset1()" ><i class="fa fa-refresh"></i> 重置</button>
				</div>
		 </div>	
	</form:form>
	</div>
	</div>
	<!-- 工具栏 -->
	<div class="row">
	<div class="col-sm-12">
		<div class="pull-left">
			<div class="pull-left " <c:if test="${isSearch!=null&&isSearch=='0' }">hidden</c:if>>
				<table:addRowJump url="${ctx}/checkmodel/productinfo/boardOrder/form?type=0&opt=add" width="80%" title="主板信息"></table:addRowJump><!-- 增加按钮 -->
				<button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
			</div>

		</div>

	</div>
	</div>
	
	<!-- 表格 -->
	<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
		<thead>
			<tr>
				<th> <input type="checkbox" class=""></th>
				<th class="sort-column orderno">工单号</th>
				<th class="sort-column quantity">生产数量</th>
				<th class="sort-column firmware">固件版本</th>
				<th class="sort-column product_name">产品名称</th>
				<th class="sort-column bom">BOM版本</th>
				<th class="sort-column pcb">PCB版本</th>
				<th class="sort-column a.expect_date">预计上线时间</th>
				<th class="sort-column a.real_date">实际上线时间</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="boardOrder">
			<tr>
				<td>
                    <input type="checkbox" id="${boardOrder.id}" class="">
                </td>
				<td>
					${boardOrder.orderNo}
				</td>
				<td>
					${boardOrder.quantity}
				</td>
				<td>
					${boardOrder.firmware}
				</a></td>
				<td>
					${boardOrder.productName}
				</td>
				<td>
					${boardOrder.bom}
				</td>
				<td>
					${boardOrder.pcb}
				</td>
				<td>
					<fmt:formatDate value="${boardOrder.expectDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					<fmt:formatDate value="${boardOrder.realDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>
				<td>
					<shiro:hasPermission name="checkmodel:boardOrder:view">
						<a href="#" onclick="openDialogView('查看主板明细', '${ctx}/checkmodel/productinfo/boardOrder/form?id=${boardOrder.id}&type=1&bhv=1','1200px', '500px')" class="btn btn-info btn-xs" ><i class="fa fa-search-plus"></i> 查看</a>
					</shiro:hasPermission>
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	
		<!-- 分页代码 -->
	<table:page page="${page}"></table:page>
	<br/>
	<br/>

</div>
</body>
</html>