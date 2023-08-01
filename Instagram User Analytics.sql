## Rewarding Most Loyal Users
SELECT * from users
ORDER BY created_at 
limit 5;

## Remind Inactive Users to Start Posting.

SELECT users.username, photos.id as Photo_id
FROM users
LEFT JOIN photos
ON users.id = photos.user_id
WHERE photos.id is NULL;

## Declaring Contest Winner.

SELECT  users.username, photo_id, count(*)  as total_likes 
FROM photos
INNER JOIN likes
ON photos.id = likes.photo_id
INNER JOIN users
ON photos.user_id = users.id
GROUP BY photo_id
ORDER BY total_likes desc
LIMIT 1;

## Hashtag Researching.

SELECT tag_name, tag_id, count(*) as total FROM tags
INNER JOIN photo_tags
ON photo_tags.tag_id = tags.id
GROUP BY tag_id
ORDER BY total desc
LIMIT 5;

## Launch AD Campaign.

SELECT count(*) as Reg_users, extract(day from created_at) as Days FROM users 
GROUP BY Days
ORDER BY Reg_users desc;

## User Engagement.

SELECT 
    MAX(user_id), SUM(total)
FROM
    (SELECT 
        username, user_id, COUNT(*) AS total
    FROM
        users
    INNER JOIN photos ON users.id = photos.user_id
    GROUP BY user_id
    ORDER BY total DESC) AS User_engagement; 

## Bots & Fake Accounts. 

SELECT  username, count(*) as total_likes FROM likes
INNER JOIN users
ON users.id = likes.user_id
GROUP BY username
ORDER BY total_likes desc;




  



