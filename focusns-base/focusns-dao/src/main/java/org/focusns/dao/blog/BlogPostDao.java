/*
 * Copyright (C) 2012 FocuSNS.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301  USA
 */
package org.focusns.dao.blog;

import org.focusns.dao.common.BaseDao;
import org.focusns.model.blog.BlogPost;
import org.focusns.model.common.Page;

public interface BlogPostDao extends BaseDao<BlogPost> {

    Page<BlogPost> fetchByTagId(Page<BlogPost> page, long tagId);

    Page<BlogPost> fetchByProjectId(Page<BlogPost> page, long projectId);
    
}