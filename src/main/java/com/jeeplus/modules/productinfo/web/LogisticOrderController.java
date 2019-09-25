package com.jeeplus.modules.productinfo.web;

import com.jeeplus.common.config.Global;
import com.jeeplus.common.persistence.Page;
import com.jeeplus.common.utils.FormatUtil;
import com.jeeplus.common.utils.MyBeanUtils;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.common.utils.excel.ImportExcel;
import com.jeeplus.common.web.BaseController;
import com.jeeplus.modules.productinfo.entity.*;
import com.jeeplus.modules.productinfo.service.BoardOrderService;
import com.jeeplus.modules.productinfo.service.LogisticOrderService;
import com.jeeplus.modules.sys.entity.User;
import com.jeeplus.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;
import java.util.List;

/**
 * 运单Controller
 * @author zj
 * @version 2019-05-29
 */
@Controller
@RequestMapping(value = "${adminPath}/checkmodel/productinfo/logisticOrder")
public class LogisticOrderController extends BaseController {
    @Autowired
    private LogisticOrderService logisticOrderService;

    @ModelAttribute
    public LogisticOrder get(@RequestParam(required=false) String id) {
        LogisticOrder entity = null;
        if (StringUtils.isNotBlank(id)){
            entity = logisticOrderService.get(id);
        }
        if (entity == null){
            entity = new LogisticOrder();
        }
        return entity;
    }

    /**
     * 运单信息页面
     */
    @RequiresPermissions("checkmodel:logisticOrder:list")
    @RequestMapping(value = {"logisticOrderIndex"})
    public String logisticOrderIndex(LogisticOrder logisticOrder, HttpServletRequest request, HttpServletResponse response, Model model) {
        request.setAttribute("type", request.getParameter("type"));
        request.setAttribute("repage", request.getParameter("repage"));
        model.addAttribute("logisticOrder",logisticOrder);
        return "modules/productinfo/logisticOrderIndex";
    }

    /**
     * 运单信息列表页面
     */
    @RequiresPermissions("checkmodel:logisticOrder:list")
    @RequestMapping(value = {"list", ""})
    public String list(LogisticOrder logisticOrder, HttpServletRequest request, HttpServletResponse response, Model model) {
        User user= UserUtils.getUser();
        String codeNo=request.getParameter("codeNo");
        if(FormatUtil.isNoEmpty(codeNo)){
            model.addAttribute("isSearch","0");
        }
        else{
            model.addAttribute("isSearch","1");
        }
        model.addAttribute("logisticOrder",logisticOrder);
        Page<LogisticOrder> page = logisticOrderService.findPage(new Page<LogisticOrder>(request, response), logisticOrder);
        model.addAttribute("page", page);
        return "modules/productinfo/logisticOrderList";
    }

    /**
     * 运单信息列表页面
     */
    @RequiresPermissions("checkmodel:logisticOrder:list")
    @RequestMapping(value = {"codeNoList", ""})
    public String codeNoList(LogisticOrder logisticOrder, HttpServletRequest request, HttpServletResponse response, Model model) {
        User user= UserUtils.getUser();
        String codeNo=request.getParameter("codeNo");
        if(FormatUtil.isNoEmpty(codeNo)){
            model.addAttribute("isSearch","0");
        }
        else{
            model.addAttribute("isSearch","1");
        }
        model.addAttribute("logisticOrder",logisticOrder);
        Page<LogisticOrder> page = logisticOrderService.findDetailPage(new Page<LogisticOrder>(request, response), logisticOrder);
        model.addAttribute("page", page);
        return "modules/productinfo/logisticOrderList";
    }

    /**
     * 查看，增加，编辑发货信息页面
     */
    @RequiresPermissions(value={"checkmodel:logisticOrder:view","checkmodel:logisticOrder:add","checkmodel:logisticOrder:edit"},logical=Logical.OR)
    @RequestMapping(value = "form")
    public String form(LogisticOrder logisticOrder, Model model,HttpServletRequest request, RedirectAttributes redirectAttributes) {
        request.setAttribute("bhv", request.getParameter("bhv"));
        request.setAttribute("type", request.getParameter("type"));

        model.addAttribute("logisticOrder", logisticOrder);

        if(FormatUtil.isNoEmpty(request.getParameter("type"))&&("1".equals(request.getParameter("type")))){
            return "modules/productinfo/logisticOrderForm";
        }
        //后台管理
        else if(FormatUtil.isNoEmpty(request.getParameter("type"))&&("2".equals(request.getParameter("type")))){
            request.setAttribute("disableScore", "1");
            return "modules/productinfo/logisticOrderForm";
        }

        return "modules/productinfo/logisticOrderForm";
    }

    /**
     * 保存发货明细
     */
    @RequiresPermissions(value={"checkmodel:logisticOrder:add","checkmodel:logisticOrder:edit"},logical=Logical.OR)
    @RequestMapping(value = "save")
    public String save(LogisticOrder logisticOrder, Model model, RedirectAttributes redirectAttributes,HttpServletRequest request) throws Exception{
        if (!beanValidator(model, logisticOrder)){
            return form(logisticOrder, model,request,redirectAttributes);
        }
        //编辑表单修改
        if(!logisticOrder.getIsNewRecord()){
            //从数据库取出记录的值
            LogisticOrder t = logisticOrderService.get(logisticOrder.getId());

            //将编辑表单中的非NULL值覆盖数据库记录中的值
            MyBeanUtils.copyBeanNotNull2Bean(logisticOrder, t);
            //明细数量必须和发货数量保持一致
            if(t.getLogisticOrderDetailList().size()!=t.getQuantity()){
                addMessage(redirectAttributes, "发货数量和数据条目不一致，保存发货明细失败");
                return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/logisticOrder/logisticOrderIndex?repage=repage&type="+request.getParameter("type");
            }
            //保存
            logisticOrderService.save(t);

            addMessage(redirectAttributes, "保存发货明细成功");
            return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/logisticOrder/logisticOrderIndex?repage=repage&type="+request.getParameter("type");
        }else{
            //新增表单保存
            //明细数量必须和发货数量保持一致
            if(logisticOrder.getLogisticOrderDetailList().size()!=logisticOrder.getQuantity()){
                addMessage(redirectAttributes, "发货数量和数据条目不一致，保存发货明细失败");
                return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/logisticOrder/logisticOrderIndex?repage=repage&type="+request.getParameter("type");
            }
            //保存
            logisticOrderService.save(logisticOrder);
            addMessage(redirectAttributes, "保存发货明细成功");
            //跳转到周报列表
            return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/logisticOrder/logisticOrderIndex?repage=repage&type="+request.getParameter("type");
        }
    }

    /**
     * 导入Excel数据
     */
    @RequiresPermissions("checkmodel:logisticOrder:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(LogisticOrder logisticOrder, MultipartFile file, RedirectAttributes redirectAttributes) {
        try {
            int i=1;
            int successNum = 0;
            int failureNum = 0;
            StringBuilder failureMsg = new StringBuilder();
            ImportExcel ei = new ImportExcel(file, 1, 0);
            List<LogisticOrderDetail> list = ei.getDataList(LogisticOrderDetail.class);

            for (LogisticOrderDetail logisticOrderDetail : list){
                try{
                    logisticOrderDetail.setLogisticOrder(logisticOrder);
                    logisticOrderDetail.setCreateBy(UserUtils.getUser());
                    logisticOrderDetail.setSort(i);
                    logisticOrderService.save(logisticOrderDetail);
                    successNum++;
                    i++;
                }catch(ConstraintViolationException ex){
                    failureNum++;
                }catch (Exception ex) {
                    failureNum++;
                }
            }
            if (failureNum>0){
                failureMsg.insert(0, "，失败 "+failureNum+" 条发货明细信息记录。");
            }
            addMessage(redirectAttributes, "已成功导入 "+successNum+" 条发货明细信息记录"+failureMsg);
        } catch (Exception e) {
            addMessage(redirectAttributes, "导入发货明细信息记录失败！失败信息："+e.getMessage());
        }
        return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/logisticOrder/logisticOrderIndex?repage=repage&type=0";
    }

    /**
     * 删除
     */
    @RequiresPermissions("checkmodel:logisticOrder:del")
    @RequestMapping(value = "delete")
    public String delete(LogisticOrder logisticOrder, RedirectAttributes redirectAttributes,HttpServletRequest request) {
        logisticOrderService.delete(logisticOrder);
        addMessage(redirectAttributes, "删除发货信息成功");
        return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/logisticOrder/logisticOrderIndex?repage=repage&type="+request.getParameter("type");
    }
}
