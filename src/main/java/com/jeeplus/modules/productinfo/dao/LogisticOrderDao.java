package com.jeeplus.modules.productinfo.dao;

import com.jeeplus.common.persistence.CrudDao;
import com.jeeplus.common.persistence.annotation.MyBatisDao;
import com.jeeplus.modules.productinfo.entity.BoardOrder;
import com.jeeplus.modules.productinfo.entity.LogisticOrder;
import com.jeeplus.modules.productinfo.entity.MachineOrder;

import java.util.List;

/**
 * 物流信息DAO接口
 * @author zj
 * @version 2019-05-27
 */
@MyBatisDao
public interface LogisticOrderDao extends CrudDao<LogisticOrder> {
    /**
     * 根据codeNo查找发货单信息列表
     * @param logisticOrder
     * @return List<LogisticOrder>
     */
    public List<LogisticOrder> findDetailList(LogisticOrder logisticOrder);
}