package com.jeeplus.modules.productinfo.dao;

import com.jeeplus.common.persistence.CrudDao;
import com.jeeplus.common.persistence.annotation.MyBatisDao;
import com.jeeplus.modules.productinfo.entity.BoardOrder;
import com.jeeplus.modules.productinfo.entity.MachineOrder;

import java.util.List;

/**
 * 整机信息DAO接口
 * @author zj
 * @version 2019-05-27
 */
@MyBatisDao
public interface MachineOrderDao extends CrudDao<MachineOrder> {
    /**
     * 根据codeNo查找整机信息列表
     * @param machineOrder
     * @return List<MachineOrder>
     */
    public List<MachineOrder> findDetailList(MachineOrder machineOrder);
}