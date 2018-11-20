<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>周报导出预览</title>
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
	<div class="panel-body">
	<sys:message content="${message}"/>

	<!--查询条件-->
	<form:form class="form-inline">
		<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/><!-- 支持排序 -->
		<div class="form-group">
			<span>开始时间：</span>
			<input id="startdate" name="startdate" disabled="disabled" type="text" maxlength="20" class="laydate-icon form-control layer-date required"
				   value="<fmt:formatDate value="${weeklyReport.startdate}" pattern="yyyy-MM-dd"/>"/>
			<span>结束时间：</span>
			<input id="enddate" name="enddate" disabled="disabled" type="text" maxlength="20" class="laydate-icon form-control layer-date required"
				   value="<fmt:formatDate value="${weeklyReport.enddate}" pattern="yyyy-MM-dd"/>"/>

			<span>总计人数：</span>
			<input id="count" name="count" disabled="disabled" type="text" value="${count}"/>
		</div>
	</form:form>
	
	<!-- 表格 -->
	<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
		<thead>
			<tr>
				<th width="5">姓名</th>
				<th width="5">项目</th>
				<th width="10">任务类型</th>
				<th width="160">任务描述</th>
				<th width="160">内容</th>
				<th width="10">任务状态</th>
				<th width="5">花费时间(天)</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${weeklyReportDetail}" var="weeklyReportDetail">
			<tr>
				<td width="5">
					${weeklyReportDetail.excelusername}
				</td>
				<td width="5">
					${weeklyReportDetail.project}
				</td>
				<td width="10">
					${weeklyReportDetail.tasktype}
				</td>
				<td width="160">
					${weeklyReportDetail.taskdesc}
				</td>
				<td width="160">
					${weeklyReportDetail.content}
				</td>
				<td width="10">
					${weeklyReportDetail.taskstatus}
				</td>
				<td width="5">
					${weeklyReportDetail.days}
				</td>

			</tr>
		</c:forEach>
		</tbody>
	</table>
	
		<!-- 分页代码 -->
	<%--<table:page page="${page}"></table:page>--%>
	<br/>
	<br/>

</div>
</body>
</html>