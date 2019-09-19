package com.jeeplus.modules.productinfo.service;

import com.jeeplus.common.persistence.Page;
import com.jeeplus.common.service.CrudService;
import com.jeeplus.common.utils.FormatUtil;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.modules.productinfo.dao.BoardOrderDao;
import com.jeeplus.modules.productinfo.dao.BoardOrderDetailDao;
import com.jeeplus.modules.productinfo.entity.BoardOrder;
import com.jeeplus.modules.productinfo.entity.BoardOrderDetail;
import com.jeeplus.modules.sys.dao.OfficeDao;
import com.jeeplus.modules.sys.entity.User;
import com.jeeplus.modules.sys.service.PostService;
import com.jeeplus.modules.sys.utils.UserUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 主板Service
 * @author zj
 * @version 2019-05-27
 */
@Service
@Transactional(readOnly = true,rollbackFor = Exception.class)
public class BoardOrderService extends CrudService<BoardOrderDao, BoardOrder> {

    @Autowired
    private BoardOrderDetailDao boardOrderDetailDao;

    @Autowired
    private OfficeDao officeDao;

    @Autowired
    private PostService postService;

    @Override
    public BoardOrder get(String id) {
        BoardOrder boardOrder = super.get(id);
        boardOrder.getPage().setOrderBy("a.sort asc");
        boardOrder.setBoardOrderDetailList(boardOrderDetailDao.findList(new BoardOrderDetail(boardOrder)));
        return boardOrder;
    }

    @Override
    public List<BoardOrder> findList(BoardOrder boardOrder) {
        return super.findList(boardOrder);
    }

    @Override
    public Page<BoardOrder> findPage(Page<BoardOrder> page, BoardOrder boardOrder) {
        return super.findPage(page, boardOrder);
    }

    @Override
    @Transactional(readOnly = false,rollbackFor = Exception.class)
    public void save(BoardOrder boardOrder) {
        if(!FormatUtil.isNoEmpty(boardOrder.getId())){
            User user= UserUtils.getUser();
        }
        super.save(boardOrder);
        int i=0;
        for (BoardOrderDetail boardOrderDetail : boardOrder.getBoardOrderDetailList()){
            if (boardOrderDetail.getId() == null){
                continue;
            }
            if (BoardOrderDetail.DEL_FLAG_NORMAL.equals(boardOrderDetail.getDelFlag())){
                if (StringUtils.isBlank(boardOrderDetail.getId())){
                    boardOrderDetail.setBoardOrder(boardOrder);
                    boardOrderDetail.preInsert();
                    boardOrderDetailDao.insert(boardOrderDetail);
                    i++;
                }else{
                    boardOrderDetail.setBoardOrder(boardOrder);
                    boardOrderDetail.preUpdate();
                    boardOrderDetailDao.update(boardOrderDetail);
                    i++;
                }
            }else{
                boardOrderDetailDao.delete(boardOrderDetail);
            }
        }
    }


    @Override
    @Transactional(readOnly = false,rollbackFor = Exception.class)
    public void delete(BoardOrder boardOrder) {
        super.delete(boardOrder);
        boardOrderDetailDao.delete(new BoardOrderDetail(boardOrder));
    }

}