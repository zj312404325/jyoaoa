<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>信息管理</title>
	<meta name="decorator" content="default"/>
	<script src="${ctxStatic}/common/contabs.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
		    $("#search").click(function(){
		        $("#searchForm").submit();
			});
		});

	</script>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content">
	<div class="ibox">
    
    <div class="ibox-content">
	<sys:message content="${message}"/>
		<form:form id="searchForm" modelAttribute="oaquestion" action="${ctx}/oaqa/oaquestion/list" method="post" class="form-inline">
			<div class="form-group">
				<label style="padding-right: 12px;"><h2><i style="top:10px; color:#1ab394;" class="glyphicon glyphicon-question-sign"></i></h2></label>
				<form:input path="var1" htmlEscape="false" maxlength="50" class=" form-control" style="border-color:#1ab394; width: 480px;" />
				<button type="button" id="search" class="btn btn-primary"><i class="glyphicon glyphicon-search"></i> 搜索</button>
				<shiro:hasPermission name="oaqa:oaquestion:add">
					<a href="javascript:" onclick="add()" class="btn btn-white"><i class="glyphicon glyphicon-plus"></i> 我要创建</a>
				</shiro:hasPermission>
			</div>

            <input id="hasanswer" name="hasanswer" type="hidden" value="${oaquestion.hasanswer}"/>
			<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
			<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
			<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/>
		</form:form>
        <c:if test="${oaquestion.hasanswer == null || oaquestion.hasanswer == ''}">
		<p style="padding-top: 12px;">以下共搜索出${page.count}条相关<b class="text-success">${oaquestion.var1}</b>的问答</p>
        </c:if>
        <c:if test="${oaquestion.hasanswer == 'yes'}">
			<p style="padding-top: 12px;">以下共搜索出${page.count}条相关<b class="text-success">${oaquestion.var1}</b>的<b class="text-info">已有答案的问题</b></p>
        </c:if>
        <c:if test="${oaquestion.hasanswer == 'no'}">
			<p style="padding-top: 12px;">以下共搜索出${page.count}条相关<b class="text-success">${oaquestion.var1}</b>的<b class="text-info">等待回答的问题</b></p>
        </c:if>
		<hr />
	
	<!-- 表格 -->
		<div class="row">
			<div class="col-sm-12">
				<ul class="list-group">
					<c:forEach items="${page.list}" var="oaquestion">
						<li class="list-group-item">
							<div>
								<div style="float:left;width:60px;padding:5px" >
									<span title="回复"><h4>${fn:length(oaquestion.oaanswerList)}</h4></span>
								</div>
								<div style="float:left;padding:5px">
									<a class="frameItem text-info" href="javascript:" vl="${ctx}/oaqa/oaquestion/detail?id=${oaquestion.id}" vl2="${oaquestion.title}" data-index="566">
										<%--<c:if test="${oaquestion.createBy.id == loginUser.id}">
											<b class="qa_del_btn1" onclick="delThis(this,0,'${oaquestion.id}')">&times;</b>
										</c:if>--%>
										<h3>${oaquestion.title}</h3>
									</a>
								</div>
								<div style="float:right;padding:5px">
									<div style="float:left">
										<c:if test="${myquestion == 'yes'}">
											<c:if test="${oaquestion.createBy.id == loginUser.id}">
												<a href="#" onclick="openDialog('修改信息', '${ctx}/oaqa/oaquestion/form?id=${oaquestion.id}&myquestion=yes','800px', '500px')" class="btn btn-success btn-xs" ><i class="fa fa-edit"></i> 修改</a>
											</c:if>
										</c:if>
									</div>
									&nbsp;&nbsp;&nbsp;
									<div style="float:right">
										<span title="主题作者:${fns:getUserById(oaquestion.createBy.id).name}">主题作者:${fns:getUserById(oaquestion.createBy.id).name}</span>
										<br/>
										<fmt:formatDate value="${oaquestion.createDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
									</div>
								</div>
							</div>
							<%--<c:forEach items="${oaquestion.oaanswerList}" var="answer" >
								<p class="rel <shiro:hasPermission name='oaqa:oaquestion:del'>qa_name</shiro:hasPermission>"><shiro:hasPermission name="oaqa:oaquestion:del"><b class="qa_del_btn1" onclick="delThis(this,1,'${answer.id}')">&times;</b></shiro:hasPermission>${fns:getUserById(answer.createBy.id).name}&nbsp;回答：<span id="${answer.id}">${answer.answer}</span> <a class="zan rel" href="javascript:" vl="0" vl2="${answer.id}"><b class="glyphicon glyphicon-thumbs-up"></b><i></i>&nbsp;<span>${answer.praise}</span></a></p>
							</c:forEach>--%>

							<shiro:hasPermission name="oaqa:oaquestion:edit">
							<div class="row">
							</div>
							</shiro:hasPermission>


						</li>

					</c:forEach>
				</ul>
			</div>
		</div>

		<shiro:hasPermission name="oaqa:oaquestion:del">
			<input type="hidden" id="isHasDel" name="isHasDel" value="1" />
		</shiro:hasPermission>
	
		<!-- 分页代码 -->
	<table:page page="${page}"></table:page>
	<br/>
	<br/>
	</div>
	</div>
</div>

<script>
    function add(){
        openDialog("创建问答","${ctx}/oaqa/oaquestion/form?myquestion=yes","80%", "80%","");
    }

    function eidtAnswer(obj){
		$(obj).parent().parent().next("div").show();
        $(obj).parent().parent().next("div").find("input[type=text]").focus();
	}
	function hide(obj) {
		$(obj).parent().hide();
    }
    function submitAnswer(obj) {
		var answer = $(obj).prev().prev().prev("input[name=answercontent]").val();
        var answerid = $(obj).prev().prev("input[name=answerid]").val();
        var questionid = $(obj).prev("input[name=questionid]").val();
		if(answer == ""){
		    layer.alert("请输入答案后提交！",{icon:2});
		}else{
			var len = $(obj).closest("li").find("p").length;

            $.post("${ctx}/oaqa/oaquestion/subAnswer",{'answercontent':answer,'answerid':answerid,'questionid':questionid},function(data){
                var jsonData = jQuery.parseJSON(data);
                if(jsonData.status == 'y'){

                    $(obj).prev().prev("input[name=answerid]").val(jsonData.answerid);
                    $(obj).prev().prev().prev("input[name=answercontent]").val(answer);

                    if(len == 0){
                        $(obj).closest("li").find("h6").remove();
                        if(answerid != ''){
							$("#"+answerid).html(answer);
                        }else{
                            if($("#isHasDel").val() == '1'){
                                $(obj).closest("li").find("a.rel").after('<p class="rel qa_name"><b class="qa_del_btn1" onclick="delThis(this,1,\''+jsonData.answerid+'\')">&times;</b>'+jsonData.name+'&nbsp;回答：<span id='+jsonData.answerid+'>'+answer+'</span> <a class="zan rel" href="javascript:" vl="0" vl2="'+jsonData.answerid+'"><b class="glyphicon glyphicon-thumbs-up"></b><i></i>&nbsp;<span>0</span></a></p>');
							}else{
                                $(obj).closest("li").find("a.rel").after('<p class="rel ">'+jsonData.name+'&nbsp;回答：<span id='+jsonData.answerid+'>'+answer+'</span> <a class="zan rel" href="javascript:" vl="0" vl2="'+jsonData.answerid+'"><b class="glyphicon glyphicon-thumbs-up"></b><i></i>&nbsp;<span>0</span></a></p>');
							}

                        }
                    }else{
                        if(answerid != ''){
                            $("#"+answerid).html(answer);
                        }else{

                            if($("#isHasDel").val() == '1'){
                                $(obj).closest("li").find("p:last").after('<p class="rel qa_name"><b class="qa_del_btn1" onclick="delThis(this,1,\''+jsonData.answerid+'\')">&times;</b>'+jsonData.name+'&nbsp;回答：<span id='+jsonData.answerid+'>'+answer+'</span> <a class="zan rel" href="javascript:" vl="0" vl2="'+jsonData.answerid+'"><b class="glyphicon glyphicon-thumbs-up"></b><i></i>&nbsp;<span>0</span></a></p>')
                            }else{
                                $(obj).closest("li").find("p:last").after('<p class="rel ">'+jsonData.name+'&nbsp;回答：<span id='+jsonData.answerid+'>'+answer+'</span> <a class="zan rel" href="javascript:" vl="0" vl2="'+jsonData.answerid+'"><b class="glyphicon glyphicon-thumbs-up"></b><i></i>&nbsp;<span>0</span></a></p>')
                            }
                        }

                    }


                }else{
                    layer.alert(jsonData.info,{icon:2});
                }
            });



		}
        //$(obj).prev("input[type=text]").val("");
        $(obj).parent().hide();
    }
    function delThis(obj,type,id) {
        layer.confirm('您确认要删除？', {
                btn: ['确认','关闭'] //按钮
            },function(){
				$.post("${ctx}/oaqa/oaquestion/logicDelete",{'type':type,'pid':id},function(data){
					var jsonData = jQuery.parseJSON(data);
					if(jsonData.status == 'y'){
                        location.reload();
					}else{
						layer.alert(jsonData.info,{icon:2});
					}
				});
        	});

    }

	$(function () {


        $('a.zan').live("click",function(){
            var i = $(this).index();
            var vl = $(this).attr("vl");
            var vl2 = $(this).attr("vl2");
            var obj=$(this);
            if(vl == 0){


                $.post("${ctx}/oaqa/oaquestion/doPraise",{'answerid':vl2},function(data){
                    var jsonData = jQuery.parseJSON(data);
                    if(jsonData.status == 'y'){
                        obj.attr("vl","1");

                        obj.append('<div id="zhan'+ i +'"><b>+1</b></div>');
                        $('#zhan'+i).css({'position':'absolute','z-index':'1', 'color':'#C30','left':'10px','top':'-15px'}).animate({top:'-20px',opacity:0},'slow',function(){
                            $(this).fadeIn('fast').remove();
                            var Num = parseInt(obj.find('span').text());
                            Num++;
                            obj.find('span').text(Num);
                        });
                    }else{
                        alert(jsonData.info);
                    }
                });
            }else{
                return false;
            }
        });

        /*$("a[name=toAnswer]").click(function(){
            var questionid = $(this).attr("vl");
            alert(questionid);
		});*/
    })

</script>
</body>
</html>