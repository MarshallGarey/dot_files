# Copied from Brian's repo:
# https://github.com/gaijin03/cfg/blob/master/.gdbinit
# break in the ctld with scontrol setdebug info
set breakpoint pending on
break _slurm_rpc_set_debug_level
set breakpoint pending auto

set pagination off
set print pretty on
set print null-stop on
set print elements 2000

set debuginfod enabled off

handle SIGUSR1 nostop noprint

define lock
set scheduler-locking on
end
define unlock
set scheduler-locking off
end

define find_job
   set $curr_node = job_list->head
   set $job = (struct job_record *)job_list->head->data
   set $found = 0

   while !$found && $curr_node
     if $job->job_id == $arg0
       p $job->job_id
       p $arg0
       p "YO!"
       set $found = 1
     else
       set $curr_node = $curr_node->next
       set $job = (struct job_record *)$curr_node->data
     end
   end

   if $found
     p "Found it!"
   else
     p "Didn't find it!"
   end
end


define find_node
   set $found = 0
   set $i = 0

   while !$found && $i < node_record_count
     if (!xstrcmp(node_record_table_ptr[$i].name, $arg0))
        set $node = &node_record_table_ptr[$i]
        set $found = 1
     else
        set $i = $i + 1
     end
   end

   if $found
     p "Found it!"
   else
     p "Didn't find it!"
   end
end

define find_part
   set $curr_node = part_list->head
   set $part = (part_record_t *)part_list->head->data
   set $found = 0

   while !$found && $curr_node
     if (!xstrcmp($part.name, $arg0))
       p $part->name
       p $arg0
       p "YO!"
       set $found = 1
     else
       set $curr_node = $curr_node->next
       set $part = (part_record_t *)$curr_node->data
     end
   end

   if $found
     p "Found it!"
   else
     p "Didn't find it!"
   end
end

define find_fed_job
   set $curr_node = fed_job_list->head
   set $job = (fed_job_info_t *)fed_job_list->head->data
   set $found = 0

   while !$found && $curr_node
     if $job->job_id == $arg0
       p $job->job_id
       p $arg0
       p "YO!"
       set $found = 1
     else
       set $curr_node = $curr_node->next
       set $job = (fed_job_info_t *)$curr_node->data
     end
   end

   if $found
     p "Found it!"
   else
     p "Didn't find it!"
   end
end


define print_jobs
   set $curr_node = job_list->head

   while $curr_node
     set $curr_job = (struct job_record *)$curr_node->data
     p $curr_job->job_id
     set $curr_node = $curr_node->next
   end
end

define print_parts
   set $curr_node = part_list->head

   while $curr_node
     set $curr_part = (struct part_record *)$curr_node->data
     p *$curr_part
     set $curr_node = $curr_node->next
   end
end

define print_dbjob_list
   set $curr_node = $arg0->head

   while $curr_node
     set $curr_job = (slurmdb_job_rec_t *)$curr_node->data
     p $curr_job->jobid
     set $curr_node = $curr_node->next
   end
end


define print_assocs
  set logging file /tmp/gdb.txt
  set logging on
  set $i = 0
  while $i < 1000
    p "index:"
    p $i
    p "address:"
    p &assoc_hash[$i]
    print_chain &assoc_hash[$i]
    p "done"
    p ""
    set $i += 1
  end
  set logging off
end

define print_chain
  set $pptr = $arg0
  while $pptr != 0 && *$pptr != 0
    set $ptr = *$pptr
    p "address:"
    p $pptr
    p "user:"
    p $ptr->user
    p "uid:"
    p $ptr->uid
    p "acct:"
    p $ptr->acct
    set $pptr = &$pptr->assoc_next
  end
end


define print_preemptees
   set $curr_node = preemptee_candidates->head

   while $curr_node
     set $curr_job = (struct job_record *)$curr_node->data
     p $curr_job->job_id
     set $curr_node = $curr_node->next
   end
end
