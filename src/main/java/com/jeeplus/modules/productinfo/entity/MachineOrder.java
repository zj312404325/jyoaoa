package com.jeeplus.modules.productinfo.entity;

import com.google.common.collect.Lists;
import com.jeeplus.common.persistence.DataEntity;

import java.util.Date;
import java.util.List;

/**
 * 主板Entity
 * @author zj
 * @version 2019-05-27
 */
public class MachineOrder extends DataEntity<MachineOrder> {

    private static final long serialVersionUID = 1L;
    /**工单号*/
    private String orderNo;
    /**预计上线日期*/
    private Date expectDate;
    /**实际上线日期*/
    private Date realDate;
    /**生产数量*/
    private Integer quantity;
    /**备注*/
    private String remark;
    /**固件版本*/
    private String firmware;
    /**产品名称*/
    private String productName;
    /**ec版本*/
    private String ec;
    /**硬盘规格及数量*/
    private String hardware;
    /**内核版本*/
    private String kernel;
    /**内存规格及数量*/
    private String ram;
    /**系统版本*/
    private String os;
    /**显卡型号*/
    private String gpu;
    /**扩展卡1*/
    private String expand1;
    /**扩展卡2*/
    private String expand2;
    /**主板信息明细列表*/
    private List<MachineOrderDetail> machineOrderDetailList = Lists.newArrayList();

    /**开始时间（查询用）*/
    private Date startdate;
    /**结束时间*/
    private Date enddate;

    private String sqlstr;

    /**sn编号*/
    private String codeNo;

    public MachineOrder() {
        super();
    }

    public MachineOrder(String id){
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

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
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

    public String getEc() {
        return ec;
    }

    public void setEc(String ec) {
        this.ec = ec;
    }

    public String getHardware() {
        return hardware;
    }

    public void setHardware(String hardware) {
        this.hardware = hardware;
    }

    public String getKernel() {
        return kernel;
    }

    public void setKernel(String kernel) {
        this.kernel = kernel;
    }

    public String getRam() {
        return ram;
    }

    public void setRam(String ram) {
        this.ram = ram;
    }

    public String getOs() {
        return os;
    }

    public void setOs(String os) {
        this.os = os;
    }

    public String getGpu() {
        return gpu;
    }

    public void setGpu(String gpu) {
        this.gpu = gpu;
    }

    public String getExpand1() {
        return expand1;
    }

    public void setExpand1(String expand1) {
        this.expand1 = expand1;
    }

    public String getExpand2() {
        return expand2;
    }

    public void setExpand2(String expand2) {
        this.expand2 = expand2;
    }

    public List<MachineOrderDetail> getMachineOrderDetailList() {
        return machineOrderDetailList;
    }

    public void setMachineOrderDetailList(List<MachineOrderDetail> machineOrderDetailList) {
        this.machineOrderDetailList = machineOrderDetailList;
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

    public String getCodeNo() {
        return codeNo;
    }

    public void setCodeNo(String codeNo) {
        this.codeNo = codeNo;
    }
}