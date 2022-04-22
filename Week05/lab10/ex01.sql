--------------TASK 1
--------------PART 1
drop TABLE IF EXISTS accounts;

CREATE TABLE IF NOT EXISTS accounts (
            id serial primary key,
            name varchar(255),
            credit int,
            currency varchar(3)
        );

INSERT INTO accounts (name, credit, currency)
        VALUES ('A1', 1000, 'RUB'),
        ('A2', 1000, 'RUB'),
        ('A3', 1000, 'RUB');

select * from accounts;

CREATE OR REPLACE PROCEDURE transfer(_from_account_id int, _to_account_id int, _amount int)
LANGUAGE plpgsql
AS $$
begin
UPDATE accounts
    SET credit = credit - _amount
	WHERE id = _from_account_id;
UPDATE accounts
	SET credit = credit + _amount
	WHERE id = _to_account_id;
end $$;

begin;
savepoint rollback1;
call transfer(1,3,500);
call transfer(2,1,700);
call transfer(2,3,100);
select * from accounts;
--id|name|credit|currency|
----+----+------+--------+
-- 1|A1  |  1200|RUB     |
-- 2|A2  |   200|RUB     |
-- 3|A3  |  1600|RUB     |
rollback to rollback1;
select * from accounts;
--id|name|credit|currency|
----+----+------+--------+
-- 1|A1  |  1000|RUB     |
-- 2|A2  |  1000|RUB     |
-- 3|A3  |  1000|RUB     |

--------------PART 2
drop TABLE IF EXISTS accounts;

CREATE TABLE IF NOT EXISTS accounts (
            id serial primary key,
            name varchar(255),
            credit int,
            currency varchar(3),
            bankName varchar(255)
        );

INSERT INTO accounts (name, credit, currency, bankName)
        VALUES ('A1', 1000, 'RUB', 'SberBank'),
        ('A2', 1000, 'RUB', 'Tinkoff'),
        ('A3', 1000, 'RUB', 'SberBank'),
        ('FeeAccount', 0, 'RUB', 'FeeBank');

select * from accounts;
CREATE OR REPLACE PROCEDURE transfer2(_from_account_id int, _to_account_id int, _amount int)
LANGUAGE plpgsql
AS $$
declare
fee INTEGER = 0;
fromBank varchar(255);
toBank varchar(255);
begin
	SELECT INTO fromBank bankName FROM accounts WHERE id=_from_account_id;
	SELECT INTO toBank bankName FROM accounts WHERE id=_to_account_id;
  IF fromBank != toBank THEN
   fee := 30;
  END IF;
UPDATE accounts
    SET credit = credit - _amount - fee
	WHERE id = _from_account_id;
UPDATE accounts
	SET credit = credit + _amount
	WHERE id = _to_account_id;
UPDATE accounts
	SET credit = credit + fee
	WHERE id = 4;
end $$;

begin;
savepoint rollback2;
call transfer2(1,3,500);
call transfer2(2,1,700);
call transfer2(2,3,100);
select * from accounts;
--id|name      |credit|currency|bankname|
----+----------+------+--------+--------+
-- 1|A1        |  1200|RUB     |SberBank|
-- 2|A2        |   140|RUB     |Tinkoff |
-- 3|A3        |  1600|RUB     |SberBank|
-- 4|FeeAccount|    60|RUB     |FeeBank |
rollback to rollback2;
select * from accounts;
--id|name      |credit|currency|bankname|
----+----------+------+--------+--------+
-- 1|A1        |  1000|RUB     |SberBank|
-- 2|A2        |  1000|RUB     |Tinkoff |
-- 3|A3        |  1000|RUB     |SberBank|
-- 4|FeeAccount|     0|RUB     |FeeBank |

--------------PART 3
CREATE TABLE IF NOT EXISTS ledger (
            id serial primary key,
            from_account_id int references accounts(id),
            to_account_id int references accounts(id),
            fee int,
            amount int,
            transaction_datetime timestamp
        );

CREATE OR REPLACE PROCEDURE transfer3(_from_account_id int, _to_account_id int, _amount int)
LANGUAGE plpgsql
AS $$
declare
fee INTEGER = 0;
fromBank varchar(255);
toBank varchar(255);
begin
	SELECT INTO fromBank bankName FROM accounts WHERE id=_from_account_id;
	SELECT INTO toBank bankName FROM accounts WHERE id=_to_account_id;
  IF fromBank != toBank THEN
   fee := 30;
  END IF;
UPDATE accounts
    SET credit = credit - _amount - fee
	WHERE id = _from_account_id;
UPDATE accounts
	SET credit = credit + _amount
	WHERE id = _to_account_id;
UPDATE accounts
	SET credit = credit + fee
	WHERE id = 4;
INSERT INTO ledger (from_account_id, to_account_id, fee, amount, transaction_datetime)
        values (_from_account_id, _to_account_id, fee, _amount, now());
end $$;

begin;
savepoint rollback3;
call transfer3(1,3,500);
call transfer3(2,1,700);
call transfer3(2,3,100);
select * from accounts;
--id|name      |credit|currency|bankname|
----+----------+------+--------+--------+
-- 1|A1        |  1200|RUB     |SberBank|
-- 2|A2        |   140|RUB     |Tinkoff |
-- 3|A3        |  1600|RUB     |SberBank|
-- 4|FeeAccount|    60|RUB     |FeeBank |
select * from ledger;
--id|from_account_id|to_account_id|fee|amount|transaction_datetime   |
----+---------------+-------------+---+------+-----------------------+
-- 1|              1|            3|  0|   500|2022-04-22 15:45:40.829|
-- 2|              2|            1| 30|   700|2022-04-22 15:45:40.829|
-- 3|              2|            3| 30|   100|2022-04-22 15:45:40.829|

rollback to rollback3;
select * from accounts;
--id|name      |credit|currency|bankname|
----+----------+------+--------+--------+
-- 1|A1        |  1000|RUB     |SberBank|
-- 2|A2        |  1000|RUB     |Tinkoff |
-- 3|A3        |  1000|RUB     |SberBank|
-- 4|FeeAccount|     0|RUB     |FeeBank |
select * from ledger;
--id|from_account_id|to_account_id|fee|amount|transaction_datetime|
----+---------------+-------------+---+------+--------------------+
