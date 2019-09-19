package com.jeeplus.modules.productinfo.web;

import com.jeeplus.common.config.Global;
import com.jeeplus.common.persistence.Page;
import com.jeeplus.common.utils.FormatUtil;
import com.jeeplus.common.utils.MyBeanUtils;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.common.web.BaseController;
import com.jeeplus.modules.productinfo.entity.BoardOrder;
import com.jeeplus.modules.productinfo.entity.MachineOrder;
import com.jeeplus.modules.productinfo.service.BoardOrderService;
import com.jeeplus.modules.productinfo.service.MachineOrderService;
import com.jeeplus.modules.sys.entity.User;
import com.jeeplus.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 整机Controller
 * @author zj
 * @version 2019-05-29
 */
@Controller
@RequestMapping(value = "${adminPath}/checkmodel/productinfo/machineOrder")
public class MachineOrderController extends BaseController {
    @Autowired
    private MachineOrderService machineOrderService;

    @ModelAttribute
    public MachineOrder get(@RequestParam(required=false) String id) {
        MachineOrder entity = null;
        if (StringUtils.isNotBlank(id)){
            entity = machineOrderService.get(id);
        }
        if (entity == null){
            entity = new MachineOrder();
        }
        return entity;
    }

    /**
     * 整机信息页面
     */
    @RequiresPermissions("checkmodel:machineOrder:list")
    @RequestMapping(value = {"machineOrderIndex"})
    public String machineOrderIndex(MachineOrder machineOrder, HttpServletRequest request, HttpServletResponse response, Model model) {
        request.setAttribute("type", request.getParameter("type"));
        request.setAttribute("repage", request.getParameter("repage"));
        model.addAttribute("machineOrder",machineOrder);
        return "modules/productinfo/machineOrderIndex";
    }

    /**
     * 整机信息列表页面
     */
    @RequiresPermissions("checkmodel:machineOrder:list")
    @RequestMapping(value = {"list", ""})
    public String list(MachineOrder machineOrder, HttpServletRequest request, HttpServletResponse response, Model model) {
        User user= UserUtils.getUser();
        String codeNo=request.getParameter("codeNo");
        if(FormatUtil.isNoEmpty(codeNo)){
            model.addAttribute("isSearch","0");
        }
        else{
            model.addAttribute("isSearch","1");
        }
        model.addAttribute("machineOrder",machineOrder);
        Page<MachineOrder> page = machineOrderService.findPage(new Page<MachineOrder>(request, response), machineOrder);
        model.addAttribute("page", page);
        return "modules/productinfo/machineOrderList";
    }

    /**
     * 查看，增加，编辑主板整机页面
     */
    @RequiresPermissions(value={"checkmodel:machineOrder:view","checkmodel:machineOrder:add","checkmodel:machineOrder:edit"},logical=Logical.OR)
    @RequestMapping(value = "form")
    public String form(MachineOrder machineOrder, Model model,HttpServletRequest request, RedirectAttributes redirectAttributes) {
        request.setAttribute("bhv", request.getParameter("bhv"));
        request.setAttribute("type", request.getParameter("type"));

        model.addAttribute("machineOrder", machineOrder);

        if(FormatUtil.isNoEmpty(request.getParameter("type"))&&("1".equals(request.getParameter("type")))){
            return "modules/productinfo/machineOrderForm";
        }
        //后台管理
        else if(FormatUtil.isNoEmpty(request.getParameter("type"))&&("2".equals(request.getParameter("type")))){
            request.setAttribute("disableScore", "1");
            return "modules/productinfo/machineOrderForm";
        }

        return "modules/productinfo/machineOrderForm";
    }

    /**
     * 保存整机明细
     */
    @RequiresPermissions(value={"checkmodel:machineOrder:add","checkmodel:machineOrder:edit"},logical=Logical.OR)
    @RequestMapping(value = "save")
    public String save(MachineOrder machineOrder, Model model, RedirectAttributes redirectAttributes,HttpServletRequest request) throws Exception{
        if (!beanValidator(model, machineOrder)){
            return form(machineOrder, model,request,redirectAttributes);
        }
        //编辑表单修改
        if(!machineOrder.getIsNewRecord()){
            //从数据库取出记录的值
            MachineOrder t = machineOrderService.get(machineOrder.getId());

            //将编辑表单中的非NULL值覆盖数据库记录中的值
            MyBeanUtils.copyBeanNotNull2Bean(machineOrder, t);
            //保存
            machineOrderService.save(t);

            addMessage(redirectAttributes, "保存整机明细成功");
            return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/machineOrder/machineOrderIndex?repage=repage&type="+request.getParameter("type");
        }else{
            //新增表单保存

            //保存
            machineOrderService.save(machineOrder);
            addMessage(redirectAttributes, "保存整机明细成功");
            //跳转到周报列表
            return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/machineOrder/machineOrderIndex?repage=repage&type="+request.getParameter("type");
        }
    }
}
