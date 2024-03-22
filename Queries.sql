
-- 1. to get the directors in the order of their rating from highest to lowest
select movieRatingDirector.nconst,namebasics.primaryname,
       avg(movieRatingDirector.averageRating) totalAverageRating
from ((titlebasics natural join titleratings) movieRatings natural join titledirector) movieRatingDirector
         natural join namebasics
group by(movieRatingDirector.nconst, namebasics.primaryname)
order by(totalAverageRating) desc;

--2. returns the number of crew in a movie
select tb.primaryTitle, tb.tconst, count(tp.nconst) numberofcrew
from titlebasics tb
         join titleprincipals tp on tb.tconst = tp.tconst
group by(tb.tconst)
order by(numberofcrew);

--3. list all the writers of a particular title
select titleandwriter.primaryTitle, titleandwriter.tconst, nb.primaryName
from (titlebasics natural join titlewriter) titleandwriter
         natural join namebasics nb;


--4. title for which a person is famous for (NOT WORKING)
select nameandtitles.primaryName, tb.primaryTitle, tb.originalTitle
from (namebasics natural join knownfortitles) nameandtitles
         natural join titlebasics tb;

--5. giving all movie details along with the additional info
select titleRating.primaryTitle,
       titleRating.originalTitle,
       titleRating.averageRating,
       titleRating.numVotes,
       ta.language
from (titlebasics tb join titleratings tr on tb.tconst = tr.tconst) titleRating
         natural join titleakas ta limit 10;


--6. the count of all works from a particular language; (QUERY TIMEOUT)
select ta.language, count(ta.titleid)
from titlebasics tb
         natural join titleakas ta
group by(ta.language)
having (count(tb.tconst) > 1000);

--7. Genre list in the order of their likeness
select genre, Count(genre) as genreRating 
from ((titlebasics natural join titleratings) movieRatings
	  join titlegenre as gen on gen.titleid = movieRatings.tconst)
	 group by(genre)
	  order by(genreRating) desc


-- FEW MORE QUERIES FOR MILESTONE 2


--8. All the movies with less than 3 hrs of runnning time order by their ratings
select tb.titletype, tb.primarytitle, t.averagerating,tb.titletype, tb.startyear as year, t.numvotes
from titlebasics tb join titleratings t
                         on tb.tconst = t.tconst
where runtimeminutes <3*60  and numvotes>1000                                                                                                                                                            and titletype like 'movie'
order by t.averagerating desc, tb.startyear desc ,t.numvotes desc , tb.runtimeminutes desc;


--9. All the movies with less than 3 hrs of runnning time order by their ratings in english language
select primarytitle, averagerating, runtimeminutes,startyear as year, numvotes
from titlebasics tb join titleratings t
                         on tb.tconst = t.tconst join titleakas ta on ta.titleid=t.tconst
where runtimeminutes <3*60    and ta.language like 'en' and titletype like 'movie' and numvotes>1000
group by titletype, primarytitle, averagerating,titletype, startyear,numvotes, language, runtimeminutes
order by averagerating desc, startyear desc ,numvotes desc , runtimeminutes desc
limit 100;


--10. query listing the directors and their works along with the rating ordered alphabetically
select tr.averagerating ,tdnb.primaryname, tdnb.primaryprofession,tdnb.birthyear, tdnb.deathyear,tdnb.knownfortitles, tdnb.originaltitle, tdnb.runtimeminutes, tdnb.startyear,tdnb.endyear, tdnb.isadult
from ((titledirector td join namebasics n on td.nconst = n.nconst ) tdn natural join titlebasics tb) tdnb natural join  titleratings tr
order by tdnb.primaryname ;


--11. query listing directors based on their average rating of all the movies
select tdnb.primaryname, avg(tr.averagerating) as average_rating, sum(tr.numvotes) total_numvotes, tdnb.primaryprofession
from ((titledirector td join namebasics n on td.nconst = n.nconst ) tdn natural join titlebasics tb) tdnb natural join  titleratings tr
group by tdnb.primaryname, tdnb.primaryprofession order by average_rating desc ;


--12. query listing writers based on their average rating of all the movies
select tdnb.primaryname, avg(tr.averagerating) as average_rating, sum(tr.numvotes) total_numvotes, tdnb.primaryprofession
from ((titlewriter td join namebasics n on td.nconst = n.nconst ) tdn natural join titlebasics tb) tdnb natural join  titleratings tr
group by tdnb.primaryname, tdnb.primaryprofession order by average_rating desc ;


--13. query listing the writers and their works along with the rating ordered alphabetically
select tr.averagerating ,tdnb.primaryname, tdnb.primaryprofession,tdnb.birthyear, tdnb.deathyear, tdnb.originaltitle, tdnb.runtimeminutes, tdnb.startyear,tdnb.endyear, tdnb.isadult
from ((titlewriter td join namebasics n on td.nconst = n.nconst ) tdn natural join titlebasics tb) tdnb natural join  titleratings tr
order by tdnb.primaryname ;

