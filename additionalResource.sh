# One Time
 ssh smaster sacct --clusters <cluster-name> --allusers --parsable2 --noheader --allocations --format jobid,jobidraw,cluster,partition,account,group,gid,user,uid,submit,eligible,start,end,elapsed,exitcode,state,nnodes,ncpus,reqcpus,reqmem,reqgres,reqtres,timelimit,nodelist,jobname --state CANCELLED,COMPLETED,FAILED,NODE_FAIL,PREEMPTED,TIMEOUT --starttime $DAYBEFOREYESTERDAY  >/tmp/slurm.log
sed -i.bak '/Unknown/d' /tmp/slurm.log

# Delete unparsable % followed by digits in slurm.log 
sed -r -i.bak 's/%[0-9]+//g' /tmp/slurm.log

# Shredding files
/usr/local/xdmod/bin/xdmod-shredder -r smaster -f slurm -i /tmp/slurm.log
