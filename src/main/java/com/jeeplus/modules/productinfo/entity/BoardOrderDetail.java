package com.jeeplus.modules.productinfo.entity;


import com.fasterxml.jackson.annotation.JsonFormat;
import com.google.common.collect.Lists;
import com.jeeplus.common.persistence.DataEntity;
import com.jeeplus.common.utils.excel.annotation.ExcelField;
import com.jeeplus.modules.reports.entity.WeeklyReport;

import java.util.Date;
import java.util.List;


/**
 * 主板明细Entity
 * @author zj
 * @version 2019-05-27
 */
public class BoardOrderDetail extends DataEntity<BoardOrderDetail> {

    private static final long serialVersionUID = 1L;
    /**主表id 父类*/
    private BoardOrder boardOrder;
    /**主板条码记录*/
    private String boardRecord;
    /**排序*/
    private Integer sort;

    private String lable1;
    private String lable2;
    private String lable3;
    private String lable4;
    private String lable5;
    private String lable6;

    public BoardOrderDetail() {
        super();
    }

    public BoardOrderDetail(String id){
        super(id);
    }

    public BoardOrderDetail(BoardOrder boardOrder){
        this.boardOrder = boardOrder;
    }

    public BoardOrder getBoardOrder() {
        return boardOrder;
    }

    public void setBoardOrder(BoardOrder boardOrder) {
        this.boardOrder = boardOrder;
    }

    public String getBoardRecord() {
        return boardRecord;
    }

    public void setBoardRecord(String boardRecord) {
        this.boardRecord = boardRecord;
    }

    public String getLable1() {
        return lable1;
    }

    public void setLable1(String lable1) {
        this.lable1 = lable1;
    }

    public String getLable2() {
        return lable2;
    }

    public void setLable2(String lable2) {
        this.lable2 = lable2;
    }

    public String getLable3() {
        return lable3;
    }

    public void setLable3(String lable3) {
        this.lable3 = lable3;
    }

    public String getLable4() {
        return lable4;
    }

    public void setLable4(String lable4) {
        this.lable4 = lable4;
    }

    public String getLable5() {
        return lable5;
    }

    public void setLable5(String lable5) {
        this.lable5 = lable5;
    }

    public String getLable6() {
        return lable6;
    }

    public void setLable6(String lable6) {
        this.lable6 = lable6;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }
}
