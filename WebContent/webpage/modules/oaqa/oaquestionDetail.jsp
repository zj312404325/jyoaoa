<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>信息管理</title>
	<meta name="decorator" content="default"/>

	<link rel="stylesheet" href="${ctxStatic}/editormd/css/editormd.preview.min.css" />
	<link rel="stylesheet" href="${ctxStatic}/editormd/css/editormd.css" />

	<!-- Favicon-->
	<link rel="stylesheet" href="${ctxStatic}/bootstrap/3.3.4/css_cerulean/bootstrap.min.css">
	<!-- Custom Css -->
	<link rel="stylesheet" href="${ctxStatic}/assets/css/blog.css">
	<%--<link rel="stylesheet" href="${ctxStatic}/assets/css/main.css">--%>
	<link rel="stylesheet" href="${ctxStatic}/assets/css/all-themes.css" />

	<script src="${ctxStatic}/common/contabs.js"></script>
	<script src="${ctxStatic}/editormd/lib/marked.min.js"></script>
	<script src="${ctxStatic}/editormd/lib/prettify.min.js"></script>
	<script src="${ctxStatic}/editormd/editormd.min.js"></script>

	<script type="text/javascript">
		var validateForm;
		var testEditor;
		//editor.md上传本地图片
        $(function() {
            testEditor=editormd("test-editormd", {
                width   : "100%",
				height  : 340,
				syncScrolling : "single",
                autoFocus  : false,
				//你的lib目录的路径，我这边用JSP做测试的
				path    : "${ctxStatic}/editormd/lib/",
				//这个配置在simple.html中并没有，但是为了能够提交表单，使用这个配置可以让构造出来的HTML代码直接在第二个隐藏的textarea域中，方便post提交表单。
				imageUpload : true,
				imageFormats : ["jpg", "jpeg", "gif", "png", "bmp", "webp"],
				imageUploadURL : "${ctx}/sys/user/mdImageUpload",
				saveHTMLToTextarea : true
        	});

            editormd.markdownToHTML("content");

            //点赞
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
        });

		function doSubmit(){//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
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

        function eidtAnswer(obj){
            $(obj).parent().parent().next("div").show();
            $(obj).parent().parent().next("div").find("input[type=text]").focus();
        }
        function hide(obj) {
            $(obj).parent().hide();
        }
        function submitAnswer(obj) {
            var answer = $(obj).prev().prev().prev("input[name=answercontent]").val();
            var html = $(obj).prev().prev().prev("div[name=editormd_div]").children("textarea[name=html]").val();
            var answerid = $(obj).prev().prev("input[name=answerid]").val();
            var questionid = $(obj).prev("input[name=questionid]").val();
            if(html == "" || typeof(html) == undefined){
                layer.alert("请输入内容后提交！",{icon:2});
            }else{
                var len = $(obj).closest("li").find("p").length;

                $.post("${ctx}/oaqa/oaquestion/subAnswer",{'answercontent':html,'answerid':answerid,'questionid':questionid},function(data){
                    var jsonData = jQuery.parseJSON(data);
                    if(jsonData.status == 'y'){

                        layer.msg('回复成功！',{
                            time:1000,
                            end:function () {
                                $("#searchForm").submit();
                            }
                        })

                        /*$(obj).prev().prev("input[name=answerid]").val(jsonData.answerid);
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

                        }*/


                    }else{
                        layer.alert(jsonData.info,{icon:2});
                    }
                });



            }
        }
	</script>
</head>
<body class="hideScroll">
	<form:form id="searchForm" modelAttribute="oaquestion" action="${ctx}/oaqa/oaquestion/detail?id=${oaquestion.id}" method="post" class="form-horizontal">
		<sys:message content="${message}"/>

		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<table:sortColumn id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/>


		<ul class="list-group">
			<img alt="image" class="img-circle" style="height:64px;width:64px;" src="${basePath}${fns:getUserById(oaquestion.createBy.id).photo }" />
			<a class="qa_name"><h3>${oaquestion.title}</h3></a>
		</ul>
		<div id="content">${oaquestion.question}</div>
		<div class="row">
			<div class="col-sm-12">

				<%--Demo start--%>
					<%--<section class="content blog-page">
						<div class="container-fluid">
							<div class="row clearfix">
								<div class="col-md-12 col-lg-8">
									<div class="left-box">
										<div class="card comment">
											<div class="header">
												<h2>Comments 3</h2>
											</div>
											<div class="body">
												<div class="media mleft">
													<div class="media-left">
														<a href="javascript:void(0);"> <img class="media-object rounded" src="${ctxStatic}/assets/images/random-avatar7.jpg" width="80" alt=""></a>
													</div>
													<div class="media-body">
														<h4 class="media-heading">Gigi Hadid</h4>
														Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque
														ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra
														<ul class="list-inline">
															<li><a href="#">Dec 28 2017</a></li>
															<li><a href="#">Reply</a></li>
														</ul>
													</div>
												</div>
												<div class="media mleft">
													<div class="media-left">
														<a href="javascript:void(0);"> <img class="media-object rounded" src="${ctxStatic}/assets/images/random-avatar2.jpg" width="80" alt=""></a>
													</div>
													<div class="media-body">
														<h4 class="media-heading">Christian Louboutin</h4>
														Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,
														<ul class="list-inline">
															<li><a href="#">Jan 10 2017</a></li>
															<li><a href="#">Reply</a></li>
														</ul>
														<div class="media">
															<div class="media-left">
																<a href="#"> <img alt="" class="media-object rounded" src="${ctxStatic}/assets/images/random-avatar4.jpg" width="80"> </a>
															</div>
															<div class="media-body">
																<h4 class="media-heading">Kendall Jenner</h4>
																Cras sit amet nibh libero, in gravida nulla. Nulla
																vel metus scelerisque ante sollicitudin commodo.
																<ul class="list-inline m-b-0">
																	<li><a href="#">Jan 10 2017</a></li>
																	<li><a href="#">Reply</a></li>
																</ul>
															</div>
														</div>
													</div>
												</div>
												<div class="media mleft">
													<div class="media-left">
														<a href="javascript:void(0);"> <img class="media-object rounded" src="${ctxStatic}/assets/images/random-avatar5.jpg" width="80" alt=""></a>
													</div>
													<div class="media-body">
														<h4 class="media-heading">Gigi Hadid</h4>
														Cras sit amet nibh libero, in gravida nulla. Nulla vel metus scelerisque
														ante sollicitudin commodo. Cras purus odio, vestibulum in vulputate at, tempus viverra
														<ul class="list-inline">
															<li><a href="#">Jan 13 2017</a></li>
															<li><a href="#">Reply</a></li>
														</ul>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>

							</div>
						</div>
					</section>--%>
				<%--Demo end--%>
				<div class="card comment">
					<div class="body">
						<c:forEach items="${page.list}" var="answer" >
							<%--<img alt="image" class="img-circle" style="height:64px;width:64px;" src="${basePath}${fns:getUserById(answer.createBy.id).photo}" />
							<p class="rel <shiro:hasPermission name='oaqa:oaquestion:del'>qa_name</shiro:hasPermission>"><shiro:hasPermission name="oaqa:oaquestion:del"><b class="qa_del_btn1" onclick="delThis(this,1,'${answer.id}')">&times;</b></shiro:hasPermission>${fns:getUserById(answer.createBy.id).name}&nbsp;回答：<span id="${answer.id}">${answer.answer}</span> <a class="zan rel" href="javascript:" vl="0" vl2="${answer.id}"><b class="glyphicon glyphicon-thumbs-up"></b><i></i>&nbsp;<span>${answer.praise}</span></a></p>--%>

							<div class="media mleft">
								<div class="media-left">
									<a href="javascript:void(0);"> <img class="img-circle" src="${basePath}${fns:getUserById(answer.createBy.id).photo}" width="50" height="50" alt=""></a>
								</div>
								<div class="media-body" style="">
									<h4 class="media-heading">${fns:getUserById(answer.createBy.id).name}</h4>
									<div style="min-height: 60px;">${answer.answer}</div>
									<ul class="list-inline">
										<li><a class="zan rel" href="javascript:" vl="0" vl2="${answer.id}"><b class="glyphicon glyphicon-thumbs-up"></b><i></i>&nbsp;<span>${answer.praise}</span></a></li>
									</ul>
								</div>
							</div>
						</c:forEach>
					</div>
				</div>

				<!-- 分页代码 -->
				<table:page page="${page}"></table:page>

				<br/><br/>
				<div class="row">
					<div >
						<div style="padding:10px">
							<h4 >发表回复</h4>
						</div>
					</div>
					<div class="col-sm-11 form-inline">
						<div class="editormd" id="test-editormd" name="editormd_div">
							<textarea class="editormd-markdown-textarea" name="markdown" id="editormd" unselectable="on"></textarea>
							<!-- 第二个隐藏文本域，用来构造生成的HTML代码，方便表单POST提交，这里的name可以任意取，后台接受时以这个name键为准 -->
							<textarea class="editormd-html-textarea" name="html"></textarea>
						</div>
						<input type="hidden" name="answerid" value="" />
						<input type="hidden" name="questionid" value="${oaquestion.id}" />
						<button type="button" class="btn btn-primary" onclick="submitAnswer(this)">发表</button>
					</div>
				</div>
			</div>
		</div>
	</form:form>

</body>
</html>