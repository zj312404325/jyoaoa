
/**
 * Copyright &copy; 2015-2020 <a href="http://www.jeeplus.org/">JeePlus</a> All rights reserved.
 */
package com.jeeplus.modules.oaqa.service;

import com.jeeplus.common.persistence.Page;
import com.jeeplus.common.service.CrudService;
import com.jeeplus.common.utils.StringUtils;
import com.jeeplus.modules.oaqa.dao.OaanswerDao;
import com.jeeplus.modules.oaqa.entity.Oaanswer;
import com.jeeplus.modules.oaqa.entity.Oaquestion;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 问答Service
 * @author yc
 * @version 2018-03-26
 */
@Service
@Transactional(readOnly = true)
public class OaanswerService extends CrudService<OaanswerDao, Oaanswer> {

    @Autowired
    private OaanswerDao oaanswerDao;

    public Oaanswer get(String id) {
        Oaanswer oaanswer = super.get(id);
        return oaanswer;
    }

    public List<Oaanswer> findList(Oaanswer oaanswer) {
        return super.findList(oaanswer);
    }

    public Page<Oaanswer> findPage(Page<Oaanswer> page, Oaanswer oaanswer) {
        return super.findPage(page, oaanswer);
    }

}
