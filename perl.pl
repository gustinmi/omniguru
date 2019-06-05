
# variables

my $phrase = "Howdy, world!\n"; # Create a variable.
print $phrase; 					# Print the variable.

# types

# Scalar $

my $cents # An individual value (number or string). 
my $cents = undef; # this is default

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


# Array @
@large # A list of values, keyed by number

my $ary = \@myarray; # reference to a named array
my $hsh = \%myhash; # reference to a named hash
my $sub = \&mysub; # reference to a named subroutine
my $ary = [1,2,3,4,5]; # reference to an unnamed array
my $hsh = {Na => 19, Cl => 35}; # reference to an unnamed hash
my $sub = sub { print $state }; # reference to an unnamed subroutine

my @home = ("couch", "chair", "table", "stove");
$home[0] = "couch";
$home[1] = "chair";fg

$home[2] = "table";
$home[3] = "stove";

# list assignment
my ($potato, $lift, $tennis, $pipe) = @home; # create four scalar varibles
($alpha,$omega) = ($omega,$alpha); # another list assignment

# objects

my $fido = Camel–>new("Amelia"); # reference to an object
if (not $fido) { die "dead camel"; } # 
$fido–>saddle(); # call method 

# Hash %
# A hash is an unordered set of scalars, accessed9 by some string value that is associated with each scalar.
%interest # A group of values, keyed by string

# as list assignment
my %longday = ("Sun", "Sunday", "Mon", "Monday", "Tue", "Tuesday",
 "Wed", "Wednesday", "Thu", "Thursday", "Fri",
 "Friday", "Sat", "Saturday");

# better

my %longday = (
 "Sun" => "Sunday",
 "Mon" => "Monday",
 "Tue" => "Tuesday",
 "Wed" => "Wednesday",
 "Thu" => "Thursday",
 "Fri" => "Friday",
 "Sat" => "Saturday",
);

$longday{"Sat"} = "Saturday";


# Subroutine &
&how # A callable chunk of Perl code

# Typeglob *
*struck #Everything named struck


# executing processes outside interpreter

# executes a command and never returns. It's like a return statement in a function.
# replace the current process with another process.
exec "command";

sub my_system {
    die "could not fork\n" unless defined(my $pid = fork);
    return waitpid $pid, 0 if $pid; #parent waits for child
    exec @_; #replace child with new process
}

# executes a command and your Perl script is continued after the command has finished.
# The return value is the exit status of the command. 
system("command");

#doesn't spawn a shell, arguments are passed as they are
system("command", "arg1", "arg2", "arg3");

#spawns a shell, arguments are interpreted by the shell, use only if you
#want the shell to do globbing (e.g. *.txt) for you or you want to redirect
#output
system("command arg1 arg2 arg3");


# like system
# In contrary to system the return value is STDOUT of the command.
print `command`;  # also possible :  qx/command/

#in list context it returns the output as a list of lines
my @lines = qx/command arg1 arg2 arg3/;

#in scalar context it returns the output as one string
my $output = qx/command arg1 arg2 arg3/;

## OPEN
# run a process and create a pipe to its STDIN or STDERR

#read from a gzip file as if it were a normal file
open my $read_fh, "-|", "gzip", "-d", $filename
    or die "could not open $filename: $!";

#write to a gzip compressed file as if were a normal file
open my $write_fh, "|-", "gzip", $filename
    or die "could not open $filename: $!";
