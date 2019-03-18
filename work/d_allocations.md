1. Create a file (say `/tmp/allocations_logger`) with the following content:
```
set pagination off
set logging file ~/gdb.out

b gc_malloc
commands
	echo === begin malloc\n
	bt
	echo === end malloc
	cont
end

b gc_calloc
commands
	echo === begin calloc\n
	bt
	echo === end calloc
	cont
end

set logging on
set logging redirect on
cont
```

1. Attach to the app via gdb using `gdb -p $PID -x /tmp/allocations_logger`

1. Allocations, if any, will be logged to the `gdb.out` file in your home
   directory.


Note:

If you get an error when trying to attach to the app via gdb, you can either run
gdb as root (not recommended) or do these two things:
- `sudo sysctl kernel.yama.ptrace_scope=0`
- Change the last line of `/etc/sysctl.d/10-ptrace.conf` to `kernel.yama.ptrace_scope = 0`
