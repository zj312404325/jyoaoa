package com.jeeplus.modules.productinfo.entity;

import com.jeeplus.common.persistence.DataEntity;


/**
 * 主板明细Entity
 * @author zj
 * @version 2019-05-27
 */
public class LogisticOrderDetail extends DataEntity<LogisticOrderDetail> {

    private static final long serialVersionUID = 1L;
    /**主表id 父类*/
    private LogisticOrder logisticOrder;
    /**产品条码记录*/
    private String prodRecord;
    /**排序*/
    private Integer sort;

    public LogisticOrderDetail() {
        super();
    }

    public LogisticOrderDetail(String id){
        super(id);
    }

    public LogisticOrderDetail(LogisticOrder logisticOrder){
        this.logisticOrder = logisticOrder;
    }

    public LogisticOrder getLogisticOrder() {
        return logisticOrder;
    }

    public void setLogisticOrder(LogisticOrder logisticOrder) {
        this.logisticOrder = logisticOrder;
    }

    public String getProdRecord() {
        return prodRecord;
    }

    public void setProdRecord(String prodRecord) {
        this.prodRecord = prodRecord;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }
}