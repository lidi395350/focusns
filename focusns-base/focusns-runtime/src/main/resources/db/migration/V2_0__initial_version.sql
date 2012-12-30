/**
 * Core
 */
DROP TABLE IF EXISTS TB_USER;

CREATE TABLE TB_USER (
	`ID` BIGINT NOT NULL AUTO_INCREMENT ,
	`USERNAME` VARCHAR(100) NOT NULL ,
	`PASSWORD` VARCHAR(100) NOT NULL ,
	`EMAIL` VARCHAR(100) NOT NULL ,
    `PROJECT_ID` BIGINT ,
	PRIMARY KEY (`ID`) ,
    UNIQUE INDEX `USERNAME_UNIQUE` (`USERNAME`) ,
    UNIQUE INDEX `EMAIL_UNIQUE` (`EMAIL`)
);

DROP TABLE IF EXISTS TB_PROJECT_CATEGORY;

CREATE TABLE TB_PROJECT_CATEGORY (
	`ID` BIGINT NOT NULL AUTO_INCREMENT ,
	`CODE` VARCHAR(100) NOT NULL ,
    `LABEL` VARCHAR(100) NOT NULL ,
    `ENABLED` BOOLEAN DEFAULT TRUE ,
    `PRIVATE` BOOLEAN DEFAULT FALSE ,
    `LEVEL` INT DEFAULT 0 ,
	PRIMARY KEY (`ID`) ,
	UNIQUE INDEX `CODE_UNIQUE` (`CODE`)
);

DROP TABLE IF EXISTS TB_PROJECT;

CREATE TABLE TB_PROJECT (
	`ID` BIGINT NOT NULL AUTO_INCREMENT ,
	`CODE` VARCHAR(100) NOT NULL ,
	`TITLE` VARCHAR(100) NOT NULL ,
	`DESCRIPTION` VARCHAR(255) NOT NULL ,
	`CREATE_AT` TIMESTAMP NOT NULL ,
	`MODIFY_AT` TIMESTAMP NOT NULL ,
	`CREATE_BY_ID` BIGINT NOT NULL ,
	`MODIFY_BY_ID` BIGINT NOT NULL ,
	`CATEGORY_ID` BIGINT NOT NULL ,
	`PRIVATE` BOOLEAN DEFAULT FALSE ,
	PRIMARY KEY (`ID`) , 
	UNIQUE INDEX `CODE_UNIQUE` (`CODE`) ,
	CONSTRAINT FK_CREATE_BY_ID_TB_PROJECT FOREIGN KEY (`CREATE_BY_ID`) REFERENCES TB_USER(`ID`) ,
	CONSTRAINT FK_MODIFY_BY_ID_TB_PROJECT FOREIGN KEY (`MODIFY_BY_ID`) REFERENCES TB_USER(`ID`) ,
	CONSTRAINT FK_CATEGORY_ID_TB_PROJECT FOREIGN KEY (`CATEGORY_ID`) REFERENCES TB_PROJECT_CATEGORY(`ID`)
);

DROP TABLE IF EXISTS TB_PROJECT_FEATURE;

CREATE TABLE TB_PROJECT_FEATURE (
	`ID` INT NOT NULL AUTO_INCREMENT ,
	`CODE` VARCHAR(100) NOT NULL ,
	`LABEL` VARCHAR(100) NOT NULL ,
	`LEVEL` INT NOT NULL DEFAULT 0,
	`ENABLED` BOOLEAN NOT NULL ,
	`PROJECT_ID` BIGINT NOT NULL ,
	PRIMARY KEY (`ID`) ,
	UNIQUE INDEX `CODE_UNIQUE` (`CODE`) ,
	CONSTRAINT FK_PROJECT_ID_TB_PROJECT_FEATURE FOREIGN KEY (`PROJECT_ID`) REFERENCES TB_PROJECT(`ID`)
);

DROP TABLE IF EXISTS TB_PROJECT_ATTRIBUTE;

CREATE TABLE TB_PROJECT_ATTRIBUTE (
	`ID` BIGINT NOT NULL AUTO_INCREMENT ,
	`NAME` VARCHAR(50) NOT NULL ,
	`VALUE` VARCHAR(255) NOT NULL ,
	`TYPE` VARCHAR(50) NOT NULL DEFAULT "" ,
    `LEVEL` INT DEFAULT 0 ,
	`PROJECT_ID` BIGINT NOT NULL ,
	PRIMARY KEY (`ID`) , 
	CONSTRAINT FK_PROJECT_ID_TB_PROJECT_ATTRIBUTE FOREIGN KEY (`PROJECT_ID`) REFERENCES TB_PROJECT(`ID`)
);

DROP TABLE IF EXISTS TB_PROJECT_HISTROY;

CREATE TABLE TB_PROJECT_HISTROY (
	`ID` BIGINT NOT NULL AUTO_INCREMENT ,
	`CONTENT` VARCHAR(255) NOT NULL ,
	`CREATE_AT` TIMESTAMP NOT NULL ,
	`PROJECT_ID` BIGINT NOT NULL ,
    `CREATE_BY_ID` BIGINT NOT NULL ,
    `TARGET_ID` BIGINT NOT NULL ,
    `TARGET_TYPE` VARCHAR(255) NOT NULL ,
	PRIMARY KEY (`ID`) , 
	CONSTRAINT FK_PROJECT_ID_TB_PROJECT_HISTROY FOREIGN KEY (`PROJECT_ID`) REFERENCES TB_PROJECT(`ID`) ,
    CONSTRAINT FK_CREATE_BY_ID_TB_PROJECT_HISTROY FOREIGN KEY (`CREATE_BY_ID`) REFERENCES TB_USER(`ID`)
);

DROP TABLE IF EXISTS TB_PROJECT_LOGO;

CREATE TABLE TB_PROJECT_LOGO (
    `ID` BIGINT NOT NULL AUTO_INCREMENT ,
	`TITLE` VARCHAR(100) NOT NULL ,
    `IMAGE` VARCHAR(200) NOT NULL ,
    `PROJECT_ID` BIGINT NOT NULL ,
    PRIMARY KEY (`ID`) ,
    CONSTRAINT FK_PROJECT_ID_TB_PROJECT_HISTROY FOREIGN KEY (`PROJECT_ID`) REFERENCES TB_PROJECT(`ID`) ,
);

DROP TABLE IF EXISTS TB_PROJECT_LINK;

CREATE TABLE TB_PROJECT_LINK (
	`ID` BIGINT NOT NULL AUTO_INCREMENT ,
	`FROM_PROJECT_ID` BIGINT NOT NULL ,
    `TO_PROJECT_ID` BIGINT NOT NULL ,
    `MUTUAL` BOOLEAN DEFAULT FALSE ,
	PRIMARY KEY (`ID`) ,
    CONSTRAINT FK_FROM_PROJECT_ID_TB_PROJECT_LINK FOREIGN KEY (`FROM_PROJECT_ID`) REFERENCES TB_PROJECT(`ID`) ,
    CONSTRAINT FK_TO_PROJECT_ID_TB_PROJECT_LINK FOREIGN KEY (`TO_PROJECT_ID`) REFERENCES TB_PROJECT(`ID`)
);

/**
 * Blog
 */
DROP TABLE IF EXISTS TB_BLOG_CATEGORY;

CREATE TABLE TB_BLOG_CATEGORY (
	`ID` BIGINT NOT NULL AUTO_INCREMENT ,
	`NAME` VARCHAR(100) NOT NULL ,
    `PROJECT_ID` BIGINT NOT NULL ,
	PRIMARY KEY (`ID`) ,
    CONSTRAINT FK_PROJECT_ID_TB_BLOG_CATEGORY FOREIGN KEY (`PROJECT_ID`) REFERENCES TB_PROJECT(`ID`)
);

DROP TABLE IF EXISTS TB_BLOG_POST;

CREATE TABLE TB_BLOG_POST (
	`ID` BIGINT NOT NULL AUTO_INCREMENT ,
	`TITLE` VARCHAR(100) NOT NULL ,
    `CONTENT` TEXT NOT NULL ,
    `CREATE_AT` TIMESTAMP NOT NULL ,
	`MODIFY_AT` TIMESTAMP NOT NULL ,
    `TAG_ID` BIGINT NOT NULL ,
    `CREATE_BY_ID` BIGINT NOT NULL ,
	PRIMARY KEY (`ID`) ,
    CONSTRAINT FK_TAG_ID_TB_BLOG_POST FOREIGN KEY (`TAG_ID`) REFERENCES TB_BLOG_CATEGORY(`ID`) ,
    CONSTRAINT FK_CREATE_BY_ID_TB_BLOG_POST FOREIGN KEY (`CREATE_BY_ID`) REFERENCES TB_USER(`ID`)
);

DROP TABLE IF EXISTS TB_BLOG_COMMENT;

CREATE TABLE TB_BLOG_COMMENT (
	`ID` BIGINT NOT NULL AUTO_INCREMENT ,
	`TITLE` VARCHAR(100) NOT NULL ,
    `CONTENT` TEXT NOT NULL ,
    `CREATE_AT` TIMESTAMP NOT NULL ,
	`MODIFY_AT` TIMESTAMP NOT NULL ,
    `POST_ID` BIGINT NOT NULL ,
    `CREATE_BY_ID` BIGINT NOT NULL ,
	PRIMARY KEY (`ID`) ,
    CONSTRAINT FK_POST_ID_TB_BLOG_COMMENT FOREIGN KEY (`POST_ID`) REFERENCES TB_BLOG_POST(`ID`) ,
    CONSTRAINT FK_CREATE_BY_ID_TB_BLOG_COMMENT FOREIGN KEY (`CREATE_BY_ID`) REFERENCES TB_USER(`ID`)
);

/**
 * Initial Data
 */
drop procedure if exists init_db;

delimiter //
create procedure init_db()
    begin
        # declare variables
        declare userId, categoryId, projectId bigint;
        #
        insert into tb_user(username, password, email)
            values ('admin', 'admin', 'admin@focusns.org');
        insert into tb_project_category(code, label, enabled, private, `level`)
            values ('people', '成员', true, false, 0);
        # select userId and categoryId
        select id into userId from tb_user where username = 'admin';
        select id into categoryId from tb_project_category where code = 'people';
        
        insert into tb_project (code, title, description, create_at, modify_at, 
                                create_by_id, modify_by_id, category_id, private)
            values ('admin', 'Admin', 'This is admin!', now(), now(), userId, 
                    userId, categoryId, true);
        # select projectId
        select id into projectId from tb_project where code = 'admin';
        # update user
        update tb_user set project_id = projectId where id = userId;
        
        insert into tb_project_feature (code, label, `level`, enabled, project_id)
            values('profile', '主页', 0, true, projectId);
        insert into tb_project_feature (code, label, `level`, enabled, project_id)
            values('blog', '博客', 5, true, projectId);
        insert into tb_project_feature (code, label, `level`, enabled, project_id)
            values('photo', '相册', 10, true, projectId);
        insert into tb_project_feature (code, label, `level`, enabled, project_id)
            values('team', '关系', 15, true, projectId);
        insert into tb_project_feature (code, label, `level`, enabled, project_id)
            values('message', '私信', 20, true, projectId);
        insert into tb_project_feature (code, label, `level`, enabled, project_id)
            values('admin', '管理', 25, true, projectId);
    end //
delimiter ;

call init_db();