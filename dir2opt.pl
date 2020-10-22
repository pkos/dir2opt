use strict;
use warnings;
use Term::ProgressBar;

#init
my $substringh = "-h";
my $directory = "";
my $template = "";

#check command line
foreach my $argument (@ARGV) {
  if ($argument =~ /\Q$substringh\E/) {
    print "dir2opt v0.6 - Generate RetroArch game options files from an options template file\n";
    print "               for each game in a directory scan. \n";
	print "\n";
	print "with dir2opt [directory ...] [template]\n";
    print "\n";
	print "Notes:\n";
	print "  [directory] should be the path to the games folder\n";
	print "  [template]  should be the template file containing the game options\n";
	print "\n";
	print "Example:\n";
	print '              dir2opt "D:/ROMS/Atari - 2600" "template.opt"' . "\n";
	print "\n";
	print "Author:\n";
	print "   Discord - Romeo#3620\n";
	print "\n";
    exit;
  }
}

#set directory, system, and extension variables
if (scalar(@ARGV) < 2 or scalar(@ARGV) > 2) {
  print "Invalid command line.. exit\n";
  print "use: dir2opt -h\n";
  print "\n";
  exit;
}
$directory = $ARGV[-2];
$directory =~ s/\\/\//g; 
$template = $ARGV[-1];

#debug
print "directory: $directory\n";
print "template: $template\n";

#exit no parameters
if ($directory eq "") {
  print "Invalid command line.. exit\n";
  print "use: dir2opt -h\n";
  print "\n";
  exit;
}

#init arrays
my @linesf;
my @linestemplate;

#read template file
open(FILE, "<", $template) or die "Could not open $template\n";
while (my $readline = <FILE>) {
   push(@linestemplate, $readline);
}
close (FILE);

#read games directory contents
my $dirname = $directory;
opendir(DIR, $dirname) or die "Could not open $dirname\n";
while (my $filename = readdir(DIR)) {
  if (-d $dirname . "/" . $filename) {
    next;
  } else {
    push(@linesf, $filename) unless $filename eq '.' or $filename eq '..';
    #print "$filename\n";    
  }
}
closedir(DIR);

my $max = scalar(@linesf);
my $progress = Term::ProgressBar->new({name => 'progress', count => $max});

#main loop through files to write output files
foreach my $element (@linesf)
{
   $progress->update($_);

   #parse game name
   my $length = length($element);
   my $rightdot = rindex($element, ".");
   my $suffixlength = $length - $rightdot;
   my $optfile = substr($element, 0, $length - $suffixlength);
   $optfile = $optfile . ".opt";
   
   #write opt file
   open(FILE, '>', $optfile) or die "Could not open file '$optfile' $!";
   foreach my $optline (@linestemplate)
   {
      print FILE "$optline";
   }
   close (FILE);
}

