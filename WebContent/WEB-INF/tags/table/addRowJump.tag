<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/webpage/include/taglib.jsp"%>
<%@ attribute name="url" type="java.lang.String" required="true"%>
<%@ attribute name="title" type="java.lang.String" required="true"%>
<%@ attribute name="width" type="java.lang.String" required="false"%>
<%@ attribute name="height" type="java.lang.String" required="false"%>
<%@ attribute name="target" type="java.lang.String" required="false"%>
<%@ attribute name="label" type="java.lang.String" required="false"%>
<button class="btn btn-white btn-sm" data-toggle="tooltip" data-placement="left" onclick="add()" title="添加"><i class="fa fa-plus"></i> ${label==null?'添加':label}</button>
<%-- 使用方法： 1.将本tag写在查询的form之前；2.传入table的id和controller的url --%>
<script type="text/javascript">
	function add(){
        $.post("${ctx}/checkmodel/performanceCheck/validHasPost",{},function(data){
            var jsonData = jQuery.parseJSON(data);
            if(jsonData.status == 'y'){
                openDialogJump("新增"+'${title}',"${url}","${width==null?'80%':width}", "${height==null?'80%':height}","${target}");
            }else{
                top.layer.alert(jsonData.info,{icon: 2});
            }
        });

	}
</script>