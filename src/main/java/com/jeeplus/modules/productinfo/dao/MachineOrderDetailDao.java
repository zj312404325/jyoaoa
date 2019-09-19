package com.jeeplus.modules.productinfo.dao;

import com.jeeplus.common.persistence.CrudDao;
import com.jeeplus.common.persistence.annotation.MyBatisDao;
import com.jeeplus.modules.productinfo.entity.BoardOrderDetail;
import com.jeeplus.modules.productinfo.entity.MachineOrderDetail;

import java.util.List;

/**
 * 整机明细DAO接口
 * @author zj
 * @version 2019-05-27
 */
@MyBatisDao
public interface MachineOrderDetailDao extends CrudDao<MachineOrderDetail> {

}