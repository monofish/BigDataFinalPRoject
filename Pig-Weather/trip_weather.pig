f = load '$INPUT' using PigStorage(',') as (medallion:chararray, hack_license:chararray, vendor_id:chararray, pickup_datetime:chararray, dropoff_datetime:chararray, passenger_count:int, trip_time_in_secs:int, trip_distance:float, pickup_longitude:float, pickup_latitude:float, dropoff_longitude:float, dropoff_latitude:float, fare_amount:float, tip_amount:float, total_amount:float, precipt:float);
f1 = filter f by (trip_distance>0 and trip_distance/trip_time_in_secs<100 and trip_distance<100);
ff = foreach f1 generate pickup_datetime, SUBSTRING(pickup_datetime, 11, 13), ($15>0?1:0);
g = group ff by ($1, $2);
t = foreach g generate flatten(group), COUNT(ff.pickup_datetime);
store t into '$OUTPUT' using PigStorage(',');