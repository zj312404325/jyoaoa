package com.jeeplus.modules.productinfo.dao;

import com.jeeplus.common.persistence.CrudDao;
import com.jeeplus.common.persistence.annotation.MyBatisDao;
import com.jeeplus.modules.productinfo.entity.BoardOrder;
import java.util.List;

/**
 * 主板信息DAO接口
 * @author zj
 * @version 2019-05-27
 */
@MyBatisDao
public interface BoardOrderDao extends CrudDao<BoardOrder> {

}
