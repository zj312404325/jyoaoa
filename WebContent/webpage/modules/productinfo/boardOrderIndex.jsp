<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>主板信息管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
		});
	</script>
</head>
<body class="gray-bg">

<div class="wrapper wrapper-content" style="height:100%">
	<div class="ibox" style="height:100%">
		<div class="ibox-title">
			<h5>主板生产信息列表 </h5>
		</div>
		<div class="ibox-content" style="height:100%">
			<sys:message content="${message}"/>
			<div class="tabs-container" id="keyContent" style="height:100%">
	        	<ul class="nav nav-tabs">
	                <%--<li class="<c:if test="${type!=null&&type=='0' }">active</c:if>"><a data-toggle="tab" href="#tab-1" aria-expanded="true">我发出的</a>
	                </li>
	                <li class="<c:if test="${type!=null&&type=='1' }">active</c:if>"><a data-toggle="tab" href="#tab-2" aria-expanded="false">我收到的</a>
	                </li>--%>
	            </ul>
	        	<div class="tab-content" style="height:100%">
	            	<div id="tab-1" class="tab-pane active" style="height:100%">
	                    <div class="panel-body" style="height:100%">
	                    	<iframe id="contentIframe1" src="${ctx }/checkmodel/productinfo/boardOrder/list?${repage}" style="width:100%;height:100%" frameborder="0"></iframe>
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