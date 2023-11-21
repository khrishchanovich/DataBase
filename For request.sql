delimiter 
//
create trigger trg_after_insert_user_admin
after insert on user
for each row
begin
	if new.Status = 'Admin' then
		insert ignore into admin (UserId) values (new.Id);
	end if;
end;
// 
delimiter ;

insert into user (username, email, password, name, surname, status) 
values ('user21', 'user21@ins.com', 'F0C77E3F', 'Ken', 'Wilson', 'Admin')