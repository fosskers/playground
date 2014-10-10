-- Choose your DB
use products;

-- Inserting
insert into products (maker, model, p_type)
values ("c", "1100", "pc");

-- PC(model,maker)
-- Laptop(model,maker)
-- Printer(model,maker)
-- Delete laptops made by Makers who don't make printers.
delete from laptops
where maker not in (
      -- Makers of printers.
      select distinct maker from printer
);

---

create trigger AvgLappy
after update of price on laptop
referencing old table as OT
            new table as NT
for each statement
when (1500 >= (select avg(price) from laptop))
begin
    delete from laptop where (... in NT)
    insert into laptop (select * from OT)
