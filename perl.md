# PERL MAGIC CHEATSHEET

##  Defining variables 
With the use of keyword **my** and **$** sign for scalar values.
Example:
```perl
my $phrase = "Howdy, world!\n"; # Create a scalar variable.
print $phrase; # Print the variable.
```
## Types of variables
### Scalar variables. Use sign : **$**
Examples:
```perl
my $cents = undef; # this is default value of undefined
my $cents = 5; # An individual value (number or string). 
```
More examples:
```perl
my $answer = 42; # an integer
my $pi = 3.14159265; # a "real" number
my $avocados = 6.02e23; # scientific notation
my $pet = "Camel"; # string
my $sign = "I love my $pet"; # string with interpolation
my $cost = 'It costs $100'; # string without interpolation
my $thence = $whence; # another variable's value
my $salsa = $moles * $avocados; # a gastrochemical expression
my $exit = system("vi $file"); # numeric status of a command
my $cwd = `pwd`; # string output from a command
```

### Array variables. Use sign **@**
Define simple array
```perl
my @large = (1,2,3); # A list of values, keyed by number
my $ary = [1,2,3,4,5]; # reference to an unnamed array
```
Accessing array values:
```perl
my @home = ("couch", "chair", "table", "stove");
$home[0] = "couch";
$home[1] = "chair";
$home[2] = "table";
$home[3] = "stove";
```

#### arrays and list assignment (using array on right side)
Using array on the right side of **=** will split it:
```perl
my ($potato, $lift, $tennis, $pipe) = @home; # create four scalar varibles
($alpha,$omega) = ($omega,$alpha); # another example of list assignment
```

### Objects
Using objects:
```perl
use Camel;  # import package with camels
my $fido = Camel–>new("Amelia"); # reference to an object
if (not $fido) { die "dead camel"; } # check if object created
$fido–>saddle(); # call method on object
```

### Hash arrays %
A hash is an unordered set of scalars, accessed9 by some string value that is associated with each scalar.
```perl
%interest # A group of values, keyed by string
```
Not very practical but works : define hash via list assignment
```perl
my %longday = ("Sun", "Sunday", "Mon", "Monday", "Tue", "Tuesday",
 "Wed", "Wednesday", "Thu", "Thursday", "Fri",
 "Friday", "Sat", "Saturday");
```
Better hash definition with **=>** operator
```perl
my %longday = (
 "Sun" => "Sunday",
 "Mon" => "Monday",
 "Tue" => "Tuesday",
 "Wed" => "Wednesday",
 "Thu" => "Thursday",
 "Fri" => "Friday",
 "Sat" => "Saturday",
);
```

#### Accessing hash values
take one / assign just one element. use of $
```perl
$longday{"Sat"} = "Saturday";
```

### Subroutines with sign  **&**
```perl
&how # A callable chunk of Perl code
```

### Typeglob with sign *
```perl
*struck #Everything named struck
```

## Executing processes outside interpreter
### exec ""
Executes a command and never returns. It's like a return statement in a function. Replace the current process with another process.
```perl
exec "command";
```
Example:
```perl
sub my_system {
    die "could not fork\n" unless defined(my $pid = fork);
    return waitpid $pid, 0 if $pid; #parent waits for child
    exec @_; #replace child with new process
}
```

### system()
Executes a command and your Perl script is continued after the command has finished.
The return value is the exit status of the command. 
```perl
system("command");
```
It doesn't spawn a shell, arguments are passed as they are
```perl
system("command", "arg1", "arg2", "arg3");
```
Spawns a shell, arguments are interpreted by the shell, use only if you want the shell to do globbing (e.g. *.txt) for you or you want to redirect output
```perl
system("command arg1 arg2 arg3");
```

### backtick
Like system but In contrary to system the return value is STDOUT of the command.
```perl
print `command`;  # also possible :  qx/command/
```
in list context it returns the output as a list of lines
```perl
my @lines = qx/command arg1 arg2 arg3/;
```
in scalar context it returns the output as one string
```perl
my $output = qx/command arg1 arg2 arg3/;
```

## OPEN
# run a process and create a pipe to its STDIN or STDERR

```perl
#read from a gzip file as if it were a normal file
open my $read_fh, "-|", "gzip", "-d", $filename
    or die "could not open $filename: $!";

#write to a gzip compressed file as if were a normal file
open my $write_fh, "|-", "gzip", $filename
    or die "could not open $filename: $!";
```


## Programming techniques

# using string templates

```perl
#!/usr/bin/env perl
use strict;
use warnings;
print <<'END';
Status: 200
Content-type: text/html

<!doctype html>
<html> HTML Goes Here </html>
END
```
