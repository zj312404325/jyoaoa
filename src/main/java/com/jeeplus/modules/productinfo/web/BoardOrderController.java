package com.jeeplus.modules.productinfo.web;

import com.jeeplus.common.config.Global;
import com.jeeplus.common.persistence.Page;
import com.jeeplus.common.utils.FormatUtil;
import com.jeeplus.common.utils.MyBeanUtils;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.common.utils.excel.ImportExcel;
import com.jeeplus.common.web.BaseController;
import com.jeeplus.modules.checkmodel.entity.CheckUser;
import com.jeeplus.modules.ehr.entity.QuestionSurvey;
import com.jeeplus.modules.productinfo.entity.BoardOrder;
import com.jeeplus.modules.productinfo.entity.BoardOrderDetail;
import com.jeeplus.modules.productinfo.service.BoardOrderService;
import com.jeeplus.modules.reports.entity.WeeklyReport;
import com.jeeplus.modules.reports.entity.WeeklyReportDetail;
import com.jeeplus.modules.reports.service.WeeklyReportService;
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
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * 主板Controller
 * @author zj
 * @version 2019-05-29
 */
@Controller
@RequestMapping(value = "${adminPath}/checkmodel/productinfo/boardOrder")
public class BoardOrderController extends BaseController {

    @Autowired
    private BoardOrderService boardOrderService;

    @ModelAttribute
    public BoardOrder get(@RequestParam(required=false) String id) {
        BoardOrder entity = null;
        if (StringUtils.isNotBlank(id)){
            entity = boardOrderService.get(id);
        }
        if (entity == null){
            entity = new BoardOrder();
        }
        return entity;
    }

    /**
     * 主板信息页面
     */
    @RequiresPermissions("checkmodel:boardOrder:list")
    @RequestMapping(value = {"boardOrderIndex"})
    public String boardOrderIndex(BoardOrder boardOrder, HttpServletRequest request, HttpServletResponse response, Model model) {
        request.setAttribute("type", request.getParameter("type"));
        request.setAttribute("repage", request.getParameter("repage"));
        model.addAttribute("boardOrder",boardOrder);
        return "modules/productinfo/boardOrderIndex";
    }

    /**
     * 主板信息列表页面
     */
    @RequiresPermissions("checkmodel:boardOrder:list")
    @RequestMapping(value = {"list", ""})
    public String list(BoardOrder boardOrder, HttpServletRequest request, HttpServletResponse response, Model model) {
        User user= UserUtils.getUser();
        String codeNo=request.getParameter("codeNo");
        if(FormatUtil.isNoEmpty(codeNo)){
            model.addAttribute("isSearch","0");
        }
        else{
            model.addAttribute("isSearch","1");
        }
        model.addAttribute("boardOrder",boardOrder);
        Page<BoardOrder> page = boardOrderService.findPage(new Page<BoardOrder>(request, response), boardOrder);
        model.addAttribute("page", page);
        return "modules/productinfo/boardOrderList";
    }

    /**
     * 主板信息列表页面
     */
    @RequiresPermissions("checkmodel:boardOrder:list")
    @RequestMapping(value = {"codeNoList", ""})
    public String codeNoList(BoardOrder boardOrder, HttpServletRequest request, HttpServletResponse response, Model model) {
        User user= UserUtils.getUser();
        String codeNo=request.getParameter("codeNo");
        boardOrder.setCodeNo(codeNo);
        if(FormatUtil.isNoEmpty(codeNo)){
            model.addAttribute("isSearch","0");
        }
        else{
            model.addAttribute("isSearch","1");
        }
        model.addAttribute("boardOrder",boardOrder);
        Page<BoardOrder> page = boardOrderService.findDetailPage(new Page<BoardOrder>(request, response), boardOrder);
        model.addAttribute("page", page);
        return "modules/productinfo/boardOrderList";
    }

    /**
     * 查看，增加，编辑主板表单页面
     */
    @RequiresPermissions(value={"checkmodel:boardOrder:view","checkmodel:boardOrder:add","checkmodel:boardOrder:edit"},logical=Logical.OR)
    @RequestMapping(value = "form")
    public String form(BoardOrder boardOrder, Model model,HttpServletRequest request, RedirectAttributes redirectAttributes) {
        request.setAttribute("bhv", request.getParameter("bhv"));
        request.setAttribute("type", request.getParameter("type"));

        model.addAttribute("boardOrder", boardOrder);

        if(FormatUtil.isNoEmpty(request.getParameter("type"))&&("1".equals(request.getParameter("type")))){
            return "modules/productinfo/boardOrderForm";
        }
        //后台管理
        else if(FormatUtil.isNoEmpty(request.getParameter("type"))&&("2".equals(request.getParameter("type")))){
            request.setAttribute("disableScore", "1");
            return "modules/productinfo/boardOrderForm";
        }

        return "modules/productinfo/boardOrderForm";
    }

    /**
     * 保存主板明细
     */
    @RequiresPermissions(value={"checkmodel:boardOrder:add","checkmodel:boardOrder:edit"},logical=Logical.OR)
    @RequestMapping(value = "save")
    public String save(BoardOrder boardOrder, Model model, RedirectAttributes redirectAttributes,HttpServletRequest request) throws Exception{
        if (!beanValidator(model, boardOrder)){
            return form(boardOrder, model,request,redirectAttributes);
        }
        //编辑表单修改
        if(!boardOrder.getIsNewRecord()){
            //从数据库取出记录的值
            BoardOrder t = boardOrderService.get(boardOrder.getId());

            //将编辑表单中的非NULL值覆盖数据库记录中的值
            MyBeanUtils.copyBeanNotNull2Bean(boardOrder, t);
            //明细数量必须小于等于主表生产数量
            if(t.getBoardOrderDetailList().size()>t.getQuantity()){
                addMessage(redirectAttributes, "明细数量不能大于生产数量，保存主板明细失败");
                return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/boardOrder/boardOrderIndex?repage=repage&type="+request.getParameter("type");
            }
            //保存
            boardOrderService.save(t);

            addMessage(redirectAttributes, "保存主板明细成功");
            return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/boardOrder/boardOrderIndex?repage=repage&type="+request.getParameter("type");
        }else{
            //新增表单保存
            //明细数量必须小于等于主表生产数量
            if(boardOrder.getBoardOrderDetailList().size()>boardOrder.getQuantity()){
                addMessage(redirectAttributes, "明细数量不能大于生产数量，保存主板明细失败");
                return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/boardOrder/boardOrderIndex?repage=repage&type="+request.getParameter("type");
            }
            //保存
            boardOrderService.save(boardOrder);
            addMessage(redirectAttributes, "保存主板明细成功");
            //跳转到周报列表
            return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/boardOrder/boardOrderIndex?repage=repage&type="+request.getParameter("type");
        }
    }

    /**
     * 查询页面
     */
    @RequiresPermissions("checkmodel:search:list")
    @RequestMapping(value = {"searchIndex"})
    public String searchIndex(HttpServletRequest request, HttpServletResponse response, Model model) {
        request.setAttribute("type", request.getParameter("type"));
        request.setAttribute("repage", request.getParameter("repage"));
        return "modules/productinfo/searchIndex";
    }

    /**
     * 导入Excel数据
     */
    @RequiresPermissions("checkmodel:boardOrder:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(BoardOrder boardOrder,MultipartFile file, RedirectAttributes redirectAttributes) {
        try {
            int i=1;
            int successNum = 0;
            int failureNum = 0;
            StringBuilder failureMsg = new StringBuilder();
            ImportExcel ei = new ImportExcel(file, 1, 0);
            List<BoardOrderDetail> list = ei.getDataList(BoardOrderDetail.class);

            //明细数量必须小于等于主表生产数量
            if(list.size()>boardOrder.getQuantity()){
                addMessage(redirectAttributes, "导入主板明细信息记录失败！失败信息：导入明细数量不能大于生产数量！");
                return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/boardOrder/boardOrderIndex?repage=repage&type=0";
            }

            for (BoardOrderDetail boardOrderDetail : list){
                try{
                    boardOrderDetail.setBoardOrder(boardOrder);
                    boardOrderDetail.setCreateBy(UserUtils.getUser());
                    boardOrderDetail.setSort(i);
                    boardOrderService.save(boardOrderDetail);
                    successNum++;
                    i++;
                }catch(ConstraintViolationException ex){
                    failureNum++;
                }catch (Exception ex) {
                    failureNum++;
                }
            }
            if (failureNum>0){
                failureMsg.insert(0, "，失败 "+failureNum+" 条主板明细信息记录。");
            }
            addMessage(redirectAttributes, "已成功导入 "+successNum+" 条主板明细信息记录"+failureMsg);
        } catch (Exception e) {
            addMessage(redirectAttributes, "导入主板明细信息记录失败！失败信息："+e.getMessage());
        }
        return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/boardOrder/boardOrderIndex?repage=repage&type=0";
    }

    /**
     * 删除
     */
    @RequiresPermissions("checkmodel:boardOrder:del")
    @RequestMapping(value = "delete")
    public String delete(BoardOrder boardOrder, RedirectAttributes redirectAttributes,HttpServletRequest request) {

        boardOrderService.delete(boardOrder);
        addMessage(redirectAttributes, "删除主板信息成功");
        return "redirect:"+Global.getAdminPath()+"/checkmodel/productinfo/boardOrder/boardOrderIndex?repage=repage&type="+request.getParameter("type");
    }
}
