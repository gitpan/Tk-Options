# -*- perl -*-
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..1\n"; }
BEGIN { unshift(@INC, "/home/e/eserte/lib/perl")}

END {print "not ok 1\n" unless $loaded;}

use Tk;
use Tk::Options;
$loaded = 1;

@opttable =
  (#'loading',
   ['adbfile', '=s', undef, {'short' => 'f'}],
   ['exportfile', '=s', undef],
   ['dumpfile', '=s', '/tmp/dump'],
   ['autoload', '!', 0],
   
   'x11',
   ['bg', '=s', undef, 
    {'sub' =>
     sub {
	 if ($options->{'bg'}) {
	     $top->optionAdd("*background" => $options->{'bg'}, 'userDefault');
	     $top->optionAdd("*backPageColor" => $options->{'bg'},
			     'userDefault');
	 }
     }}],
   ['fg', '=s', undef,
    {'sub' => 
     sub {
	 $top->optionAdd("*foreground" => $options->{'fg'}, 'userDefault')
	   if $options->{'fg'};
     }}],
   ['font', '=s', undef,
    {'sub' =>
     sub {
	 $top->optionAdd("*font" => $options->{'font'}, 'userDefault')
	   if $options->{'font'};
     }}],
   ['i18nfont', '=s', undef,
    {'sub' =>
     sub {
	 if (!$options->{'i18nfont'}) {
	     my(@s) = split(/-/, $top->optionGet('font', 'Font'));
	     if ($#s == 14) {
		 $options->{'i18nfont'} = join('-', @s[0..$#s-2]) . '-%s';
	     }
	 }
     }}],

   'appearance',
   ['infowin', '!', 1, {'label' => 'Balloon', 'help' => 'Switches balloons on or off'}] ,
   ['undermouse', '!', 1,
    {'sub' =>
     sub {
	 $top->optionAdd("*popover" => 'cursor', 'userDefault')
	   if $options->{'undermouse'};
     }}],
   ['fasttemplate', '!', 0],
   ['shortform', '!', 0],
   ['editform', '!', 1],
   ['statustext', '!', 0],
   ['debug', '!', 0, {'short' => 'd'}],
   ['lang', '=s', undef,
    {'choices' => ['en', 'de', 'hr'], 'strict' => 1}],
   ['stderr-extern', '!', 0],

   'extern',
   ['imageviewer', '=s', 'xv %s',
    {'choices' => ['xli %s', 'xloadimage %s', '#NETSCAPE file:%s']}],
   ['internimageviewer', '!', 1],
   ['browsercmd', '=s', '#NETSCAPE %s',
    {'choices' => ['#WEB %s', 'mosaic %s', '#XTERM lynx %s']}],
   ['mailcmd', '=s', '#XTERM mail %s', 
    {'choices' => ['#NETSCAPE mailto:%s', '#XTERM elm %s']}],
   ['netscape', '=s', 'netscape'],
   ['xterm', '=s', 'xterm -e %s',
    {'choices' => ['color_xterm -e %s', 'rxvt -e %s']}],
   
   'dialing',
   ['devphone', '=s', '/dev/cuaa1'],
   ['dialcmd', '=s', '#DIAL %s',
    {'choices' => ['#XTERM dial %s']}],
   ['hangupcmd', '=s', '#HANGUP'],
   ['dialat', '=s', 'ATD',
    {'choices' => ['ATDT', 'ATDP']}],
   
   'adr2tex',
   ['adr2tex-cols', '=i', 8, {'range' => [2, 16]}],
   ['adr2tex-font', '=s', 'sf', 
    {'choices' => ['cmr5', 'cmr10', 'cmr17', 'cmss10', 'cmssi10',
		   'cmtt10 scaled 500', 'cmtt10']}],
   ['adr2tex-headline', '=s', 1],
   ['adr2tex-footer', '=s', 1],
   ['adr2tex-usecrogersort', '!', 1],
   
  );

$options = {};
$optfilename = "t/opttest";
$opt = new Tk::Options(-opttable => \@opttable,
		       -options => $options,
		       -filename => $optfilename);

$opt->set_defaults;
$opt->load_options;
if (!$opt->process_options) {
    die $opt->usage;
}
$top = new MainWindow;
$top->withdraw;

eval {$opt->do_options};

$w = $opt->options_editor($top);
$w->OnDestroy(sub {$top->destroy});

MainLoop;
foreach (sort keys %$options) {
    print "$_ = ", $options->{$_}, "\n";
}
print "ok 1\n";

