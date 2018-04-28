SELECT *
FROM customer AS s
JOIN
    (SELECT *
    FROM call AS c
    JOIN
        (SELECT ref_nbr AS ref_nbr2,
         min_interac_id AS first_interac_id,
         number_interactions,
         web_tracks AS first_web_tracks
        FROM
            (SELECT min(intrc_id) AS min_interac_id,
        count(*) AS number_interactions,
         ref_nbr AS ref_nbr_2
            FROM
                (SELECT intrc_id,
        web_tracks,
        ref_nbr
                FROM
                    (SELECT intrc_id AS int_id,
         count(*) AS web_tracks
                    FROM
                        (SELECT *
                        FROM
                            (SELECT intrc_id,
         ref_nbr,
        date_parse(intrc_gmt_tmstp,
        '%m/%d/%Y %k:%i:%s') AS call_time ,intrc_gmt_tmstp
                            FROM call
                            WHERE ref_nbr <> 'ref_nbr') AS a
                            JOIN
                                (SELECT track_nbr,
        date_parse(replace(logged_at,
        '.0',''),'%Y-%m-%d %k:%i:%s') AS track_time
                                FROM webtracks
                                WHERE logged_at <> 'LOGGED_AT') AS b
                                    ON a.ref_nbr = b.track_nbr
                                        AND b.track_time <= a.call_time)
                                GROUP BY  intrc_id) AS a
                                JOIN call AS b
                                    ON a.int_id=b.intrc_id)
                                GROUP BY  ref_nbr) AS a
                                JOIN
                                    (SELECT intrc_id,
        web_tracks,
        ref_nbr
                                    FROM
                                        (SELECT intrc_id AS int_id,
         count(*) AS web_tracks
                                        FROM
                                            (SELECT *
                                            FROM
                                                (SELECT intrc_id,
         ref_nbr,
        date_parse(intrc_gmt_tmstp,
        '%m/%d/%Y %k:%i:%s') AS call_time ,intrc_gmt_tmstp
                                                FROM call
                                                WHERE ref_nbr <> 'ref_nbr') AS a
                                                JOIN
                                                    (SELECT track_nbr,
        date_parse(replace(logged_at,
        '.0',''),'%Y-%m-%d %k:%i:%s') AS track_time
                                                    FROM webtracks
                                                    WHERE logged_at <> 'LOGGED_AT') AS b
                                                        ON a.ref_nbr = b.track_nbr
                                                            AND b.track_time <= a.call_time)
                                                    GROUP BY  intrc_id) AS a
                                                    JOIN call AS b
                                                        ON a.int_id=b.intrc_id) AS b
                                                        ON a.ref_nbr_2 = b.ref_nbr
                                                            AND a.min_interac_id = b.intrc_id) AS b
                                                        ON c.ref_nbr=b.ref_nbr2
                                                            AND c.intrc_id=b.first_interac_id) AS b
                                                    ON s.shp_trk_nbr = b.ref_nbr;
