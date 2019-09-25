package com.jeeplus.modules.productinfo.service;

import com.jeeplus.common.persistence.Page;
import com.jeeplus.common.service.CrudService;
import com.jeeplus.common.utils.FormatUtil;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.modules.productinfo.dao.MachineOrderDao;
import com.jeeplus.modules.productinfo.dao.MachineOrderDetailDao;
import com.jeeplus.modules.productinfo.entity.*;
import com.jeeplus.modules.sys.entity.User;
import com.jeeplus.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


/**
 * 整机Service
 * @author zj
 * @version 2019-05-27
 */
@Service
@Transactional(readOnly = true,rollbackFor = Exception.class)
public class MachineOrderService extends CrudService<MachineOrderDao, MachineOrder> {

    @Autowired
    private MachineOrderDao machineOrderDao;

    @Autowired
    private MachineOrderDetailDao machineOrderDetailDao;

    @Override
    public MachineOrder get(String id) {
        MachineOrder machineOrder = super.get(id);
        machineOrder.getPage().setOrderBy("a.sort asc");
        machineOrder.setMachineOrderDetailList(machineOrderDetailDao.findList(new MachineOrderDetail(machineOrder)));
        return machineOrder;
    }

    @Override
    public List<MachineOrder> findList(MachineOrder machineOrder) {
        return super.findList(machineOrder);
    }

    @Override
    public Page<MachineOrder> findPage(Page<MachineOrder> page, MachineOrder machineOrder) {
        return super.findPage(page, machineOrder);
    }

    public Page<MachineOrder> findDetailPage(Page<MachineOrder> page, MachineOrder machineOrder) {
        return findPageByCode(page, machineOrder);
    }

    @Override
    @Transactional(readOnly = false,rollbackFor = Exception.class)
    public void save(MachineOrder machineOrder) {
        if(!FormatUtil.isNoEmpty(machineOrder.getId())){
            User user= UserUtils.getUser();
        }
        super.save(machineOrder);
        int i=0;
        for (MachineOrderDetail machineOrderDetail : machineOrder.getMachineOrderDetailList()){
            if (machineOrderDetail.getId() == null){
                continue;
            }
            if (BoardOrderDetail.DEL_FLAG_NORMAL.equals(machineOrderDetail.getDelFlag())){
                if (StringUtils.isBlank(machineOrderDetail.getId())){
                    machineOrderDetail.setMachineOrder(machineOrder);
                    machineOrderDetail.preInsert();
                    machineOrderDetailDao.insert(machineOrderDetail);
                    i++;
                }else{
                    machineOrderDetail.setMachineOrder(machineOrder);
                    machineOrderDetail.preUpdate();
                    machineOrderDetailDao.update(machineOrderDetail);
                    i++;
                }
            }else{
                machineOrderDetailDao.delete(machineOrderDetail);
            }
        }
    }


    @Override
    @Transactional(readOnly = false,rollbackFor = Exception.class)
    public void delete(MachineOrder machineOrder) {
        super.delete(machineOrder);
        machineOrderDetailDao.delete(new MachineOrderDetail(machineOrder));
    }

    /**
     * 查询分页数据
     * @param page 分页对象
     * @param entity
     * @return
     */
    public Page<MachineOrder> findPageByCode(Page<MachineOrder> page, MachineOrder entity) {
        entity.setPage(page);
        page.setList(machineOrderDao.findDetailList(entity));
        return page;
    }

    @Transactional(readOnly = false)
    public void save(MachineOrderDetail machineOrderDetail) {
        if (StringUtils.isBlank(machineOrderDetail.getId())){
            machineOrderDetail.preInsert();
            machineOrderDetailDao.insert(machineOrderDetail);
        }else{
            machineOrderDetail.preUpdate();
            machineOrderDetailDao.update(machineOrderDetail);
        }
    }
}