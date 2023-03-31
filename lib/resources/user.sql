use gpt;
drop table if exists user;
CREATE TABLE user (
                      userId INT NOT NULL AUTO_INCREMENT,
                      username VARCHAR(255) NOT NULL,
                      password VARCHAR(255) NOT NULL,
                      current_key varchar(13) ,
                      key_token long,
                      totalToken long,
                      PRIMARY KEY (userId)
);
# update user set username=?,password=?,current_key=?,key_token=?,totalToken=?
insert into user(userId, username, password, current_key, key_token, totalToken) VALUE ();
select * from user;