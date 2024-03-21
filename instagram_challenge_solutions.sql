----------------------------------
-- INSTRAGRAM DATABASE CLONE CHALLENGE --
----------------------------------

-- Author: Moses Tega Ziregbe 
-- Tool used: MySQL Server
--------------------------

-- We want to reward our users who have been around the longest.  
-- 1. Find the 5 oldest users.

SELECT 
    id,
    username,
    CONCAT(DATEDIFF(CURDATE(), created_at), ' days') AS days_after_signup
FROM users
ORDER BY days_after_signup DESC
LIMIT 5;



-- 2. What day of the week do most users register on?
-- We need to figure out when to schedule an ad campgain

SELECT 
    DAYNAME(created_at) AS day_of_week,
    COUNT(*) AS count
FROM users
GROUP BY day_of_week
ORDER BY count DESC
LIMIT 2;




-- We want to target our inactive users with an email campaign.
-- 3. Find the users who have never posted a photo

SELECT 
    users.id, 
    username, 
    COUNT(image_url) AS total_photos_posted
FROM users
LEFT JOIN photos ON users.id = photos.user_id
GROUP BY username
HAVING total_photos_posted = 0;

-- OR

SELECT users.id, username FROM users
LEFT JOIN photos
ON users.id = photos.user_id
WHERE photos.id IS NULL;



-- 4. We're running a new contest to see who can get the most likes 
-- on a single photo. WHO WON??!!


SELECT 
    username,
    photos.id,
    photos.image_url,
    COUNT(*) AS total_likes
FROM photos
INNER JOIN likes 
ON likes.photo_id = photos.id
INNER JOIN users 
ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY total_likes DESC
LIMIT 1;



-- 5. Our Investors want to know... How many times does the average user post?

-- Calculate avergae number of photos per users
-- total number of phots / total number of users

SELECT 
	(SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users) 
    AS Average_no_of_posts;
    
    

-- 6. A brand wants to know which hashtags to use in a post
-- What are the top 5 most commonly used hashtags?

-- Five Most popular hastags
-- Group them by tags.id

SELECT 
    tags.tag_name, 
    COUNT(*) AS total
FROM
    photo_tags
JOIN tags 
ON photo_tags.tag_id = tags.id
GROUP BY tags.id
ORDER BY total DESC
LIMIT 5;



-- 7. We have a small problem with bots on our site...
-- Find users who have liked every single photo on the site

SELECT 
    username, 
    user_id, 
    COUNT(*) AS num_likes
FROM users
INNER JOIN likes 
ON users.id = likes.user_id
GROUP BY likes.user_id
HAVING num_likes = (SELECT COUNT(*) FROM photos);

