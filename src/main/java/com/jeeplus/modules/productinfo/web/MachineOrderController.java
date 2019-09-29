package com.jeeplus.modules.productinfo.web;

import com.google.common.collect.Lists;
import com.jeeplus.common.config.Global;
import com.jeeplus.common.persistence.Page;
import com.jeeplus.common.utils.FormatUtil;
import com.jeeplus.common.utils.MyBeanUtils;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.common.utils.excel.ImportExcel;
import com.jeeplus.common.web.BaseController;
import com.jeeplus.modules.productinfo.entity.*;
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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;
import java.util.List;

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
     * 整机信息列表页面
     */
    @RequiresPermissions("checkmodel:machineOrder:list")
    @RequestMapping(value = {"codeNoList", ""})
    public String codeNoList(MachineOrder machineOrder, HttpServletRequest request, HttpServletResponse response, Model model) {
        User user= UserUtils.getUser();
        String codeNo=request.getParameter("codeNo");
        model.addAttribute("codeNo",codeNo);
        if(FormatUtil.isNoEmpty(codeNo)){
            model.addAttribute("isSearch","0");
        }
        else{
            model.addAttribute("isSearch","1");
        }
        model.addAttribute("machineOrder",machineOrder);
        Page<MachineOrder> page = machineOrderService.findDetailPage(new Page<MachineOrder>(request, response), machineOrder);
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

        //过滤查询的SN号
        List<MachineOrderDetail> machineOrderDetailList = Lists.newArrayList();
        String codeNo=request.getParameter("codeNo");
        if(FormatUtil.isNoEmpty(codeNo)){
            for(MachineOrderDetail detail:machineOrder.getMachineOrderDetailList()){
                if(detail.getBoardRecord().contains(codeNo) || detail.getMachineRecord().contains(codeNo)){
                    machineOrderDetailList.add(detail);
                }
            }
            machineOrder.setMachineOrderDetailList(machineOrderDetailList);
        }

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
            //明细数量必须小于等于主表生产数量
            if(t.getMachineOrderDetailList().size()>t.getQuantity()){
                addMessage(redirectAttributes, "明细数量不能大于生产数量，保存整机明细失败");
                return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/machineOrder/machineOrderIndex?repage=repage&type="+request.getParameter("type");
            }
            //保存
            machineOrderService.save(t);

            addMessage(redirectAttributes, "保存整机明细成功");
            return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/machineOrder/machineOrderIndex?repage=repage&type="+request.getParameter("type");
        }else{
            //新增表单保存
            //明细数量必须小于等于主表生产数量
            if(machineOrder.getMachineOrderDetailList().size()>machineOrder.getQuantity()){
                addMessage(redirectAttributes, "明细数量不能大于生产数量，保存整机明细失败");
                return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/machineOrder/machineOrderIndex?repage=repage&type="+request.getParameter("type");
            }
            //保存
            machineOrderService.save(machineOrder);
            addMessage(redirectAttributes, "保存整机明细成功");
            //跳转到周报列表
            return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/machineOrder/machineOrderIndex?repage=repage&type="+request.getParameter("type");
        }
    }

    /**
     * 导入Excel数据
     */
    @RequiresPermissions("checkmodel:machineOrder:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MachineOrder machineOrder, MultipartFile file, RedirectAttributes redirectAttributes) {
        try {
            int i=1;
            int successNum = 0;
            int failureNum = 0;
            StringBuilder failureMsg = new StringBuilder();
            ImportExcel ei = new ImportExcel(file, 1, 0);
            List<MachineOrderDetail> list = ei.getDataList(MachineOrderDetail.class);

            if(StringUtils.isBlank(machineOrder.getId())){
                addMessage(redirectAttributes, "导入整机明细信息记录失败！失败信息：请先保存整机工单，再导入明细信息！");
                return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/machineOrder/machineOrderIndex?repage=repage&type=0";
            }
            //明细数量必须小于等于主表生产数量
            if(list.size()>machineOrder.getQuantity()){
                addMessage(redirectAttributes, "导入整机明细信息记录失败！失败信息：导入明细数量不能大于生产数量！");
                return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/machineOrder/machineOrderIndex?repage=repage&type=0";
            }

            for (MachineOrderDetail machineOrderDetail : list){
                try{
                    machineOrderDetail.setMachineOrder(machineOrder);
                    machineOrderDetail.setCreateBy(UserUtils.getUser());
                    machineOrderDetail.setSort(i);
                    machineOrderService.save(machineOrderDetail);
                    successNum++;
                    i++;
                }catch(ConstraintViolationException ex){
                    failureNum++;
                }catch (Exception ex) {
                    failureNum++;
                }
            }
            if (failureNum>0){
                failureMsg.insert(0, "，失败 "+failureNum+" 条整机明细信息记录。");
            }
            addMessage(redirectAttributes, "已成功导入 "+successNum+" 条整机明细信息记录"+failureMsg);
        } catch (Exception e) {
            addMessage(redirectAttributes, "导入整机明细信息记录失败！失败信息："+e.getMessage());
        }
        return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/machineOrder/machineOrderIndex?repage=repage&type=0";
    }

    /**
     * 删除
     */
    @RequiresPermissions("checkmodel:machineOrder:del")
    @RequestMapping(value = "delete")
    public String delete(MachineOrder machineOrder, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        machineOrderService.delete(machineOrder);
        addMessage(redirectAttributes, "删除整机信息成功");
        return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/machineOrder/machineOrderIndex?repage=repage&type="+request.getParameter("type");
    }
}
