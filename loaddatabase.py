import json

import psycopg2
import gzip
import csv
from tqdm import tqdm

limit = 1_000_000

with open('secret.json') as fp:
    settings = json.load(fp)

conn = psycopg2.connect(
    dbname="imdb", user=settings['username'], password=settings['password'], host=settings['host'], port=settings['port'])

cur = conn.cursor()

cur.execute('DROP SCHEMA IF EXISTS public CASCADE')
cur.execute('CREATE SCHEMA public')

with open('ImdbCreateSchema.sql') as fp:
    queries = fp.read()
cur.execute(queries)


def splitsanitize(val: str):
    return val.split(',') if val != '\\N' else []


titles = set()
names = set()


with gzip.open('dataset/title.basics.tsv.gz', mode="rt") as fp:
    print(next(fp))
    for i, row in enumerate(tqdm(fp, total=limit)):
        if i == limit:
            break
        row = row.strip().split('\t')
        try:

            genres = [(row[0], i) for i in splitsanitize(row[8])]
            for key, col in enumerate(row):
                if col == '\\N':
                    row[key] = None
            del row[8]
            cur.execute('INSERT INTO titlebasics(tconst,titleType,primaryTitle,originalTitle,isAdult,startYear,endYear,runtimeMinutes) VALUES (%s , %s, %s, %s, %s, %s, %s, %s)',
                        row)
            titles.add(row[0])
            cur.executemany('INSERT INTO titlegenre VALUES(%s, %s)', genres)
        except Exception as ex:
            print(row)
            print(ex)
            raise ex


with gzip.open('dataset/title.akas.tsv.gz', mode="rt") as fp:
    print(next(fp))
    for i, row in enumerate(tqdm(fp, total=limit)):
        if i == limit:
            break
        row = row.strip().split('\t')
        try:
            row[6] = splitsanitize(row[6])
            row[5] = splitsanitize(row[5])
            for key, col in enumerate(row):
                if col == '\\N':
                    row[key] = None
            # if row[0]>=maxtitle:
            #     continue
            # cur.execute(
            #     'select count(tconst) from titlebasics where tconst=%s', (row[0],))
            # if cur.fetchone()[0] == 0:
            #     continue
            if row[0] not in titles:
                continue
            cur.execute('INSERT INTO titleakas (titleid, ordering, title, region, language, types, attributes, isoriginaltitle) VALUES (%s , %s, %s, %s, %s, %s, %s, %s)',
                        row)
        except Exception as ex:
            print(row, maxtitle)
            print(ex)
            raise ex

with gzip.open('dataset/name.basics.tsv.gz', mode="rt") as fp:
    print(next(fp))
    for i, row in enumerate(tqdm(fp, total=limit)):
        if i == limit:
            break
        row = row.strip().split('\t')
        row[4] = row[4].split(',')
        row[5] = row[5].split(',')
        try:
            for key, col in enumerate(row):
                if col == '\\N':
                    row[key] = None
            cur.execute('INSERT INTO namebasics VALUES (%s , %s, %s, %s, %s, %s)',
                        row)
            names.add(row[0])
        except Exception as ex:
            print(row)
            print(ex)
            raise ex


with gzip.open('dataset/title.crew.tsv.gz', mode="rt") as fp:
    print(next(fp))
    for i, row in enumerate(tqdm(fp, total=limit)):
        if i == limit:
            break
        row = row.strip().split('\t')
        if row[0] not in titles:
            continue
        row[1] = row[1].split(',') if row[1] != '\\N' else []
        row[2] = row[2].split(',') if row[2] != '\\N' else []
        row[1] = list(filter(lambda x: x in names, row[1]))
        row[2] = list(filter(lambda x: x in names, row[2]))
        try:
            for key, col in enumerate(row):
                if col == '\\N':
                    row[key] = None
            cur.executemany('INSERT INTO titledirector VALUES (%s , %s)',
                            ((row[0], i) for i in row[1]))
            cur.executemany('INSERT INTO titlewriter VALUES (%s , %s)',
                            ((row[0], i) for i in row[2]))
        except Exception as ex:
            print(row, maxtitle, maxname)
            print(ex)
            raise ex

with gzip.open('dataset/title.episode.tsv.gz', mode="rt") as fp:
    print(next(fp))
    failcount = 0
    for i, row in enumerate(tqdm(fp, total=limit)):
        if i == limit:
            break
        row = row.strip().split('\t')
        try:
            for key, col in enumerate(row):
                if col == '\\N':
                    row[key] = None
            # if row[1] >= f'tt{limit:07}':
            #     continue
            if row[1] not in titles:
                continue
            cur.execute('INSERT INTO titleepisode VALUES (%s , %s, %s, %s)',
                        row)
        except Exception as ex:
            print(row)
            print(ex)
            raise ex

with gzip.open('dataset/title.principals.tsv.gz', mode="rt") as fp:
    print(next(fp))
    failcount = 0
    for i, row in enumerate(tqdm(fp, total=limit)):
        if i == limit:
            break
        row = row.strip().split('\t')
        row[4] = splitsanitize(row[4])
        row[5] = splitsanitize(row[5])
        try:
            for key, col in enumerate(row):
                if col == '\\N':
                    row[key] = None
            # if row[0] >= maxtitle:
            #     continue
            if row[0] not in titles:
                continue
            if row[2] not in names:
                continue
            cur.execute(
                'select count(tconst) from titlebasics where tconst=%s', (row[0],))
            if cur.fetchone()[0] == 0:
                continue
            cur.execute('INSERT INTO titleprincipals VALUES (%s , %s, %s, %s, %s, %s)',
                        row)
        except Exception as ex:
            print("ROW", row, maxtitle, maxname)
            print(ex)
            raise ex

with gzip.open('dataset/title.ratings.tsv.gz', mode="rt") as fp:
    print(next(fp))
    failcount = 0
    for i, row in enumerate(tqdm(fp, total=limit)):
        if i == limit:
            break
        row = row.strip().split('\t')
        try:
            for key, col in enumerate(row):
                if col == '\\N':
                    row[key] = None
            # if row[0] >= maxtitle:
            #     continue
            if row[0] not in titles:
                continue
            cur.execute('INSERT INTO titleratings VALUES (%s , %s, %s)',
                        row)
        except Exception as ex:
            print("ROW", row)
            print(ex)
            raise ex

conn.commit()


# conn.commit()
