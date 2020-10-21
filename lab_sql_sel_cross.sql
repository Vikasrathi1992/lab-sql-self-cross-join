USE sakila;

## 1.Get all pairs of actors that worked together.
select * from actor;
select * from film_actor;

select a1.actor_id, concat(an1.first_name,' ',an1.last_name) as actor_1, a2.actor_id, concat(an2.first_name,' ',an2.last_name) as actor_2 from sakila.film_actor as a1
join sakila.film_actor as a2 on a2.film_id = a1.film_id and a1.actor_id < a2.actor_id
join sakila.actor as an1 on an1.actor_id = a1.actor_id
join sakila.actor as an2 on an2.actor_id = a2.actor_id
group by a1.actor_id, a2.actor_id
order by a1.actor_id, a2.actor_id;



## 2.Get all pairs of customers that have rented the same film more than 3 times.

# create temporary table customer1
select r.customer_id,i.film_id, count(*) as times_rented_per_customer  from sakila.rental as r
join sakila.inventory as i on r.inventory_id = i.inventory_id
group by r.customer_id, i.film_id;

# create temporary table customer2
select r.customer_id,i.film_id, count(*) as times_rented_per_customer  from sakila.rental as r
join sakila.inventory as i on r.inventory_id = i.inventory_id
group by r.customer_id, i.film_id;

select c1.film_id, f.title, c1.customer_id, c2.customer_id, c1.times_rented_per_customer+c2.times_rented_per_customer as combined_rentals from sakila.customer1 as c1
join sakila.customer2 as c2 on c1.film_id = c2.film_id and c1.customer_id < c2.customer_id
join sakila.film as f on f.film_id = c1.film_id
having combined_rentals > 3 
order by combined_rentals desc;



## 3.Get all possible pairs of actors and films.

create temporary table actor_film_temp
select concat(a.first_name,' ',a.last_name) as actor from sakila.film_actor as fa
join sakila.actor as a using(actor_id)
join sakila.film as f on f.film_id = fa.film_id
order by actor_id;

create temporary table film_actor_temp
select f.title as film from sakila.film_actor as fa
join sakila.actor as a using(actor_id)
join sakila.film as f on f.film_id = fa.film_id
order by actor_id;

select * from actor_film_temp as t1
cross join film_actor_temp as t2
group by t1.actor, t2.film;
