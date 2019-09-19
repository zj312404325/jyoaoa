package com.jeeplus.modules.productinfo.entity;

import com.google.common.collect.Lists;
import com.jeeplus.common.persistence.DataEntity;

import java.util.Date;
import java.util.List;

/**
 * 发货单Entity
 * @author zj
 * @version 2019-05-27
 */
public class LogisticOrder extends DataEntity<LogisticOrder> {

    private static final long serialVersionUID = 1L;
    /**物流单号*/
    private String orderNo;
    /**发货数量*/
    private Integer quantity;
    /**收货单位*/
    private String receiveComp;
    /**收货地址*/
    private String receiveAddress;
    /**收货电话*/
    private String receiveMobile;
    /**收货人*/
    private String receivePerson;
    /**发货单位*/
    private String sendComp;
    /**发货地址*/
    private String sendAddress;
    /**发货电话*/
    private String sendMobile;
    /**发货人*/
    private String sendPerson;
    /**承运单位*/
    private String transComp;
    /**承运电话*/
    private String transMobile;
    /**承运人*/
    private String transPerson;
    /**发货信息明细列表*/
    private List<LogisticOrderDetail> logisticOrderDetailList = Lists.newArrayList();

    /**开始时间（查询用）*/
    private Date startdate;
    /**结束时间*/
    private Date enddate;

    private String sqlstr;

    public LogisticOrder() {
        super();
    }

    public LogisticOrder(String id){
        super(id);
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public String getReceiveComp() {
        return receiveComp;
    }

    public void setReceiveComp(String receiveComp) {
        this.receiveComp = receiveComp;
    }

    public String getReceiveAddress() {
        return receiveAddress;
    }

    public void setReceiveAddress(String receiveAddress) {
        this.receiveAddress = receiveAddress;
    }

    public String getReceiveMobile() {
        return receiveMobile;
    }

    public void setReceiveMobile(String receiveMobile) {
        this.receiveMobile = receiveMobile;
    }

    public String getReceivePerson() {
        return receivePerson;
    }

    public void setReceivePerson(String receivePerson) {
        this.receivePerson = receivePerson;
    }

    public String getSendComp() {
        return sendComp;
    }

    public void setSendComp(String sendComp) {
        this.sendComp = sendComp;
    }

    public String getSendAddress() {
        return sendAddress;
    }

    public void setSendAddress(String sendAddress) {
        this.sendAddress = sendAddress;
    }

    public String getSendMobile() {
        return sendMobile;
    }

    public void setSendMobile(String sendMobile) {
        this.sendMobile = sendMobile;
    }

    public String getSendPerson() {
        return sendPerson;
    }

    public void setSendPerson(String sendPerson) {
        this.sendPerson = sendPerson;
    }

    public String getTransComp() {
        return transComp;
    }

    public void setTransComp(String transComp) {
        this.transComp = transComp;
    }

    public String getTransMobile() {
        return transMobile;
    }

    public void setTransMobile(String transMobile) {
        this.transMobile = transMobile;
    }

    public String getTransPerson() {
        return transPerson;
    }

    public void setTransPerson(String transPerson) {
        this.transPerson = transPerson;
    }

    public List<LogisticOrderDetail> getLogisticOrderDetailList() {
        return logisticOrderDetailList;
    }

    public void setLogisticOrderDetailList(List<LogisticOrderDetail> logisticOrderDetailList) {
        this.logisticOrderDetailList = logisticOrderDetailList;
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
