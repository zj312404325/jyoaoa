<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>信息管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
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
		function add(){
			openDialog("新增合同信息","${ctx}/contractmanager/contractManager/form","950px", "80%","");
		}
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content">
	<div class="ibox">
	<div class="ibox-title">
		<h5>信息列表 </h5>
		<div class="ibox-tools">
			<a class="collapse-link">
				<i class="fa fa-chevron-up"></i>
			</a>
			<!-- <a class="dropdown-toggle" data-toggle="dropdown" href="#">
				<i class="fa fa-wrench"></i>
			</a>
			<ul class="dropdown-menu dropdown-user">
				<li><a href="#">选项1</a>
				</li>
				<li><a href="#">选项2</a>
				</li>
			</ul>
			<a class="close-link">
				<i class="fa fa-times"></i>
			</a> -->
		</div>
	</div>
    
    <div class="ibox-content">
	<sys:message content="${message}"/>
	
	<!--查询条件-->
	<div class="row">
	<div class="col-sm-12">
	<form:form id="searchForm" modelAttribute="contractManager" action="${ctx}/contractmanager/contractManager/" method="post" class="form-inline">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
		<div class="form-group">
			<span>合同名称：</span>
			<form:input path="contractname" htmlEscape="false" maxlength="30"    class="form-control "/>
			<span>合同类别：</span>
			<form:select path="contractclassid" class="form-control required">
				<form:option value="" label=""/>
				<form:options items="${fns:getDictList('contractmanager_contractclass')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
			</form:select>
			<span>合同对方：</span>
			<form:input path="contractparty" htmlEscape="false" maxlength="30"    class="form-control "/>
			<span>建立时间：</span>
			<input id="startdate" name="startdate" type="text" maxlength="20" class="laydate-icon form-control layer-date required"
				   value="<fmt:formatDate value="${contractManager.startdate}" pattern="yyyy-MM-dd"/>"/>
			<span>至</span>
			<input id="enddate" name="enddate" type="text" maxlength="20" class="laydate-icon form-control layer-date required"
				   value="<fmt:formatDate value="${contractManager.enddate}" pattern="yyyy-MM-dd"/>"/>
		 </div>	
	</form:form>
	<br/>
	</div>
	</div>
	
	<!-- 工具栏 -->
	<div class="row">
	<div class="col-sm-12">
		<div class="pull-left">
			<shiro:hasPermission name="contractmanager:contractManager:add">
				<button class="btn btn-white btn-sm" data-toggle="tooltip" data-placement="left" onclick="add()" title="添加"><i class="fa fa-plus"></i> 添加</button>
			</shiro:hasPermission>
			<shiro:hasPermission name="contractmanager:contractManager:edit">
			    <table:editRow url="${ctx}/contractmanager/contractManager/form" title="信息" id="contentTable"></table:editRow><!-- 编辑按钮 -->
			</shiro:hasPermission>
			<shiro:hasPermission name="contractmanager:contractManager:del">
				<table:delRow url="${ctx}/contractmanager/contractManager/deleteAll" id="contentTable"></table:delRow><!-- 删除按钮 -->
			</shiro:hasPermission>
			<shiro:hasPermission name="contractmanager:contractManager:import">
				<table:importExcel url="${ctx}/contractmanager/contractManager/import"></table:importExcel><!-- 导入按钮 -->
			</shiro:hasPermission>
			<shiro:hasPermission name="contractmanager:contractManager:export">
	       		<table:exportExcel url="${ctx}/contractmanager/contractManager/export"></table:exportExcel><!-- 导出按钮 -->
	       	</shiro:hasPermission>
	       <button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()" title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
		
			</div>
		<div class="pull-right">
			<button  class="btn btn-primary btn-rounded btn-outline btn-sm " onclick="search()" ><i class="fa fa-search"></i> 查询</button>
			<button  class="btn btn-primary btn-rounded btn-outline btn-sm " onclick="reset()" ><i class="fa fa-refresh"></i> 重置</button>
		</div>
	</div>
	</div>
	
	<!-- 表格 -->
	<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
		<thead>
			<tr>
				<th> <input type="checkbox" class="i-checks"></th>
				<th  class="sort-column contractname">合同名称</th>
				<th  class="sort-column contractclass">合同类别</th>
				<th  class="sort-column contractparty">合同对方</th>
				<th  class="sort-column contractamount">合同金额</th>
				<th  class="sort-column plancompletiondate">计划完成日期</th>
				<th  class="">已完成</th>
				<th  class="">比例</th>
				<th  class="">逾期(天)</th>
				<th  class="">合同状态</th>
				<th  class="">备注1</th>
				<th  class="">备注2</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="contractManager">
			<tr>
				<td> <input type="checkbox" id="${contractManager.id}" class="i-checks"></td>
				<td>
					<a href="#" onclick="openDialogView('查看信息', '${ctx}/contractmanager/contractManager/view?id=${contractManager.id}','950px', '720px')" class="" >${contractManager.contractname}</a>
				</td>
				<td>
					${contractManager.contractclass}
				</td>
				<td>
					${contractManager.contractparty}
				</td>
				<td>
					${contractManager.contractamount}(${contractManager.currency})
				</td>
				<td>
					<fmt:formatDate value="${contractManager.plancompletiondate}" pattern="yyyy-MM-dd"/>
				</td>
				<td>
						${contractManager.completed}
				</td>
				<td>
						${contractManager.completerate}
				</td>
				<td>
						${contractManager.overdue}
				</td>
				<td>
					${fns:getDictLabel(contractManager.status, 'contractmanager_contractstatus', '')}
				</td>
				<td>
					${contractManager.remark1}
				</td>
				<td>
					${contractManager.remark2}
				</td>
				<td>
					<shiro:hasPermission name="contractmanager:contractManager:view">
						<a href="#" onclick="openDialogView('查看信息', '${ctx}/contractmanager/contractManager/view?id=${contractManager.id}','950px', '80%')" class="btn btn-info btn-xs" ><i class="fa fa-search-plus"></i> 查看</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="contractmanager:contractManager:edit">
    					<a href="#" onclick="openDialog('修改信息', '${ctx}/contractmanager/contractManager/form?id=${contractManager.id}','950px', '80%')" class="btn btn-success btn-xs" ><i class="fa fa-edit"></i> 修改</a>
    				</shiro:hasPermission>
    				<shiro:hasPermission name="contractmanager:contractManager:del">
						<a href="${ctx}/contractmanager/contractManager/delete?id=${contractManager.id}" onclick="return confirmx('确认要删除该信息吗？', this.href)"   class="btn btn-danger btn-xs"><i class="fa fa-trash"></i> 删除</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="contractmanager:contractManager:edit">
						<a href="#" onclick="openDialog('授权信息', '${ctx}/contractmanager/contractManager/authorform?id=${contractManager.id}','950px', '50%')" class="btn btn-success btn-xs" ><i class="fa fa-edit"></i> 授权</a>
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
	</div>
</div>
</body>
</html>