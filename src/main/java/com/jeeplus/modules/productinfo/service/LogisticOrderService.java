package com.jeeplus.modules.productinfo.service;

import com.jeeplus.common.persistence.Page;
import com.jeeplus.common.service.CrudService;
import com.jeeplus.common.utils.FormatUtil;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.modules.productinfo.dao.BoardOrderDao;
import com.jeeplus.modules.productinfo.dao.BoardOrderDetailDao;
import com.jeeplus.modules.productinfo.dao.LogisticOrderDao;
import com.jeeplus.modules.productinfo.dao.LogisticOrderDetailDao;
import com.jeeplus.modules.productinfo.entity.*;
import com.jeeplus.modules.sys.dao.OfficeDao;
import com.jeeplus.modules.sys.entity.User;
import com.jeeplus.modules.sys.service.PostService;
import com.jeeplus.modules.sys.utils.UserUtils;
import org.nutz.dao.Dao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 发货Service
 * @author zj
 * @version 2019-05-27
 */
@Service
@Transactional(readOnly = true,rollbackFor = Exception.class)
public class LogisticOrderService extends CrudService<LogisticOrderDao, LogisticOrder> {

    @Autowired
    private LogisticOrderDao logisticOrderDao;

    @Autowired
    private LogisticOrderDetailDao logisticOrderDetailDao;

    @Override
    public LogisticOrder get(String id) {
        LogisticOrder logisticOrder = super.get(id);
        logisticOrder.getPage().setOrderBy("a.sort asc");
        logisticOrder.setLogisticOrderDetailList(logisticOrderDetailDao.findList(new LogisticOrderDetail(logisticOrder)));
        return logisticOrder;
    }

    @Override
    public List<LogisticOrder> findList(LogisticOrder logisticOrder) {
        return super.findList(logisticOrder);
    }

    @Override
    public Page<LogisticOrder> findPage(Page<LogisticOrder> page, LogisticOrder logisticOrder) {
        return super.findPage(page, logisticOrder);
    }

    public Page<LogisticOrder> findDetailPage(Page<LogisticOrder> page, LogisticOrder logisticOrder) {
        return findPageByCode(page, logisticOrder);
    }

    @Override
    @Transactional(readOnly = false,rollbackFor = Exception.class)
    public void save(LogisticOrder logisticOrder) {
        if(!FormatUtil.isNoEmpty(logisticOrder.getId())){
            User user= UserUtils.getUser();
        }
        super.save(logisticOrder);
        int i=0;
        for (LogisticOrderDetail logisticOrderDetail : logisticOrder.getLogisticOrderDetailList()){
            if (logisticOrderDetail.getId() == null){
                continue;
            }
            if (BoardOrderDetail.DEL_FLAG_NORMAL.equals(logisticOrderDetail.getDelFlag())){
                if (StringUtils.isBlank(logisticOrderDetail.getId())){
                    logisticOrderDetail.setLogisticOrder(logisticOrder);
                    logisticOrderDetail.preInsert();
                    logisticOrderDetailDao.insert(logisticOrderDetail);
                    i++;
                }else{
                    logisticOrderDetail.setLogisticOrder(logisticOrder);
                    logisticOrderDetail.preUpdate();
                    logisticOrderDetailDao.update(logisticOrderDetail);
                    i++;
                }
            }else{
                logisticOrderDetailDao.delete(logisticOrderDetail);
            }
        }
    }


    @Override
    @Transactional(readOnly = false,rollbackFor = Exception.class)
    public void delete(LogisticOrder logisticOrder) {
        super.delete(logisticOrder);
        logisticOrderDetailDao.delete(new LogisticOrderDetail(logisticOrder));
    }

    /**
     * 查询分页数据
     * @param page 分页对象
     * @param entity
     * @return
     */
    public Page<LogisticOrder> findPageByCode(Page<LogisticOrder> page, LogisticOrder entity) {
        entity.setPage(page);
        page.setList(logisticOrderDao.findDetailList(entity));
        return page;
    }

    @Transactional(readOnly = false)
    public void save(LogisticOrderDetail logisticOrderDetail) {
        if (StringUtils.isBlank(logisticOrderDetail.getId())){
            logisticOrderDetail.preInsert();
            logisticOrderDetailDao.insert(logisticOrderDetail);
        }else{
            logisticOrderDetail.preUpdate();
            logisticOrderDetailDao.update(logisticOrderDetail);
        }
    }
}