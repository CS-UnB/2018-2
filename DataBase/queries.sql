-- USER QUERIES

-- Get user with ID:
SELECT * FROM Users
WHERE UserId = 0;

-- Get user postings:
SELECT p.* FROM User_Platform u INNER JOIN Posts p
    ON p.PostId = u.UserId
WHERE p.UserName LIKE '';

-- Get Users from city X (WARNING: 1):
-- -- first get the city id <Y> of the city with name <X>
   SELECT CityId FROM City
   WHERE CityDescription="<X>";
-- -- then get the Users related with that city ID
   SELECT Username FROM Users
   WHERE UserCity_id=<Y>;

-- (talvez devessemos acrescentar um UserId na tabela City)




-- POSTS QUERYS

-- Get posts with more than x likes or y shares
-- (é importante saber quais os posts mais populares, pois eles são um reflexo da comunidade)
SELECT PostText FROM Posts
WHERE Shares>=x OR PostLikes>=y;

-- Get posts with negative emotions
-- (saber da existencia de posts com sentimentos negativos é o primeiro passo para ajudar)
SELECT PostText FROM Posts WHERE
Emotion='Sadness' OR Emotion='Hate';

-- Talvez devessemos acrescentar a coluna User_Id ou UserName na tabela Posts





-- FEATURES QUERYS (WARNING: 3)

-- Get the numbers on Feature Type <X>
SELECT FeatureTypes.FeatureTypeName, Features.Mean, Features.MeanMomentum, Features.Variance, Features.Entropy
FROM Features INNER JOIN FeatureTypes
ON Features.FeatureType=FeatureTypes.FeatureTypeID WHERE FeatureId=<X>;



-- User_Platform Querys

-- get the posts from the users
SELECT User_Platform.User_PlatformId, Users.Username, Posts.PostText
FROM ((User_Platform
INNER JOIN Users
ON User_Platform.UserId = Users.UserId)
INNER JOIN Posts
ON User_Platform.PostId = Posts.PostId);




-- (1) TABELA COMPANIES ISOLADA DAS OUTRAS (Recomendacao: Deleta-la)
-- (2) TABELA ROLES ISOLADA DAS OUTRAS     (Recomendacao: Deleta-la)
-- (3) TABELA FEATURES                     (Recomendação: Acrescentar Post_Id em Feature_Type)
-- (4) TABELA Posts ISOLADA DAS OUTRAS     (Recomendação: Acrescentar User_id em Posts)
-- (5) TABELA RELATIONSHIPS IMCOMPLETA     (Recomendação: Acrescentar coluna User_Id)
-- (6) TABELA City LEVEMENTE INCOMPLETA    (Recomendação: Acrescentar coluna User_Id)