package com.jeeplus.modules.productinfo.entity;

import com.jeeplus.common.persistence.DataEntity;

/**
 * 整机明细Entity
 * @author zj
 * @version 2019-05-27
 */
public class MachineOrderDetail extends DataEntity<MachineOrderDetail> {

    private static final long serialVersionUID = 1L;
    /**主表id 父类*/
    private MachineOrder machineOrder;
    /**主板条码记录*/
    private String boardRecord;
    /**整机条码记录*/
    private String machineRecord;
    /**排序*/
    private Integer sort;

    private String code1;
    private String code2;
    private String code3;
    private String code4;
    private String code5;
    private String code6;
    private String code7;
    private String code8;
    private String code9;
    private String code10;

    public MachineOrderDetail() {
        super();
    }

    public MachineOrderDetail(String id){
        super(id);
    }

    public MachineOrderDetail(MachineOrder machineOrder){
        this.machineOrder = machineOrder;
    }

    public MachineOrder getMachineOrder() {
        return machineOrder;
    }

    public void setMachineOrder(MachineOrder machineOrder) {
        this.machineOrder = machineOrder;
    }

    public String getBoardRecord() {
        return boardRecord;
    }

    public void setBoardRecord(String boardRecord) {
        this.boardRecord = boardRecord;
    }

    public String getMachineRecord() {
        return machineRecord;
    }

    public void setMachineRecord(String machineRecord) {
        this.machineRecord = machineRecord;
    }

    public String getCode1() {
        return code1;
    }

    public void setCode1(String code1) {
        this.code1 = code1;
    }

    public String getCode2() {
        return code2;
    }

    public void setCode2(String code2) {
        this.code2 = code2;
    }

    public String getCode3() {
        return code3;
    }

    public void setCode3(String code3) {
        this.code3 = code3;
    }

    public String getCode4() {
        return code4;
    }

    public void setCode4(String code4) {
        this.code4 = code4;
    }

    public String getCode5() {
        return code5;
    }

    public void setCode5(String code5) {
        this.code5 = code5;
    }

    public String getCode6() {
        return code6;
    }

    public void setCode6(String code6) {
        this.code6 = code6;
    }

    public String getCode7() {
        return code7;
    }

    public void setCode7(String code7) {
        this.code7 = code7;
    }

    public String getCode8() {
        return code8;
    }

    public void setCode8(String code8) {
        this.code8 = code8;
    }

    public String getCode9() {
        return code9;
    }

    public void setCode9(String code9) {
        this.code9 = code9;
    }

    public String getCode10() {
        return code10;
    }

    public void setCode10(String code10) {
        this.code10 = code10;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }
}