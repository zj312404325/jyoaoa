<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>发货信息管理</title>
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
	<form:form id="searchForm" modelAttribute="logisticOrder" action="${ctx}/checkmodel/productinfo/logisticOrder/list?cat=depart" method="post" class="form-inline">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
        <%--<form:hidden path="category"/>--%>
		<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
		<div class="form-group">
			<span>收货单位：</span>
			<form:input path="receiveComp" class="form-control"/>
			<span>开始时间：</span>
			<input id="startdate" name="startdate" type="text" maxlength="20" class="laydate-icon form-control layer-date required"
							value="<fmt:formatDate value="${logisticOrder.startdate}" pattern="yyyy-MM-dd"/>"/>
			<span>结束时间：</span>
			<input id="enddate" name="enddate" type="text" maxlength="20" class="laydate-icon form-control layer-date required"
							value="<fmt:formatDate value="${logisticOrder.enddate}" pattern="yyyy-MM-dd"/>"/>

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
			<div class="pull-left" <c:if test="${isSearch!=null&&isSearch=='0' }">hidden</c:if>>
				<shiro:hasPermission name="checkmodel:logisticOrder:add">
					<table:addRowJump url="${ctx}/checkmodel/productinfo/logisticOrder/form?type=0&opt=add" width="80%" title="主板信息"></table:addRowJump><!-- 增加按钮 -->
				</shiro:hasPermission>
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
				<th class="sort-column orderNo">物流单号</th>
				<th class="sort-column quantity">发货数量</th>
				<th class="sort-column receiveComp">收货单位</th>
				<th class="sort-column receiveAddress">收货地址</th>
				<th class="sort-column receiveMobile">收货电话</th>
				<th class="sort-column receivePerson">收货人</th>

				<th class="sort-column sendComp">发货单位</th>
				<th class="sort-column sendAddress">发货地址</th>
				<th class="sort-column sendMobile">发货电话</th>
				<th class="sort-column sendPerson">发货人</th>

				<th class="sort-column transComp">承运单位</th>
				<th class="sort-column transMobile">承运电话</th>
				<th class="sort-column transPerson">承运人</th>
				<th class="sort-column a.create_date">创建日期</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="logisticOrder">
			<tr>
				<td>
                    <input type="checkbox" id="${logisticOrder.id}" class="">
                </td>
				<td>
					${logisticOrder.orderNo}
				</td>
				<td>
					${logisticOrder.quantity}
				</td>
				<td>
					${logisticOrder.receiveComp}
				</td>
				<td>
					${logisticOrder.receiveAddress}
				</td>
				<td>
					${logisticOrder.receiveMobile}
				</td>
				<td>
					${logisticOrder.receivePerson}
				</td>

				<td>
					${logisticOrder.sendComp}
				</td>
				<td>
					${logisticOrder.sendAddress}
				</td>
				<td>
					${logisticOrder.sendMobile}
				</td>
				<td>
					${logisticOrder.sendPerson}
				</td>

				<td>
					${logisticOrder.transComp}
				</td>
				<td>
					${logisticOrder.transMobile}
				</td>
				<td>
					${logisticOrder.transPerson}
				</td>
				<td>
					<fmt:formatDate value="${logisticOrder.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
				</td>

				<td>
					<shiro:hasPermission name="checkmodel:logisticOrder:view">
						<a href="#" onclick="openDialogView('查看发货明细', '${ctx}/checkmodel/productinfo/logisticOrder/form?id=${logisticOrder.id}&type=1&bhv=1&codeNo=${codeNo}','1200px', '500px')" class="btn btn-info btn-xs" ><i class="fa fa-search-plus"></i> 查看</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="checkmodel:machineOrder:edit">
						<a href="#" onclick="openDialog('修改发货明细', '${ctx}/checkmodel/productinfo/logisticOrder/form?id=${logisticOrder.id}&type=0','1200px', '500px')" class="btn btn-success btn-xs" ><i class="fa fa-edit"></i> 修改</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="checkmodel:machineOrder:del">
						<a href="${ctx}/checkmodel/productinfo/logisticOrder/delete?id=${logisticOrder.id}&type=0" onclick="return confirmxParent('确认要删除该发货信息吗？', this.href)"   class="btn btn-danger btn-xs"><i class="fa fa-trash"></i> 删除</a>
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