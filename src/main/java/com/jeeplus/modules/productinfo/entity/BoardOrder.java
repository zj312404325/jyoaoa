package com.jeeplus.modules.productinfo.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.google.common.collect.Lists;
import com.jeeplus.common.persistence.DataEntity;
import com.jeeplus.common.utils.excel.annotation.ExcelField;
import java.util.Date;
import java.util.List;


/**
 * 主板Entity
 * @author zj
 * @version 2019-05-27
 */
public class BoardOrder extends DataEntity<BoardOrder> {

    private static final long serialVersionUID = 1L;
    /**工单号*/
    private String orderNo;
    /**预计上线日期*/
    private Date expectDate;
    /**实际上线日期*/
    private Date realDate;
    /**生产数量*/
    private Integer quantity;
    /**固件版本*/
    private String firmware;
    /**产品名称*/
    private String productName;
    /**bom版本*/
    private String bom;
    /**pcb版本*/
    private String pcb;
    /**主板信息明细列表*/
    private List<BoardOrderDetail> boardOrderDetailList = Lists.newArrayList();

    /**开始时间（查询用）*/
    private Date startdate;
    /**结束时间*/
    private Date enddate;

    private String sqlstr;

    public BoardOrder() {
        super();
    }

    public BoardOrder(String id){
        super(id);
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public Date getExpectDate() {
        return expectDate;
    }

    public void setExpectDate(Date expectDate) {
        this.expectDate = expectDate;
    }

    public Date getRealDate() {
        return realDate;
    }

    public void setRealDate(Date realDate) {
        this.realDate = realDate;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public String getFirmware() {
        return firmware;
    }

    public void setFirmware(String firmware) {
        this.firmware = firmware;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getBom() {
        return bom;
    }

    public void setBom(String bom) {
        this.bom = bom;
    }

    public String getPcb() {
        return pcb;
    }

    public void setPcb(String pcb) {
        this.pcb = pcb;
    }

    public List<BoardOrderDetail> getBoardOrderDetailList() {
        return boardOrderDetailList;
    }

    public void setBoardOrderDetailList(List<BoardOrderDetail> boardOrderDetailList) {
        this.boardOrderDetailList = boardOrderDetailList;
    }

    public Date getStartdate() {
        return startdate;
    }

    public void setStartdate(Date startdate) {
        this.startdate = startdate;
    }

    public Date getEnddate() {
        return enddate;
    }

    public void setEnddate(Date enddate) {
        this.enddate = enddate;
    }

    public String getSqlstr() {
        return sqlstr;
    }

    public void setSqlstr(String sqlstr) {
        this.sqlstr = sqlstr;
    }
}
