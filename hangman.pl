#!/usr/bin/perl

my (@word, @guessWord, @foundChars, $size, $lives, $clr);
$lives=5;

sub adaptClrscrnToOS{
    my $OS=$^O; #  $^O -> built-in variable, indicates OS 
    if($OS eq "MSWin32"){# Windows
        $clr="cls";
    }elsif($OS eq "linux" or $OS eq "darwin"){# linux, OSX
        $clr="clear";
    }
}

my @hangman=(
    '  ____________   ',
    '  |          |   ',
    '  |          O   ',#13
    '  |         /|\  ',#12, 14
    '  |         / \  ',#12, 14
    '  |              ',
    '  |              ',
    '  |              '
    );

my @limbs=(
    [2, 13],
    [3, 12],
    [3, 14],
    [4, 12],
    [4, 14]
    );

sub generateBlankWord{
    $foundChars[ord($word[0])-ord('a')]=1;
    $foundChars[ord($word[$size-1])-ord('a')]=1;
    for(my $i=0; $i<$size; $i++){
        if($word[$i] eq $word[0] or $word[$i] eq $word[$size-1]){
            $guessWord[$i]=$word[$i];           
        }else{
            $guessWord[$i]='.';
        }
    }
}
 
sub findChar{
    my $f=0;
    for(my $i=0; $i<$size; $i++){
        if($word[$i] eq $_[0]){
            $guessWord[$i]=$_[0];
            $foundChars[ord($_[0])-ord('a')]=1;
            $f=1;
        }
    }
    return $f;
}

sub printHangman{
    foreach $i(@hangman){
        print "$i\n";
    }
}

sub main{
    print "Enter the word: ";
    my $w=<STDIN>;
    my $ch;

    chomp($w);
    @word=split("", $w);
    $size=scalar(@word);
    generateBlankWord();
    adaptClrscrnToOS();

    while(1){
        system($clr);
        printHangman();
        print "@guessWord: ";
        print "Congrats!\n" and last if(@word ~~ @guessWord);
        $ch=<STDIN>;
        chomp($ch);
        
        if($foundChars[ord($ch)-ord('a')] == 1){
            print "You have already tried this character\n";
            sleep(1);
            next;
        }

        print "\n";
        if(findChar($ch)==0){
            $lives--;
            substr($hangman[$limbs[$lives][0]], $limbs[$lives][1], 1) = "\ ";
            if($lives<1){
                system($clr);
                print "You ran out of lives!\nThe word was @word\n";
                last;
            }
        }
    }
}
main();