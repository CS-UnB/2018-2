-- USER QUERIES

-- Get user with ID:
SELECT * FROM Users
WHERE UserId = 0;

-- Get user postings:
SELECT p.* FROM User_Platform u INNER JOIN Posts p
    ON p.PostId = u.UserId
WHERE p.UserName LIKE ''


