/**
 * Copyright &copy; 2015-2020 <a href="http://www.jeeplus.org/">JeePlus</a> All rights reserved.
 */
package com.jeeplus.modules.iim.web;

import com.jeeplus.common.config.Global;
import com.jeeplus.common.json.AjaxJson;
import com.jeeplus.common.persistence.Page;
import com.jeeplus.common.utils.DateUtils;
import com.jeeplus.common.utils.FormatUtil;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.common.utils.excel.ExportExcel;
import com.jeeplus.common.web.BaseController;
import com.jeeplus.modules.iim.entity.ChatHistory;
import com.jeeplus.modules.iim.service.ChatHistoryService;
import com.jeeplus.modules.sys.entity.User;
import com.jeeplus.modules.sys.utils.UserUtils;
import net.sf.json.JSONObject;
import org.apache.commons.httpclient.HttpException;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 聊天记录Controller
 * @author jeeplus
 * @version 2015-12-29
 */
@Controller
@RequestMapping(value = "${adminPath}/iim/chatHistory")
public class ChatHistoryController extends BaseController {

	@Autowired
	private ChatHistoryService chatHistoryService;
	
	@ModelAttribute
	public ChatHistory get(@RequestParam(required=false) String id) {
		ChatHistory entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = chatHistoryService.get(id);
		}
		if (entity == null){
			entity = new ChatHistory();
		}
		return entity;
	}
	
	/**
	 * 聊天列表页面
	 */
	@RequestMapping(value = {"list", ""})
	public String list(ChatHistory chatHistory, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page pg = new Page<ChatHistory>(request, response);
		Page<ChatHistory> page;

		chatHistory.setCurrentUser(UserUtils.getUser());
		if("group".equals(chatHistory.getType())){
			
			page = chatHistoryService.findGroupPage(pg, chatHistory); 
			
		}else{
			page = chatHistoryService.findPage(pg, chatHistory); 
		}
	
		model.addAttribute("chatHistory", chatHistory);
		model.addAttribute("page", page);
		return "modules/iim/chatHistoryList";
	}

	/**
	 * 查看，增加，编辑聊天表单页面
	 */
	@RequestMapping(value = "form")
	public String form(ChatHistory chatHistory, Model model) {
		model.addAttribute("chatHistory", chatHistory);
		return "modules/iim/chatHistoryForm";
	}

	/**
	 * 保存聊天
	 */
	@RequestMapping(value = "save")
	public String save(ChatHistory chatHistory, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, chatHistory)){
			return form(chatHistory, model);
		}
		chatHistoryService.save(chatHistory);
		addMessage(redirectAttributes, "保存聊天成功");
		return "redirect:"+Global.getAdminPath()+"/iim/chatHistory/?repage";
	}
	
	/**
	 * 删除聊天
	 */
	@RequestMapping(value = "delete")
	public String delete(ChatHistory chatHistory, RedirectAttributes redirectAttributes) {
		chatHistoryService.delete(chatHistory);
		addMessage(redirectAttributes, "删除聊天成功");
		return "redirect:"+Global.getAdminPath()+"/iim/chatHistory/?repage";
	}
	
	/**
	 * 批量删除聊天
	 */
	@RequestMapping(value = "deleteAll")
	public String deleteAll(String ids, RedirectAttributes redirectAttributes) {
		String idArray[] =ids.split(",");
		for(String id : idArray){
			chatHistoryService.delete(chatHistoryService.get(id));
		}
		addMessage(redirectAttributes, "删除聊天成功");
		return "redirect:"+Global.getAdminPath()+"/iim/chatHistory/?repage";
	}

    @RequestMapping(value = "deleteAllChatHistory")
    public String deleteAllChatHistory( RedirectAttributes redirectAttributes) {
        chatHistoryService.deleteAllChatHistory();
        addMessage(redirectAttributes, "删除聊天成功");
        return "redirect:"+Global.getAdminPath()+"/iim/chatHistory/chatHistoryManager";
    }
	
	/**
	 * 导出excel文件
	 */
	@RequiresPermissions("iim:chatHistory:view")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public String exportFile(ChatHistory chatHistory, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "聊天"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<ChatHistory> page = chatHistoryService.findPage(new Page<ChatHistory>(request, response, -1), chatHistory);
    		new ExportExcel("聊天", ChatHistory.class).setDataList(page.getList()).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导出聊天记录失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/iim/chatHistory/?repage";
    }

	/**
	 * 获取聊天记录
	 */
	@ResponseBody
	@RequestMapping(value = "getChats")
	public AjaxJson getChats(ChatHistory chatHistory, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<ChatHistory> page = chatHistoryService.findPage(new Page<ChatHistory>(request, response), chatHistory); 
		List<ChatHistory> list = page.getList();
		for(ChatHistory c : list){
			if(c.getStatus().equals("0")){
				if(c.getUserid2().equals(UserUtils.getUser().getLoginName())){//把发送给我的信息标记为已读
					c.setStatus("1");//标记为已读
					chatHistoryService.save(c);
				}
				
			}
		}
		AjaxJson j = new AjaxJson();
		j.setMsg("获取聊天记录成功!");
		j.put("data", page.getList());
		return j;
	}
	
	/**
	 * 获取未读条数
	 */
	@ResponseBody
	@RequestMapping(value = "findUnReadCount")
	public AjaxJson  findUnReadCount(ChatHistory chatHistory, HttpServletRequest request, HttpServletResponse response, Model model) {
		AjaxJson j = new AjaxJson();
		int size = chatHistoryService.findUnReadCount(chatHistory); 
		j.setMsg("获取未读条数成功!");
		j.put("num", size);
		
		return j;
		
	}

	
	/**
	 * 发送聊天内容（手机端)
	 */
	
	@ResponseBody
	@RequestMapping(value = "sendChats")
	public  AjaxJson  sendChats(ChatHistory chatHistory, HttpServletRequest request, HttpServletResponse response, Model model) {
		AjaxJson j = new AjaxJson();
		j.setMsg("消息发送成功!");
		chatHistory.setStatus("0");//标记未读
		chatHistoryService.save(chatHistory);
		
		return j;
	}

	@RequestMapping(value = "chatHistoryManager")
	public String chatHistoryManager(ChatHistory chatHistory, Model model) {
		return "modules/iim/chatHistoryManager";
	}


	@RequestMapping(value = "deleteMyChatHistory", method=RequestMethod.POST)
	public void deleteMyChatHistory(ChatHistory chatHistory, Model model, RedirectAttributes redirectAttributes, HttpServletRequest request, HttpServletResponse response) throws HttpException, IOException {
		response.setHeader("Content-Type", "text/html;charset=utf-8");
		PrintWriter out =  response.getWriter();
		Map map = new HashMap();

		User loginUser = UserUtils.getUser();
		String userid1 = request.getParameter("userid1");
		if(!FormatUtil.isNoEmpty(userid1)){
			userid1=loginUser.getLoginName();
		}
		String userid2 = request.getParameter("userid2");
		String type = request.getParameter("type");

		chatHistory.setUserid1(userid1);
		chatHistory.setUserid2(userid2);
		//Page pg = new Page<ChatHistory>(request, response);

		try {

			List<ChatHistory> list;
			if("group".equals(type)){

				list = chatHistoryService.findGroupPage(chatHistory);
				for (ChatHistory ch : list){
					ch.setDeluserids(FormatUtil.toString(ch.getDeluserids())+loginUser.getLoginName()+",");
					chatHistoryService.save(ch);
				}

			}else{
				list = chatHistoryService.findLogList(chatHistory);
				for (ChatHistory ch : list){
					ch.setDeluserids(FormatUtil.toString(ch.getDeluserids())+loginUser.getLoginName()+",");
					chatHistoryService.save(ch);
				}
			}


			map.put("status", "y");
			map.put("info", "删除聊天记录成功！");
		} catch (Exception e) {
			e.printStackTrace();
			map.put("status", "n");
			map.put("info", "删除聊天记录失败！");
		}



		out.write(JSONObject.fromObject(map).toString());
		out.close();
	}
}